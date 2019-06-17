//
//  SYBaseApiRequest.h
//  Pods-SYNetworking_Example
//
//  Created by 陈腾飞 on 2019/1/4.
//

#import <Foundation/Foundation.h>
#import "SYNetworkingDefine.h"
@class SYNetworkingDefine;


@interface SYBaseApiRequest : NSObject

/* 动态化元素部分 */
@property (nonatomic, weak) NSObject<SYApiRequestProtocol> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<SYApiRequestEncryptProtocol> encryptDelegate;
@property (nonatomic, weak) id<SYApiReuqestInterceptor> interceptDelegate;
@property (nonatomic, weak) id<SYAPIReuqestCallBack> _Nullable callBackDelegate;
@property (nonatomic, weak) id<SYNetworkDataReformer> dataReformerDelegate;

@property (nonatomic, strong) NSMutableDictionary *requestParams;   // 方便子类,不需要重复创建请求参数对象
/* 动态化元素部分 */

/* 只读部分 */
@property (nonatomic, copy, readonly) NSString                *methodUrl;   // 子类必须实现

@property (nonatomic, copy, readonly) NSString                *baseUrl;// server地址
@property (nonatomic, strong, readonly) NSString              *fullUrl;// 请求全路径
@property (nonatomic, strong, readonly) NSString              *requestGetUrl;// 请求的数据,以get方式拼接
@property (nonatomic, strong, readonly) id                    params;// 请求的参数
@property (nonatomic, strong, readonly) NSDictionary          *headDict;// 请求的参数
@property (nonatomic, assign, readonly) SYAPIRequestType      requestType;// 方法, 默认SYAPIRequestRequestTypeGet
@property (nonatomic, assign, readonly) SYApiSerializerType   requestSerializerType;// 请求数据类型
@property (nonatomic, assign, readonly) SYApiSerializerType   responseSerializerType;// 返回数据类型
@property (nonatomic, assign, readonly) NSTimeInterval        apiRequestTimeoutInterval;// 请求时间
@property (nonatomic, assign, readonly) SYBaseApiRequestState state;  // 状态
@property (nonatomic, copy) NSString                          *requestUniqueIdentification;
/* 只读部分 */

/* 分组功能支持 */
@property (nonatomic, strong) dispatch_group_t batchGroup;
/* 分组功能支持 */


/* response */
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, assign) SYResponseErrorType errorType;
@property (nonatomic, copy) NSString *errorStr;
@property (nonatomic, copy) id responseObject;
@property (nonatomic, copy) id formatResponseObject;
@property (nonatomic, copy) void (^ _Nullable successBlock)(SYBaseApiRequest * _Nonnull api, id _Nullable responseObject);
@property (nonatomic, copy) void (^ _Nullable failBlock)(SYBaseApiRequest * _Nonnull api, SYResponseErrorType errorType, NSString * _Nullable errStr);
@property (nonatomic, copy) void (^ _Nullable apiRequestConstructingBodyBlock)(id<SYAPIMultipartFormData> _Nonnull formData);
@property (nonatomic, copy) void (^ _Nullable UploadProgressBlock)(SYBaseApiRequest * _Nullable api, NSProgress * _Nullable progress);
@property (nonatomic, copy) void (^ _Nullable DownloadProgressBlock)(SYBaseApiRequest * _Nullable api, NSProgress * _Nullable progress);
/* response */

/* cache */
/* cache */

/* 功能 */

/**
 是否忽略配置项

 @return YES忽略, 默认NO
 */
- (BOOL)isIgnoreConfig;

/**
 移除所有关联
 */
- (void)releaseAllReation;
/* 功能 */

@end


