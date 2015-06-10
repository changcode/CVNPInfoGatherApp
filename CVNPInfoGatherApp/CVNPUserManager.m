//
//  CVNPUserManager.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPUserManager.h"

@implementation CVNPUserManager

static CVNPUserManager * CVNPUserDao = nil;

@synthesize User;

+ (CVNPUserManager *)sharedCVNPUserManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CVNPUserDao = [[self alloc] init];
    });
    return CVNPUserDao;
}

@end
