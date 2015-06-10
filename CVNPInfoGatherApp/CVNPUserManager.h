//
//  CVNPUserManager.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVNPUserModel.h"

@interface CVNPUserManager : NSObject

@property (strong, nonatomic) CVNPUserModel *User;

+(CVNPUserManager *)sharedCVNPUserManager;

@end
