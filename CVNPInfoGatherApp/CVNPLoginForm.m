//
//  CVNPLoginForm.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPLoginForm.h"

@implementation CVNPLoginForm

- (NSDictionary *)usernameField
{
    return @{@"textLabel.color": [UIColor redColor]};
}

- (NSArray *)extraFields
{
    return @[
             
             //this field doesn't correspond to any property of the form
             //it's just an action button. the action will be called on first
             //object in the responder chain that implements the submitForm
             //method, which in this case would be the AppDelegate
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitLoginForm:"},
             
             ];
}

@end
