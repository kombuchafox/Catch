//
//  Utils.m
//  Catch
//
//  Created by Ian Fox on 8/8/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@interface Utils()

@end

@implementation Utils

+(UIColor *) UIColorFromRGB:(int)rgbValue
{
    return [UIColor colorWithRed:(float)(((rgbValue & 0xFF0000) >> 16)/255.0) green:(float)(((rgbValue & 0x00FF00) >> 8)/255.0) blue:(float)((rgbValue & 0xFF)/255.0) alpha:1.0];
}





@end
