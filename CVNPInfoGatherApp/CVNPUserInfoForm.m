//
//  CVNPUserInfo.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "Config.h"
#import "CVNPUserInfoForm.h"

@implementation CVNPUserInfoForm

- (NSDictionary *)usernameField
{
    return @{ FXFormFieldType: FXFormFieldTypeLabel, FXFormFieldValueTransformer: ^(__unused id value) {
        return [Config getOwnUserName];
    }};
}

- (NSDictionary *)User_IDField
{
    return @{ FXFormFieldType: FXFormFieldTypeLabel, FXFormFieldValueTransformer: ^(__unused id value) {
        return [Config getOwnID];
    }};
}

- (NSDictionary *)alreayLoginField
{
    return @{FXFormFieldType : FXFormFieldTypeLabel, FXFormFieldValueTransformer: ^(__unused id value) {
        return [Config isLogined] ? @"YES" : @"NO";
    }};
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: [Config isLogined] ? @"Logout" : @"Login", FXFormFieldHeader: @"", FXFormFieldAction: @"logoutAction"},
             ];
}

@end

