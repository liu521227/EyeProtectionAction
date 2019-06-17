//
//  SYBaseApiRequest+LoadData.m
//  SYNetworking
//
//  Created by shirly on 2019/4/20.
//  Copyright © 2019 ChenTF. All rights reserved.
//

#import "SYBaseApiRequest+LoadData.h"
#import "SYApiManager.h"
@class SYApiManager;

@implementation SYBaseApiRequest (LoadData)

- (void)loadData {
    [[SYApiManager sharedInstance] loadAPI:self];
}

@end
