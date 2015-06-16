//
//  CVNPAPIClient.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/16/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPAPIClient.h"

static NSString * const CVNPAPIBaseURLString = @"http://parkapps.kent.edu/demo/";

@implementation CVNPAPIClient

+ (instancetype)sharedClient {
    static CVNPAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedClient = [[CVNPAPIClient alloc] initWithBaseURL:[NSURL URLWithString:CVNPAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}

@end
