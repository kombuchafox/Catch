//
//  Utils.h
//  Catch
//
//  Created by Ian Fox on 8/8/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject 

+ (UIColor *) UIColorFromRGB:(int) rgbValue;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size;
+(UIImage *)squareAndSmall: (UIImage *) image;
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image withRatio:(float)ratio;
@end
