//
//  Config.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/15/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "Config.h"

NSString * const kService = @"CVNP";
NSString * const kAccount = @"account";
NSString * const kUserID = @"userID";

NSString * const kUserName = @"name";
NSString * const kPortrait = @"portrait";
NSString * const kUserScore = @"score";
NSString * const kFavoriteCount = @"favoritecount";
NSString * const kFanCount = @"fans";
NSString * const kFollowerCount = @"followers";

NSString * const kJointime = @"jointime";
NSString * const kDevelopPlatform = @"devplatform";
NSString * const kExpertise = @"expertise";
NSString * const kHometown = @"from";

NSString * const kTrueName = @"trueName";
NSString * const kSex = @"sex";
NSString * const kPhoneNumber = @"phoneNumber";
NSString * const kCorporation = @"corporation";
NSString * const kPosition = @"position";

@implementation Config

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setObject:account forKey:kAccount];
    [userDefaluts synchronize];
    
}

+ (void)saveOwnID:(NSString *)userID
         userName:(NSString *)userName
            score:(int)score
    favoriteCount:(int)favoriteCount
        fansCount:(int)fanCount
 andFollowerCount:(int)followerCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userID forKey:kUserID];
    [userDefaults setObject:userName forKey:kUserName];
    [userDefaults setObject:@(score) forKey:kUserScore];
    [userDefaults setObject:@(favoriteCount) forKey:kFavoriteCount];
    [userDefaults setObject:@(fanCount)      forKey:kFanCount];
    [userDefaults setObject:@(followerCount) forKey:kFollowerCount];
    [userDefaults synchronize];
}

+ (NSArray *)getOwnAccountAndPassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    
    if (account) {return @[account];}
    return nil;
}

+ (NSString *)getOwnID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:kUserID];
    
    if (userID) {return userID;}
    return @"";
}

+ (NSString *)getOwnUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:kUserName];
    if (userName) {return userName;}
    return @"";
}

+ (NSArray *)getActivitySignUpInfomation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [userDefaults objectForKey:kTrueName] ?: @"";
    NSNumber *sex = [userDefaults objectForKey:kSex] ?: @(0);
    NSString *phoneNumber = [userDefaults objectForKey:kPhoneNumber] ?: @"";
    NSString *corporation = [userDefaults objectForKey:kCorporation] ?: @"";
    NSString *position = [userDefaults objectForKey:kPosition] ?: @"";
    
    return @[name, sex, phoneNumber, corporation, position];
}

+ (NSArray *)getUsersInformation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [userDefaults objectForKey:kUserName];
    NSNumber *score = [userDefaults objectForKey:kUserScore];
    NSNumber *favoriteCount = [userDefaults objectForKey:kFavoriteCount];
    NSNumber *fans = [userDefaults objectForKey:kFanCount];
    NSNumber *follower = [userDefaults objectForKey:kFollowerCount];
    NSNumber *userID = [userDefaults objectForKey:kUserID];
    if (userName) {
        return @[userName, score, favoriteCount, follower, fans, userID];
    }
    return @[@"点击头像登录", @(0), @(0), @(0), @(0), @(0)];
}

@end
