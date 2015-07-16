//
//  CVNPPointPresentImageItem.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/13/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "RETableViewItem.h"

@interface CVNPPointPresentImageItem : RETableViewItem

@property (strong, readwrite, nonatomic) NSString *imagePath;

+ (CVNPPointPresentImageItem *)itemWithImagePath:(NSString *)imagePath;

@end
