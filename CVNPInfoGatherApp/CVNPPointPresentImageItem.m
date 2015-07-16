//
//  CVNPPointPresentImageItem.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/13/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointPresentImageItem.h"

@implementation CVNPPointPresentImageItem

+ (CVNPPointPresentImageItem *)itemWithImagePath:(NSString *)imagePath;
{
    CVNPPointPresentImageItem *item = [[CVNPPointPresentImageItem alloc] init];
    item.imagePath = imagePath;
    return item;
}

@end
