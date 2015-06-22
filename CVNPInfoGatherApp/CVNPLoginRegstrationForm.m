//
//  CVNPLoginRegstrationForm.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPLoginRegstrationForm.h"

@implementation CVNPLoginRegstrationForm

- (NSDictionary *)loginField
{
    return @{FXFormFieldInline: @YES};
}

- (NSDictionary *)registrationField
{
    return @{FXFormFieldHeader: @"Not Registered?",FXFormFieldKey: @"registration", FXFormFieldTitle: @"Registration (Developing)"};
}

@end
