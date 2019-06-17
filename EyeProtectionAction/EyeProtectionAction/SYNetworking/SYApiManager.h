//
//  SYApiManager.h
//  Pods
//
//  Created by 陈腾飞 on 2019/1/4.
//

#import <Foundation/Foundation.h>
#import "SYNetworkingDefine.h"
#import "SYBaseApiRequest.h"
#import "SYBatchApiRequest.h"


@interface SYApiManager : NSObject

+ (SYApiManager *)sharedInstance;

// 是否存在
- (BOOL)isContaintAPI:(SYApiManager *)api;
- (SYBaseApiRequest *)apiFormRequestUniqueIdentification:(NSString *)ruid;

// 单个请求接口
- (void)loadAPI:(SYBaseApiRequest *)api;
- (void)cancelAPIWithRequest:(SYBaseApiRequest *)api;

// 一组请求接口
- (void)loadBatchAPI:(SYBatchApiRequest *)api;

- (void)addConfig:(id<SYNetworkConfigProtocol>)config;
- (id<SYNetworkConfigProtocol>)configForBaseUrl:(NSString *)baseUrl;
- (id<SYNetworkConfigProtocol>)configForAPI:(SYBaseApiRequest *)api;
@end
