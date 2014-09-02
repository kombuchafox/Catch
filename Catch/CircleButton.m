//
//  CircleButton.m
//  Catch
//
//  Created by Ian Fox on 8/8/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleButton.h"

@interface CircleButton()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation CircleButton

- (void) drawCircle:(UIColor *)color
{
    self.color = color;

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setBounds:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]))];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [self.circleLayer setPath:[path CGPath]];
    
    [self.circleLayer setStrokeColor:[color CGColor]];
    
    [self.circleLayer setLineWidth:0.5f];
    [self.circleLayer setFillColor:self.color.CGColor];
    
    [self.layer insertSublayer:self.circleLayer atIndex:0];
}
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.circleLayer setFillColor:[UIColor whiteColor].CGColor];
    }
    else
    {
        [self.circleLayer setFillColor:self.color.CGColor];

    }
}

@end