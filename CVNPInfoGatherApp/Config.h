//
//  Config.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/15/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password;

+ (void)saveOwnID:(NSString *)userID userName:(NSString *)userName score:(int)score favoriteCount:(int)favoriteCount fansCount:(int)fanCount andFollowerCount:(int)followerCount;

+ (NSArray *)getOwnAccountAndPassword;
+ (NSString *)getOwnID;
+ (NSString *)getOwnUserName;
+ (NSArray *)getActivitySignUpInfomation;
+ (NSArray *)getUsersInformation;
+ (void)removeOwnId;
@end
