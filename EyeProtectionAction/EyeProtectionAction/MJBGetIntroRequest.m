
//
//  MJBGetIntroRequest.m
//  MJBWeightTool
//
//  Created by 陈腾飞 on 2019/6/6.
//

#import "MJBGetIntroRequest.h"

@implementation MJBGetIntroRequest

- (NSString *)methodNameForApi:(SYBaseApiRequest *_Nonnull)request {
    return @"plus/post.php";
}

- (NSString *)serviceUrlForApi:(SYBaseApiRequest *_Nonnull)request {
    return @"https://app1.fupeizi.com";
}

- (SYAPIRequestType)requestTypeForApi:(SYBaseApiRequest *_Nonnull)request {
    return SYAPIRequestRequestTypeGet;
}

@end
