//
//  CVNPAPIClient.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/16/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CVNPAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
