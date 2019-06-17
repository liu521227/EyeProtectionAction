//
//  SYApiManager+Config.m
//  SYNetworking
//
//  Created by shirly on 2019/3/11.
//  Copyright © 2019年 ChenTF. All rights reserved.
//

#import "SYApiManager+Config.h"


@implementation SYApiManager (Config)

- (NSString *)serviceUrlForApi:(SYBaseApiRequest *_Nonnull)request BaseUrl:(NSString *)baseUrl {
    id config = [self configForBaseUrl:baseUrl];
    if ([request.child respondsToSelector:@selector(serviceUrlForApi:)]) {
        return [request.child serviceUrlForApi:request];
    } else if (request.isIgnoreConfig == NO && [config respondsToSelector:@selector(serviceUrlForApi:)]) {
        return [config serviceUrlForApi:request];
    }
    return nil;
}

- (SYAPIRequestType)requestTypeForApi:(SYBaseApiRequest *_Nonnull)request {
    id config = [self configForAPI:request];
    if ([request.child respondsToSelector:@selector(requestTypeForApi:)]) {
        return [request.child requestTypeForApi:request];
    } else if ([config respondsToSelector:@selector(requestTypeForApi:)]) {
        return [config requestTypeForApi:request];
    }
    return SYAPIRequestRequestTypeGet;
}

- (NSDictionary *_Nullable)headForApi:(SYBaseApiRequest *_Nonnull)request {
    NSMutableDictionary *headDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([request.child respondsToSelector:@selector(headForApi:)]) {
        [headDict addEntriesFromDictionary:[request.child headForApi:request]];
    }
    
    id config = [self configForAPI:request];
    if ([config respondsToSelector:@selector(headForApi:)]) {
        [headDict addEntriesFromDictionary:[config headForApi:request]];
    }
    
    return headDict;
}

- (id)paramsForApi:(SYBaseApiRequest *_Nonnull)request {
    id config = [self configForAPI:request];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([request.child respondsToSelector:@selector(paramsForApi:)]) {
        [params addEntriesFromDictionary:[request.child paramsForApi:request]];
    }
    if ([config respondsToSelector:@selector(paramsForApi:)]) {
        [params addEntriesFromDictionary:[config paramsForApi:request]];
    }
    
    if ([request.encryptDelegate respondsToSelector:@selector(EncryptParamsWithRequest:originParam:)]) {
        params = [request.encryptDelegate EncryptParamsWithRequest:request originParam:params];
    } else if ([config respondsToSelector:@selector(EncryptParamsWithRequest:originParam:)]) {
        params = [config EncryptParamsWithRequest:request originParam:params];
    }
    
    return params;
}

- (SYApiSerializerType)requestSerializerForApi:(SYBaseApiRequest *_Nonnull)request {
    id config = [self configForAPI:request];
    if ([request.child respondsToSelector:@selector(requestSerializerForApi:)]) {
        return [request.child requestSerializerForApi:request];
    } else if ([config respondsToSelector:@selector(requestSerializerForApi:)]) {
        return [config requestSerializerForApi:request];
    }
    return SYApiSerializerTypeHTTP;
}

- (SYApiSerializerType)responseSerializerForApi:(SYBaseApiRequest *_Nonnull)request {
    id config = [self configForAPI:request];
    if ([request.child respondsToSelector:@selector(responseSerializerForApi:)]) {
        return [request.child responseSerializerForApi:request];
    } else if ([config respondsToSelector:@selector(responseSerializerForApi:)]) {
        return [config responseSerializerForApi:request];
    }
    return SYApiSerializerTypeJSON;
}

- (NSTimeInterval)apiRequestTimeoutIntervalForApi:(SYBaseApiRequest *_Nonnull)request {
    id config = [self configForAPI:request];
    if ([request.child respondsToSelector:@selector(apiRequestTimeoutIntervalForApi:)]) {
        return [request.child apiRequestTimeoutIntervalForApi:request];
    } else if ([config respondsToSelector:@selector(apiRequestTimeoutIntervalForApi:)]) {
        return [config apiRequestTimeoutIntervalForApi:request];
    }
    return 30.0;
}

@end
