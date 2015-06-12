//
//  CVNPNetworkingManager.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/11/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CVNPNetworkingManager : NSObject

+ (CVNPNetworkingManager *)sharedCVNPNetworkingManager;
- (NSDictionary *)ManageruserLoginwithUsername:(NSString *)username andPassword:(NSString *)password;
- (NSDictionary *)userLoginwithUsername:(NSString *)username andPassword:(NSString *)password;
- (NSArray *)userAllPoints:(NSString *)userid;
@end
