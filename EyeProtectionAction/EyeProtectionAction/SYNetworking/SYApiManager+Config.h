//
//  SYApiManager+Config.h
//  SYNetworking
//
//  Created by shirly on 2019/3/11.
//  Copyright © 2019年 ChenTF. All rights reserved.
//

#import "SYApiManager.h"
@class SYApiManager;

// 为了方便直接从SYBaseApiRequest中取数据设置, 同时定义了默认值
@interface SYApiManager (Config)

- (NSString *)serviceUrlForApi:(SYBaseApiRequest *_Nonnull)request BaseUrl:(NSString *)baseUrl;

- (SYAPIRequestType)requestTypeForApi:(SYBaseApiRequest *_Nonnull)request;

- (NSDictionary *_Nullable)headForApi:(SYBaseApiRequest *_Nonnull)request;

- (id)paramsForApi:(SYBaseApiRequest *_Nonnull)request;

- (SYApiSerializerType)requestSerializerForApi:(SYBaseApiRequest *_Nonnull)request;

- (SYApiSerializerType)responseSerializerForApi:(SYBaseApiRequest *_Nonnull)request;

- (NSTimeInterval)apiRequestTimeoutIntervalForApi:(SYBaseApiRequest *_Nonnull)request;

@end

