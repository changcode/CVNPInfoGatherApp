//
//  CVNPLoginForm.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"


@interface CVNPLoginForm : NSObject <FXForm>

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL rememberMe;

@end
