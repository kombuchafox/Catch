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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage *)squareAndSmall: (UIImageView *) image
// as a category (so, 'self' is the input image)
{
    // fromCleverError's original
    // http://stackoverflow.com/questions/17884555
    CGSize finalsize = CGSizeMake(45,45);
    
    CGFloat scale = MAX(
                        finalsize.width/image.frame.size.width,
                        finalsize.height/image.frame.size.height);
    CGFloat width = image.frame.size.width * scale;
    CGFloat height = image.frame.size.height * scale;
    
    CGRect rr = CGRectMake( 0, 0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(finalsize, NO, 0);
    [image.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image withRatio:(float)ratio {
    // first crop to a rectangle and then scale the cropped image to ratio
    CGRect cropRect;
    if (image.size.width == image.size.height) {
        // height and width are same - do not crop here
        cropRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    } else if (image.size.width > image.size.height) {
        // width is longer - take height and adjust xgap to crop
        int xgap = (image.size.width - image.size.height)/2;
        cropRect = CGRectMake(xgap, 0.0, image.size.height, image.size.height);
    } else {
        // height is longer - take height and adjust ygap to crop
        int ygap = (image.size.height - image.size.width)/2;
        cropRect = CGRectMake(0.0, ygap, image.size.width, image.size.width);
    }
    // crop image with calcuted crop rect
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    // scale the image to ratio to create proper thumb
    NSData *pngData = UIImagePNGRepresentation(cropped);
    UIImage *myThumbNail    = [[UIImage alloc] initWithData:pngData];
    
    // begin an image context that will essentially keep our new image
    UIGraphicsBeginImageContext(CGSizeMake(ratio,ratio));
    
    // now redraw our image in a smaller rectangle.
    [myThumbNail drawInRect:CGRectMake(0.0, 0.0, ratio, ratio)];
    
    // make a copy of the image from the current context
    UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
