//
//  PaperBallTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/19/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "PaperBallTableViewCell.h"
#import "Utils.h"
#define kDefaultNumberOfSpinnerMarkers 12
#define kDefaultSpread 35.0
#define kDefaultColor ([Utils UIColorFromRGB:0xFFFFFF])
#define kDefaultThickness 8.0
#define kDefaultLength 25.0
#define kDefaultSpeed 1.0
#define kAddPictureXOffset 75
#define kAddPictureYOffset 45
#define kAddPictureYOffset4 -30
#define kMarkerAnimationKey @"MarkerAnimationKey"
// HUD defaults
#define kDefaultHUDSide 160.0
#define kDefaultHUDColor ([UIColor colorWithWhite:0.0 alpha:0.3])
@interface PaperBallTableViewCell()
{
    UIDynamicAnimator *animator;
    CGFloat boundary;
    UISwipeGestureRecognizer *send;
    UITapGestureRecognizer *ballTap;
}
@end
@implementation PaperBallTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void) setUp
{
    boundary = self.ballGraphic.frame.size.height + self.ballGraphic.frame.origin.y * 2;
    self.ballGraphic.userInteractionEnabled = YES;
    send = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sendBall:)];
    send.direction = UISwipeGestureRecognizerDirectionUp;
    [self.ballGraphic addGestureRecognizer:send];
    ballTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounceBall:)];
    [self.ballGraphic addGestureRecognizer:ballTap];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:[self superview]];
    
}

-(void) bounceBall: (UITapGestureRecognizer *) sender
{
    //[self.ballGraphic removeFromSuperview];
    [self.contentView addSubview:self.ballGraphic];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.ballGraphic.frame = CGRectMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y - 60, self.ballGraphic.frame.size.width, self.ballGraphic.frame.size.height);
    } completion:^(BOOL completed){
        [self setUpBallAnimation:0];
        
    }];
}
-(void) setUpBallAnimation: (int) tap
{
    [animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ballGraphic]];
    [animator addBehavior:gravityBehavior];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ballGraphic]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"floor"
                                       fromPoint:CGPointMake([UIScreen mainScreen].bounds.origin.x, boundary)
                                         toPoint:CGPointMake([UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width,boundary)];
    [animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballGraphic]];
    ballBehavior.elasticity = 0.4;
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.0;
    [animator addBehavior:ballBehavior];
}
-(void) sendBall:(UISwipeGestureRecognizer *) sender
{
    
    
    [self.ballGraphic removeFromSuperview];
    [[self superview] addSubview: self.ballGraphic];
    //[self.delegate.view addSubview:self.ballGraphic];
    // [self setUpBallAnimation:0];
    
    //[self.delegate setAllViewToZeroAlpha];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        //[self.delegate setAllViewToZeroAlpha];
    } completion:^(BOOL completed){
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            //[self.delegate setAllViewToZeroAlpha]
            self.ballGraphic.frame = CGRectMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y - [UIScreen mainScreen].bounds.size.height * 2, self.ballGraphic.frame.size.width, self.ballGraphic.frame.size.height);
            self.backgroundView = nil;
        } completion:
         ^(BOOL completed) {
             
             CGPoint actual = CGPointMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y);
             if (actual.y > 0) {
                 [UIView animateWithDuration:0.5 animations:^{
                     self.ballGraphic.frame = CGRectMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y - [UIScreen mainScreen].bounds.size.height * 2, self.ballGraphic.frame.size.width, self.ballGraphic.frame.size.height);
                 }];
             }
             //self.delegate.view.userInteractionEnabled = NO;
             CALayer * marker = [CALayer layer];
             [marker setBounds:CGRectMake(0, 0, kDefaultThickness, kDefaultLength)];
             [marker setCornerRadius:kDefaultThickness*0.5];
             [marker setBackgroundColor:[kDefaultColor CGColor]];
             [marker setPosition:CGPointMake(kDefaultHUDSide*0.5, kDefaultHUDSide*0.5+kDefaultSpread)];
             CAReplicatorLayer * spinnerReplicator = [CAReplicatorLayer layer];
             [spinnerReplicator setBounds:CGRectMake(0, 0, kDefaultHUDSide, kDefaultHUDSide)];
             [spinnerReplicator setCornerRadius:10.0];
             [spinnerReplicator setBackgroundColor:[kDefaultHUDColor CGColor]];
             [spinnerReplicator setPosition:CGPointMake(CGRectGetMidX([[self superview] frame]),
                                                        CGRectGetMidY([[self superview] frame]))];
             CGFloat angle = (2*M_PI)/(kDefaultNumberOfSpinnerMarkers);
             CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
             [spinnerReplicator setInstanceCount:kDefaultNumberOfSpinnerMarkers];
             [spinnerReplicator setInstanceTransform:instanceRotation];
             [spinnerReplicator addSublayer:marker];
             [[[self superview] layer] addSublayer:spinnerReplicator];
             
             [marker setOpacity:0.0];
             CABasicAnimation * fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
             [fade setFromValue:[NSNumber numberWithFloat:1.0]];
             [fade setToValue:[NSNumber numberWithFloat:0.0]];
             [fade setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
             [fade setRepeatCount:HUGE_VALF];
             [fade setDuration:kDefaultSpeed];
             CGFloat markerAnimationDuration = kDefaultSpeed/kDefaultNumberOfSpinnerMarkers;
             [spinnerReplicator setInstanceDelay:markerAnimationDuration];
             [marker addAnimation:fade forKey:kMarkerAnimationKey];
         }];
    }];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
