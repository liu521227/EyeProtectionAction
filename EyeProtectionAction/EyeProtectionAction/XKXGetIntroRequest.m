
//
//  XKXGetIntroRequest.m
//  XKXWeightTool
//
//  Created by shirly on 2019/6/6.
//

#import "XKXGetIntroRequest.h"

@implementation XKXGetIntroRequest

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
