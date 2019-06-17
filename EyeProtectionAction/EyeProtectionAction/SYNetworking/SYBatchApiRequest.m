//
//  SYBatchApiRequest.m
//  Pods
//
//  Created by shirly on 2019/1/5.
//

#import "SYBatchApiRequest.h"

@interface SYBatchApiRequest ()

@property (nonatomic, strong, readwrite) NSMutableArray *apiRequestsList;

@end

@implementation SYBatchApiRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiRequestsList = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

#pragma mark - Add Requests
- (void)addAPIRequest:(SYBaseApiRequest *)api {
    
    NSParameterAssert(api);
    NSAssert([api isKindOfClass:[SYBaseApiRequest class]],
             @"必须是SYBaseApiRequest的子类才可以");
    if ([self.apiRequestsList containsObject:api]) {
        NSLog(@"Add SAME API into BatchRequest set : %@", api.requestUniqueIdentification);
    } else {
        [self.apiRequestsList addObject:api];
    }
}

- (void)addBatchAPIRequests:(nonnull NSArray<SYBaseApiRequest *> *)apis {
    NSParameterAssert(apis);
    NSAssert([apis count] > 0, @"Apis amounts should greater than ZERO");
    [apis enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addAPIRequest:obj];
    }];
}

//- (void)start {
//    NSAssert([self.apiRequestsList count] != 0, @"Batch API Amount can't be 0");
//    [[SYApiManager sharedInstance] loadBatchAPI:self];
//}

@end
