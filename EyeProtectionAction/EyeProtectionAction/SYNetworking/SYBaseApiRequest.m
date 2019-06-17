//
//  SYBaseApiRequest.m
//  Pods-SYNetworking_Example
//
//  Created by shirly on 2019/1/4.
//

#import "SYBaseApiRequest.h"
#import "SYApiManager+Config.h"
@class SYApiManager;
#import <CommonCrypto/CommonDigest.h>

@implementation SYBaseApiRequest
@synthesize baseUrl = _baseUrl;
@synthesize methodUrl = _methodUrl;
@synthesize fullUrl = _fullUrl;
@synthesize requestGetUrl = _requestGetUrl;
@synthesize params = _params;
@synthesize headDict = _headDict;
@synthesize requestType = _requestType;
@synthesize apiRequestTimeoutInterval = _apiRequestTimeoutInterval;
@synthesize state = _state;


#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _state = SYBaseApiRequestStateNotLaunch;
        _errorType = SYResponseErrorTypeNoError;
        
        if ([self conformsToProtocol:@protocol(SYApiRequestProtocol)]) {
            self.child = (NSObject<SYApiRequestProtocol>*)self;
        } else {
            NSLog(@"子类必须实现SYApiRequestProtocol协议");
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

#pragma mark - 只读

- (NSString *)methodUrl {
    if (!_methodUrl) {
        _methodUrl = [[(NSObject<SYApiRequestProtocol>*)self methodNameForApi:self] copy];
    }
    return _methodUrl;
}

- (NSString *)baseUrl {
    
    if (self.isIgnoreConfig) {
        return _baseUrl;
    }
    
    if (!_baseUrl) {
        _baseUrl = [[[SYApiManager sharedInstance] serviceUrlForApi:self BaseUrl:_baseUrl] copy];
    }
    
    NSParameterAssert(_baseUrl);
    
    return _baseUrl;
}

- (NSString *)fullUrl {
    if (!_fullUrl) {
        NSURL *url = [NSURL URLWithString:self.methodUrl relativeToURL:[NSURL URLWithString:self.baseUrl]];
        _fullUrl = url.absoluteString;
    }
    return _fullUrl;
}

- (NSString *)requestGetUrl {
    return @"";
}

- (id)params {
    if (nil == _params) {
        _params = [[SYApiManager sharedInstance] paramsForApi:self];
    }
    return _params;
}

//- (void)setParams:(id)params {
//    _params = params;
//}

- (void)setState:(SYBaseApiRequestState)state {
    _state = state;
}

- (NSDictionary *)headDict {
    if (nil == _headDict) {
        _headDict = [[SYApiManager sharedInstance] headForApi:self];
    }
    return _headDict;
}

- (SYAPIRequestType)requestType {
    return [[SYApiManager sharedInstance] requestTypeForApi:self];
}

- (SYApiSerializerType)requestSerializerType {
    return [[SYApiManager sharedInstance] requestSerializerForApi:self];
}

- (SYApiSerializerType)responseSerializerType {
    return [[SYApiManager sharedInstance] responseSerializerForApi:self];
}

- (NSTimeInterval)apiRequestTimeoutInterval {
    return [[SYApiManager sharedInstance] apiRequestTimeoutIntervalForApi:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ID : %@, full URL : %@", self.requestUniqueIdentification, self.fullUrl];
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"ID : %@, full URL : %@", self.requestUniqueIdentification, self.fullUrl];
}


- (NSString *)requestUniqueIdentification {
    if (_requestUniqueIdentification) {
        return _requestUniqueIdentification;
    } else {
        _requestUniqueIdentification = [self MD5StringWithStr:self.fullUrl];
        return _requestUniqueIdentification;
    }
}
#pragma mark - Private Methods


- (NSString *)MD5StringWithStr:(NSString *)str {
    if (self == nil) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char code[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), code);
    return [NSString
            stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            code[0], code[1], code[2], code[3], code[4], code[5], code[6], code[7],
            code[8], code[9], code[10], code[11], code[12], code[13], code[14],
            code[15]];
}

- (NSDictionary *)paramsForApi:(SYBaseApiRequest *)request {
    return self.requestParams;
}

#pragma mark - Getter & Setter
- (NSMutableDictionary *)requestParams {
    if (!_requestParams) {
        _requestParams = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _requestParams;
}

#pragma mark - Public Methods
- (BOOL)isIgnoreConfig {
    return NO;
}

- (void)releaseAllReation {
    
    self.failBlock = nil;
    self.successBlock = nil;
    self.UploadProgressBlock = nil;
    self.DownloadProgressBlock = nil;
    self.apiRequestConstructingBodyBlock = nil;
    
    self.encryptDelegate = nil;
    self.callBackDelegate = nil;
    self.dataReformerDelegate = nil;
    self.interceptDelegate = nil;
    
    if (self.batchGroup != nil) {
        dispatch_group_leave(self.batchGroup);
        self.batchGroup = nil;
    }
}
@end
