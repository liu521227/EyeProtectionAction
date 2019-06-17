//
//  SYNetworkingDefine.h
//  Pods
//
//  Created by 陈腾飞 on 2019/1/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SYBaseApiRequest;
@class SYBatchApiRequest;


typedef NS_ENUM(NSUInteger, SYBaseApiRequestState) {
    SYBaseApiRequestStateNotLaunch,
    SYBaseApiRequestStateWait,
    SYBaseApiRequestStateLoading,
    SYBaseApiRequestStateCancel,
    SYBaseApiRequestStateSucceed,
    SYBaseApiRequestStateCompletion,
};

typedef NS_ENUM (NSUInteger, SYAPIRequestType){
    SYAPIRequestRequestTypePost,
    SYAPIRequestRequestTypeGet,
//    SYAPIRequestRequestTypePut,
//    SYAPIRequestRequestTypeDelete,
};

typedef NS_ENUM(NSUInteger, SYApiSerializerType) {
    SYApiSerializerTypeHTTP,
    SYApiSerializerTypeJSON,
};

typedef NS_ENUM(NSUInteger, SYResponseErrorType) {
    SYResponseErrorTypeNoError = 0,  // 默认, 未设置
    SYResponseErrorTypeInterceptor,  // 被拦截
    SYResponseErrorTypeNoWLAN,       // 无网络
    SYResponseErrorTypeTimeout,      // 超时
    SYResponseErrorTypeCanceled,     // 被取消
    SYResponseErrorTypeParams,       // 参数存在问题,发起失败
    SYResponseErrorTypeResponseError,     // 请求发起后,返回失败
};

typedef NS_ENUM(NSUInteger, SYAPIManagerCancelReuqestType) {
    SYAPIManagerCancelReuqestTypeNone,  // 不处理
    SYAPIManagerCancelReuqestTypeFirst, // 取消前一个
    SYAPIManagerCancelReuqestTypeLast,  // 取消后一个
};

#pragma mark - 数据发起前
/*************************************************************************************/
@protocol SYApiRequestProtocol <NSObject>
@required
- (NSString *)methodNameForApi:(SYBaseApiRequest *_Nonnull)request;

@optional
- (NSString *)serviceUrlForApi:(SYBaseApiRequest *_Nonnull)request;
- (SYAPIRequestType)requestTypeForApi:(SYBaseApiRequest *_Nonnull)request;              // 默认SYAPIRequestRequestTypeGet

- (NSDictionary *_Nullable)headForApi:(SYBaseApiRequest *_Nonnull)request;
- (NSDictionary *_Nullable)paramsForApi:(SYBaseApiRequest *_Nonnull)request;

- (SYApiSerializerType)requestSerializerForApi:(SYBaseApiRequest *_Nonnull)request;     // 默认SYApiSerializerTypeHTTP
- (SYApiSerializerType)responseSerializerForApi:(SYBaseApiRequest *_Nonnull)request;    // 默认SYApiSerializerTypeJSON

- (NSTimeInterval)apiRequestTimeoutIntervalForApi:(SYBaseApiRequest *_Nonnull)request;  // 默认30
@end

/*************************************************************************************/
@protocol SYApiReuqestInterceptor <NSObject>
@optional
// 发送前
- (BOOL)request:(SYBaseApiRequest *_Nonnull)api shouldCallAPIWithParams:(id _Nullable)params;
- (void)request:(SYBaseApiRequest *_Nonnull)api didCallAPIWithParams:(id _Nullable)params;

// 成功回调
- (BOOL)request:(SYBaseApiRequest *_Nonnull)api shouldPerformCallbackSuccessWithResponse:(id _Nonnull)response;
- (void)request:(SYBaseApiRequest *_Nonnull)api didPerformCallbackSuccessWithResponse:(id _Nonnull)response;

// 失败回调
- (BOOL)request:(SYBaseApiRequest *_Nonnull)api shouldPerformCallbackFailWithErrorType:(SYResponseErrorType)errorType ErrorStr:(NSString *)errorStr;
- (void)request:(SYBaseApiRequest *_Nonnull)api didPerformCallbackFailWithErrorType:(SYResponseErrorType)errorType ErrorStr:(NSString *)errorStr;

@end

/*************************************************************************************/
@protocol SYApiRequestEncryptProtocol <NSObject>
@required
- (id)EncryptParamsWithRequest:(SYBaseApiRequest *_Nonnull)api originParam:(NSDictionary *)params;
@end


#pragma mark - 数据收到后
/*************************************************************************************/
@protocol SYNetworkDataReformer <NSObject, NSCopying>
@required
- (id _Nullable)request:(SYBaseApiRequest * _Nonnull)request reformData:(id)responseObject;

@end


/*************************************************************************************/
@protocol SYAPIReuqestCallBack <NSObject>
@required
// 返回成功
- (void)requestCallAPIDidSuccess:(SYBaseApiRequest * _Nonnull)request responseObject:(id)responseObject;
// 返回失败
- (void)requestCallAPIDidFailed:(SYBaseApiRequest * _Nonnull)request errorType:(SYResponseErrorType)errorType errorStr:(NSString *)errorStr;
@optional
// 上传进度
- (void)requestCallAPIUploading:(SYBaseApiRequest * _Nonnull)request Progress:(NSProgress *)progress;
// 下载
- (void)requestCallAPIDownloading:(SYBaseApiRequest * _Nonnull)request Progress:(NSProgress *)progress;
@end


#pragma mark -
/*************************************************************************************/
@protocol SYNetworkConfigProtocol <NSObject, SYApiRequestProtocol, SYApiReuqestInterceptor, SYApiRequestEncryptProtocol, SYNetworkDataReformer>
@required
- (NSString *)domain;
@optional
- (SYAPIManagerCancelReuqestType)cancelRequestIfSame;    // 默认为SYAPIManagerCancelReuqestTypeNone
- (NSString *)errorStrFromErrorType:(SYResponseErrorType)type Error:(NSError *)error;
@end

#pragma mark - 暂不支持的

/*************************************************************************************/
@protocol CTPagableAPIManager <NSObject>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSUInteger currentPageNumber;
@property (nonatomic, assign, readonly) BOOL isFirstPage;
@property (nonatomic, assign, readonly) BOOL isLastPage;

- (void)loadNextPage;

@end



#pragma mark -
@protocol SYAPIMultipartFormData

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __nullable __autoreleasing *)error;

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * __nullable __autoreleasing *)error;
- (void)appendPartWithInputStream:(nullable NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType;
- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;
- (void)appendPartWithHeaders:(nullable NSDictionary *)headers
                         body:(NSData *)body;
- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay;

@end


@protocol SYBatchApiRequestProtocol <NSObject>

/**
 *  Batch Requests 全部调用完成之后调用
 *
 *  @param batchApis batchApis
 */
- (void)batchRequestsDidFinished:(nonnull SYBatchApiRequest *)batchApis;

@end
