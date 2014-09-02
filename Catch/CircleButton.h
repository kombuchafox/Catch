//
//  CircleButton.h
//  Catch
//
//  Created by Ian Fox on 8/8/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CircleButton : UIButton
@property (nonatomic, strong) UIColor *color;
-(void) drawCircle:(UIColor *) color;
@end
