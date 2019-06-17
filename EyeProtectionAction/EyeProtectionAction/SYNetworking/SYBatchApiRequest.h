//
//  SYBatchApiRequest.h
//  Pods
//
//  Created by shirly on 2019/1/5.
//

#import <Foundation/Foundation.h>
#import "SYNetworkingDefine.h"
@class SYNetworkingDefine;
#import "SYBaseApiRequest.h"
@class SYBaseApiRequest;
@class SYApiManager;


@interface SYBatchApiRequest : NSObject

/**
 *  Batch 执行的API Requests 集合
 */
@property (nonatomic, strong, readonly, nonnull) NSMutableArray *apiRequestsList;

/**
 *  Batch Requests 执行完成之后调用的delegate
 */
@property (nonatomic, weak, nullable) id<SYBatchApiRequestProtocol> delegate;

/**
 *  将API 加入到BatchRequest Set 集合中
 */
- (void)addAPIRequest:(nonnull SYBaseApiRequest *)api;

/**
 *  将带有API集合的Sets 赋值
 */
- (void)addBatchAPIRequests:(nonnull NSArray<SYBaseApiRequest *> *)apis;

@end
