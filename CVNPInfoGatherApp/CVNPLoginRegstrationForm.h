//
//  CVNPLoginRegstrationForm.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "CVNPLoginForm.h"
#import "CVNPRegistrationForm.h"

@interface CVNPLoginRegstrationForm : NSObject <FXForm>

@property (strong, nonatomic) CVNPLoginForm *login;
@property (strong, nonatomic) CVNPRegistrationForm *registration;

@end
