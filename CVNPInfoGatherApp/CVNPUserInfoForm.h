//
//  CVNPUserInfo.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface CVNPUserInfoForm : NSObject <FXForm>

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *User_ID;
@property (assign, nonatomic) BOOL alreayLogin;

@end
