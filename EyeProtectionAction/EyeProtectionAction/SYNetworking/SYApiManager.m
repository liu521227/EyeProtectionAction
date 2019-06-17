//
//  SYApiManager.m
//  Pods
//
//  Created by shirly on 2019/1/4.
//

#import "SYApiManager.h"
#import "AFNetworking.h"
#import "SYApiManager+Config.h"

@interface SYBaseApiRequest ()

@property (nonatomic, assign, readwrite) SYBaseApiRequestState state;  // 状态

@end


@interface SYApiManager ()

@property (nonatomic, strong) dispatch_queue_t requestQueue;

@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *configDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SYBaseApiRequest *> *requestDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, AFHTTPSessionManager *> *sessionManagerCache;
@end

@implementation SYApiManager

#pragma mark - Public Methods
static SYApiManager *instance;
+ (SYApiManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SYApiManager alloc] init];
        instance.requestQueue = dispatch_queue_create("com.kuaigoudache.synetworking", DISPATCH_QUEUE_CONCURRENT);
    });
    return instance;
}

- (BOOL)isContaintAPI:(SYBaseApiRequest *)api {
    return [self apiFormRequestUniqueIdentification:api.requestUniqueIdentification] != nil;
}

- (SYBaseApiRequest *)apiFormRequestUniqueIdentification:(NSString *)ruid {
    
    @synchronized (self.requestDict) {
        return [self.requestDict objectForKey:ruid];
    }
}

- (void)loadBatchAPI:(SYBatchApiRequest *)api {
    dispatch_group_t group = dispatch_group_create();
    
    [api.apiRequestsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_group_enter(group);
        ((SYBaseApiRequest *)obj).batchGroup = group;
        [self loadAPI:obj];
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([api.delegate respondsToSelector:@selector(batchRequestsDidFinished:)]) {
            [api.delegate batchRequestsDidFinished:api];
        }
    });
}

- (void)loadAPI:(SYBaseApiRequest *)api {
    api.state = SYBaseApiRequestStateWait;
    
    dispatch_async(self.requestQueue, ^{    // 因为有加密, 拦截 有可能会变成耗时操作, 所以加入异步队列防阻塞
        @synchronized (self.requestDict) {
            
            NSLog(@"[SYApiManager loadAPI] Will launch API: %@", api.fullUrl);
            
            __weak typeof(self) weakSelf = self;
            id<SYNetworkConfigProtocol> config = [self configForAPI:api];
            // TODO: v2.0 加入并发数量控制
            
            // TODO: 加入网络状态判断
            
            
            
            /* 创建请求 开始 */
            AFHTTPSessionManager *manager = [self sessionManagerForAPI:api];
            
            // 成功回调
            void (^successBlock)(NSURLSessionDataTask *task, id responseObject)
            = ^(NSURLSessionDataTask * task, id responseObject) {
                [weakSelf successedOnCallingAPI:api response:responseObject];
            };
            
            // 失败回调
            void (^failureBlock)(NSURLSessionDataTask * task, NSError * error)
            = ^(NSURLSessionDataTask * task, NSError * error) {
                [weakSelf failedOnCallingAPI:api withErrorType:SYResponseErrorTypeResponseError withError:error];
                //        if (strongSelf.configuration.isNetworkingActivityIndicatorEnabled) {
                //            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                //        }
            };
            
            // 进度回调
            void (^progressBlock)(NSProgress *progress)
            = ^(NSProgress *progress) {
                
                if (progress.totalUnitCount <= 0) {
                    return;
                }
                
                if (api.requestType == SYAPIRequestRequestTypePost) {
                    // 上传
                    if ([api.callBackDelegate respondsToSelector:@selector(requestCallAPIUploading:Progress:)]) {
                        [api.callBackDelegate requestCallAPIUploading:api Progress:progress];
                    }
                    if (api.UploadProgressBlock) {
                        api.UploadProgressBlock(api, progress);
                    }
                } else if (api.requestType == SYAPIRequestRequestTypeGet) {
                    // 下载
                    if ([api.callBackDelegate respondsToSelector:@selector(requestCallAPIDownloading:Progress:)]) {
                        [api.callBackDelegate requestCallAPIDownloading:api Progress:progress];
                    }
                    if (api.DownloadProgressBlock) {
                        api.DownloadProgressBlock(api, progress);
                    }
                }
            };
            
            /* 发起前移除 开始 */
            // 如果有相同的请求, 移除前一个/移除后一个
            SYAPIManagerCancelReuqestType type = SYAPIManagerCancelReuqestTypeNone;
            if ([config respondsToSelector:@selector(cancelRequestIfSame)]) {
                type = [config cancelRequestIfSame];
            }
            
            
            SYBaseApiRequest *firstAPI = [self.requestDict objectForKey:api.requestUniqueIdentification];
            if (firstAPI == nil) {
                for (SYBaseApiRequest *item in self.requestDict.allValues) {
                    if (item.state == SYBaseApiRequestStateLoading && [item.fullUrl isEqualToString:api.fullUrl]) {
                        firstAPI = item;
                    }
                }
            }
            
            if (firstAPI) {
                // 如果重复,需要重命名. 防止查询错误
                api.requestUniqueIdentification = [NSString stringWithFormat:@"%@|T:%f", api.requestUniqueIdentification, CACurrentMediaTime()];
            }
            
            if (firstAPI && type == SYAPIManagerCancelReuqestTypeFirst) {
                NSLog(@"[SYApiManager loadAPI] *前*一个 重复的请求被取消. API:%@", firstAPI);
                [self cancelAPIWithRequest:firstAPI];
                
            } else if (firstAPI && type == SYAPIManagerCancelReuqestTypeLast) {
                NSLog(@"[SYApiManager loadAPI] *后*一个 重复的请求被取消. API : %@", api);
                [self failedOnCallingAPI:api withErrorType:SYResponseErrorTypeCanceled withError:nil];
                return;
                
            } else if (firstAPI && type == SYAPIManagerCancelReuqestTypeNone) {
                
            }
            /* 发起前移除 结束 */
            
            
            
            // 拦截: 发送前
            if ([api.interceptDelegate respondsToSelector:@selector(request:shouldCallAPIWithParams:)]) {
                
                BOOL isBreak = [api.interceptDelegate request:api shouldCallAPIWithParams:api.params];
                if (isBreak) {
                    [self failedOnCallingAPI:api withErrorType:SYResponseErrorTypeInterceptor withError:nil];
                    return;
                }
            } else if ([config respondsToSelector:@selector(request:shouldCallAPIWithParams:)]) {
                
                BOOL isBreak = [config request:api shouldCallAPIWithParams:api.params];
                if (isBreak) {
                    [self failedOnCallingAPI:api withErrorType:SYResponseErrorTypeInterceptor withError:nil];
                    return;
                }
            }
            
            
            // 发起
            NSURLSessionDataTask *dataTask = nil;
            switch (api.requestType) {
                case SYAPIRequestRequestTypeGet:{
                    dataTask = [manager GET:api.fullUrl parameters:api.params progress:progressBlock success:successBlock failure:failureBlock];
                }
                    break;
                case SYAPIRequestRequestTypePost:{
                    
                    if ([api apiRequestConstructingBodyBlock]) {
                        void (^block)(id <AFMultipartFormData> formData)
                        = ^(id <AFMultipartFormData> formData) {
                            api.apiRequestConstructingBodyBlock((id<SYAPIMultipartFormData>)formData);
                        };
                        dataTask = [manager POST:api.fullUrl
                                      parameters:api.params
                       constructingBodyWithBlock:block
                                        progress:progressBlock
                                         success:successBlock
                                         failure:failureBlock];
                    } else {
                        dataTask = [manager POST:api.fullUrl
                                      parameters:api.params
                                        progress:progressBlock
                                         success:successBlock
                                         failure:failureBlock];
                    }
                }
                    break;
                    //        case SYAPIRequestRequestTypePut:{
                    //
                    //        }
                    //            break;
                    //        case SYAPIRequestRequestTypeDelete:{
                    //
                    //        }
                    //            break;
                    
                default:
                    break;
            }
            /* 创建请求 结束 */
            
            if (dataTask) {
                api.state = SYBaseApiRequestStateLoading;
                api.dataTask = dataTask;
                NSLog(@"[SYApiManager loadAPI] launch API: %@", api);
                
                [self.requestDict setObject:api forKey:api.requestUniqueIdentification];
                
                // 拦截: 发送后
                if ([api.interceptDelegate respondsToSelector:@selector(request:didCallAPIWithParams:)]) {
                    [api.interceptDelegate request:api didCallAPIWithParams:api.params];
                } else if ([config respondsToSelector:@selector(request:didCallAPIWithParams:)]) {
                    [config request:api didCallAPIWithParams:api.params];
                }
                
            } else {
                NSLog(@"[SYApiManager loadAPI] launch Error!!!. API: %@", api);
                [self failedOnCallingAPI:api withErrorType:SYResponseErrorTypeParams withError:nil];
            }
            
        }
        
    });
}

- (void)successedOnCallingAPI:(SYBaseApiRequest *)request response:(id)response {
    
    if (request.state != SYBaseApiRequestStateLoading && request.state != SYBaseApiRequestStateWait) {
        // 已经返回过, 所以取消
        NSLog(@"已经返回过, 所以取消. request: %@", request);
        return;
    }
    
    
    dispatch_async(self.requestQueue, ^{
        NSLog(@"[SYApiManager successedOnCallingAPI] request : %@", request);
        
        id<SYNetworkConfigProtocol> config = [self configForAPI:request];
        
        request.responseObject = response;
        request.state = SYBaseApiRequestStateSucceed;
        
        // 数据转换
        if ([request.dataReformerDelegate respondsToSelector:@selector(request:reformData:)]) {
            request.formatResponseObject = [request.dataReformerDelegate request:request reformData:request.responseObject];
        } else if ([config respondsToSelector:@selector(request:reformData:)]) {
            request.formatResponseObject = [config request:request reformData:request.responseObject];
        }
        
        // 拦截: 成功回调前
        if ([request.interceptDelegate respondsToSelector:@selector(request:shouldPerformCallbackSuccessWithResponse:)]) {
            BOOL isBreak = [request.interceptDelegate request:request shouldPerformCallbackSuccessWithResponse:response];
            if (isBreak) {
                [self failedOnCallingAPI:request withErrorType:SYResponseErrorTypeInterceptor withError:nil];
                return;
            }
        } else if ([config respondsToSelector:@selector(request:shouldPerformCallbackSuccessWithResponse:)]) {
            BOOL isBreak = [config request:request shouldPerformCallbackSuccessWithResponse:response];
            if (isBreak) {
                [self failedOnCallingAPI:request withErrorType:SYResponseErrorTypeInterceptor withError:nil];
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id result = request.responseObject;
            if (request.formatResponseObject) {
                result = request.formatResponseObject;
            }
            
            if ([request.callBackDelegate respondsToSelector:@selector(requestCallAPIDidSuccess:responseObject:)]) {
                [request.callBackDelegate requestCallAPIDidSuccess:request responseObject:result];
            }
            if (request.successBlock) {
                request.successBlock(request, result);
            }
            
            // 拦截: 成功回调后
            if ([request.interceptDelegate respondsToSelector:@selector(request:didPerformCallbackSuccessWithResponse:)]) {
                [request.interceptDelegate request:request didPerformCallbackSuccessWithResponse:request.responseObject];
            } else if ([config respondsToSelector:@selector(request:didPerformCallbackSuccessWithResponse:)]) {
                [config request:request didPerformCallbackSuccessWithResponse:request.responseObject];
            }
            
            [self removeAPIForID:request.requestUniqueIdentification LockID:self.requestDict];
        });
        
    });
}

// TODO: 测试cancel是否会走两次
- (void)failedOnCallingAPI:(SYBaseApiRequest *)request withErrorType:(SYResponseErrorType)errorType withError:(NSError *)error {
    // 防止二次拦截处理
    if (errorType == SYResponseErrorTypeInterceptor) {
        [self removeAPIForID:request.requestUniqueIdentification LockID:self.requestDict];
        return ;
    }
    
    if (request.state != SYBaseApiRequestStateLoading && request.state != SYBaseApiRequestStateWait) {
        // 已经返回过, 所以取消
        NSLog(@"已经返回过, 所以取消. request: %@", request);
        return;
    }
    
    // 更新状态
    request.state = SYBaseApiRequestStateCompletion;
    if (errorType == SYResponseErrorTypeCanceled) {
        request.state = SYBaseApiRequestStateCancel;
    }
    
    
    dispatch_async(self.requestQueue, ^{
        NSLog(@"[SYApiManager failedOnCallingAPI] request : %@, errorType : %lu, error : %@", request, (unsigned long)errorType, error);
        
        
        id<SYNetworkConfigProtocol> config = [self configForAPI:request];
        
        //将NSError转换成 自己的Error信息
        NSString *formatErrorStr = [self errorStrFromErrorType:errorType Error:error];
        if ([config respondsToSelector:@selector(errorStrFromErrorType:Error:)]) {
            formatErrorStr = [config errorStrFromErrorType:errorType Error:error];
        }
        request.errorType = errorType;
        request.errorStr = formatErrorStr;
        
        
        // 拦截: 失败回调前
        if ([request.interceptDelegate respondsToSelector:@selector(request:shouldPerformCallbackFailWithErrorType:ErrorStr:)]) {
            BOOL isBreak = [request.interceptDelegate request:request shouldPerformCallbackFailWithErrorType:errorType ErrorStr:formatErrorStr];
            if (isBreak) {
                [self removeAPIForID:request.requestUniqueIdentification LockID:self.requestDict];
                return;
            }
        } else if ([config respondsToSelector:@selector(request:shouldPerformCallbackFailWithErrorType:ErrorStr:)]) {
            BOOL isBreak = [config request:request shouldPerformCallbackFailWithErrorType:errorType ErrorStr:formatErrorStr];
            if (isBreak) {
                [self removeAPIForID:request.requestUniqueIdentification LockID:self.requestDict];
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([request.callBackDelegate respondsToSelector:@selector(requestCallAPIDidFailed:errorType:errorStr:)]) {
                [request.callBackDelegate requestCallAPIDidFailed:request errorType:errorType errorStr:formatErrorStr];
            }
            if (request.failBlock) {
                request.failBlock(request, errorType, formatErrorStr);
            }
            
            // 拦截: 失败回调后
            if ([request.interceptDelegate respondsToSelector:@selector(request:didPerformCallbackFailWithErrorType:ErrorStr:)]) {
                [request.interceptDelegate request:request didPerformCallbackFailWithErrorType:errorType ErrorStr:formatErrorStr];
                
            } else if ([config respondsToSelector:@selector(request:didPerformCallbackFailWithErrorType:ErrorStr:)]) {
                [config request:request didPerformCallbackFailWithErrorType:errorType ErrorStr:formatErrorStr];
            }
            
            
            [self removeAPIForID:request.requestUniqueIdentification LockID:self.requestDict];
        });
        
    });
}

- (void)cancelAPIWithRequest:(SYBaseApiRequest *)request {
    
    // TODO: 测试取消后,回调的block还会走吗? 如果走,需要移除delegate
    [request.dataTask cancel];
    [self failedOnCallingAPI:request withErrorType:SYResponseErrorTypeCanceled withError:nil];
}

- (void)removeAPIForID:(NSString *)requestID LockID:(id)lockID {
    
    if (![requestID isKindOfClass:[NSString class]]) {
        return;
    }
    
    @synchronized (lockID) {
        SYBaseApiRequest *api = [self.requestDict objectForKey:requestID];//[self apiFormRequestUniqueIdentification:requestID];
        if (!api) {
            return;
        }
        
        [api releaseAllReation];
        
        [self.requestDict removeObjectForKey:api.requestUniqueIdentification];
    }
}

#pragma mark - 数据拼接

- (void)addConfig:(id<SYNetworkConfigProtocol>)config {
    NSParameterAssert(config);
    NSParameterAssert(config.domain);
    
    
    [self.configDict setObject:config forKey:config.domain];
}



- (id<SYNetworkConfigProtocol>)configForBaseUrl:(NSString *)baseUrl {
    
    id config = nil;
    
    if (baseUrl) {
        config = [self.configDict objectForKey:baseUrl];
    }
    if (!config) {
        config = [self.configDict objectForKey:@"*"];
    }
    
    return config;
}


- (id<SYNetworkConfigProtocol>)configForAPI:(SYBaseApiRequest *)api {
    if (api.isIgnoreConfig) {
        NSLog(@"忽略配置项 API Method:%@", api.methodUrl);
        return nil;
    }
    
    return [self configForBaseUrl:api.baseUrl];
}


- (AFHTTPSessionManager *)sessionManagerForAPI:(SYBaseApiRequest *)api {
    
    NSString *baseUrlStr = api.baseUrl;
    
    AFHTTPSessionManager *sessionManager;
    @synchronized (self.sessionManagerCache) {
        sessionManager = [self.sessionManagerCache objectForKey:baseUrlStr];
        if (!sessionManager) {
            NSLog(@"[SYApiManager SessionManagerForAPI] Create SessionManager For BaseUrl : %@", baseUrlStr);
            sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlStr]];
            [self.sessionManagerCache setObject:sessionManager forKey:baseUrlStr];
        }
    }
    
    sessionManager.requestSerializer = [self requestSerializerForAPI:api];
    sessionManager.responseSerializer = [self responseSerializerForAPI:api];
    
    // TODO: v2.0 加入SSL验证设置
    //    sessionManager.securityPolicy        = [self securityPolicyWithAPI:api];
    return sessionManager;
}

- (AFHTTPRequestSerializer *)requestSerializerForAPI:(SYBaseApiRequest *)api {
    NSParameterAssert(api);
    
    
    AFHTTPRequestSerializer *requestSerializer;
    
    if (api.requestSerializerType == SYApiSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    
    // 缓存, 超时
    //    requestSerializer.cachePolicy          = [api apiRequestCachePolicy];
    requestSerializer.timeoutInterval      = [api apiRequestTimeoutInterval];
    
    
    // HEAD
    if (api.headDict) {
        [api.headDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializerForAPI:(SYBaseApiRequest *)api {
    NSParameterAssert(api);
    
    AFHTTPResponseSerializer *responseSerializer;
    
    if (api.responseSerializerType == SYApiSerializerTypeJSON) {
        responseSerializer = [AFJSONResponseSerializer serializer];
    } else {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/javascript",@"application/json",@"text/html",@"text/plain", nil];
    return responseSerializer;
}

#pragma mark - 执行类

#pragma mark - Getters & Setters
- (NSMutableDictionary<NSString *,SYBaseApiRequest *> *)requestDict {
    if (!_requestDict) {
        _requestDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _requestDict;
}

- (NSMutableDictionary<NSString *,id> *)configDict {
    if (!_configDict) {
        _configDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _configDict;
}

- (NSMutableDictionary<NSString *,AFHTTPSessionManager *> *)sessionManagerCache {
    if (!_sessionManagerCache) {
        _sessionManagerCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _sessionManagerCache;
}

#pragma mark -
- (NSString *)errorStrFromErrorType:(SYResponseErrorType)type Error:(NSError *)error {
    
    NSString *errorStr = @"发生未知错误,请稍后重试";
    if (error) {
        errorStr = error.localizedDescription;
    }
    
    if (error && (type == SYResponseErrorTypeNoError || type == SYResponseErrorTypeResponseError)) {
        
#warning "临时修改,需要更新pod库"
        if (error.code == NSURLErrorCancelled) {
            errorStr = @"请求被取消";
        } else if (error.code == NSURLErrorTimedOut) {
            errorStr = @"请求超时,请重试";
        } else if (error.code == NSURLErrorNotConnectedToInternet) {
            errorStr = @"网络错误,请检查手机网络设置";
        }
    } else {
        
        switch (type) {
            case SYResponseErrorTypeCanceled: {
                errorStr = @"请求被取消";
            }break;
            case SYResponseErrorTypeInterceptor: {
                errorStr = @"请求被拦截";
            }break;
                //            case SYResponseErrorTypeNetError: {
                //                errorStr = @"网络状态不好,请稍后重试";
                //            }break;
            case SYResponseErrorTypeNoWLAN: {
                errorStr = @"网络权限未打开,请在设置中打开网络权限";
            }break;
            case SYResponseErrorTypeParams: {
                errorStr = @"请求参数有误,取消请求";
            }break;
            case SYResponseErrorTypeTimeout: {
                errorStr = @"请求超时,请重试";
            }break;
            default:
                break;
        }
    }
    return errorStr;
}
@end
