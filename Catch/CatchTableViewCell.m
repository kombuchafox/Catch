//
//  CatchTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/11/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "CatchTableViewCell.h"
#import "Utils.h"
#define separatorX 0
@interface CatchTableViewCell()
{
    CAShapeLayer *specialLayer;
}
@end
@implementation CatchTableViewCell
-(void) setUp
{
    if (self.isOpened) {
        UIView *notifications = [[UIView alloc] initWithFrame:self.ballImageView.frame];
    
        notifications.backgroundColor = [UIColor clearColor];
        specialLayer = [CAShapeLayer layer];
        [specialLayer setPosition:CGPointMake(CGRectGetMidX([notifications bounds]), CGRectGetMidY([notifications bounds]))];
        [specialLayer setBounds:CGRectMake(0, 0, self.ballImageView.frame.size.width, self.ballImageView.frame.size.height)];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:specialLayer.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
        [specialLayer setPath:[path CGPath]];
        [specialLayer setFillColor:[Utils UIColorFromRGB:0xE82C0C * arc4random()].CGColor];
        [notifications.layer addSublayer:specialLayer];
        //notifications.layer.cornerRadius = 8;
        self.ballImageView.clipsToBounds = YES;
        [self.ballImageView addSubview:notifications];
        [self.contentView addSubview:notifications];
        [self.ballImageView removeFromSuperview];
        [self.ballImageView setFrame:CGRectMake(0, 0, self.ballImageView.frame.size.width, self.ballImageView.frame.size.height)];
        [notifications addSubview:self.ballImageView];
        UILabel *numberOfNotfications = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, self.ballImageView.frame.size.width, self.ballImageView.frame.size.height)];
        numberOfNotfications.text = @"4";
        numberOfNotfications.textColor = [UIColor whiteColor];
        numberOfNotfications.font = [UIFont boldSystemFontOfSize:30];
        numberOfNotfications.textAlignment = NSTextAlignmentCenter;
        [notifications addSubview:numberOfNotfications];
        
    }
    [self drawSeparator];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentBall:)];
    [tap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:tap];
    
}
-(void) drawSeparator
{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(separatorX, self.contentView.frame.size.height - 1.5, self.contentView.frame.size.width, 0.9)];
    separator.backgroundColor = [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f];
   [self.contentView addSubview:separator];
}
-(void) presentBall: (UITapGestureRecognizer *) sender
{
    NSLog(@"hesdjkfhgsdkjlfghre");
    [self.delegate catchBall: self];
}
@end
