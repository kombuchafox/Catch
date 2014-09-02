//
//  BallGraphicTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/22/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "BallGraphicTableViewCell.h"
#import "Utils.h"
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>

// Default values
#define kDefaultNumberOfSpinnerMarkers 12
#define kDefaultSpread 35.0
#define kDefaultColor ([Utils UIColorFromRGB:0xE8240C])
#define kDefaultThickness 8.0
#define kDefaultLength 25.0
#define kDefaultSpeed 1.0

// HUD defaults
#define kDefaultHUDSide 160.0
#define kDefaultHUDColor ([UIColor colorWithWhite:0.0 alpha:0.3])

#define kMarkerAnimationKey @"MarkerAnimationKey"

@interface BallGraphicTableViewCell() <UICollisionBehaviorDelegate> {
    UIImageView *ballImage;
    BallView *ballCopy;
    CAEmitterLayer *lineEmitter;
    UIDynamicAnimator *animator;
    BallView *combinedImage;
    UISwipeGestureRecognizer *send;
    UITapGestureRecognizer *tap;
    UIPushBehavior *push;
}
@end
@implementation BallGraphicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    [self setUp];
    return self;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    [self setUp];
}
-(void) setUp
{
    NSLog(@"setup");

    ballImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transparent"]];
    ballImage.alpha = 0.6f;
    ballImage.frame = CGRectMake(76, 41, 160, 157);
    ballCopy = [[BallView alloc] initWithFrame:
                CGRectMake(0,
                           0,
                           self.ballView.frame.size.width,
                           self.ballView.frame.size.height)];
    [ballCopy drawCircle:[UIColor redColor]];
    ballImage.userInteractionEnabled = YES;
    send = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sendBall:)];
    send.direction = UISwipeGestureRecognizerDirectionUp;
    [ballImage addGestureRecognizer:send];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounceBall:)];
    [ballImage addGestureRecognizer:tap];

    [self.ballView drawCircle:[Utils UIColorFromRGB:0xE82C0C]];
    [self addSubview:ballImage];
    
    self.colorBarPicker.layer.cornerRadius = 5;
    self.colorBarPicker.layer.masksToBounds = YES;
    self.colorBarPicker.layer.borderColor = [UIColor grayColor].CGColor;
    self.colorBarPicker.layer.borderWidth = 1.0;
    
    //animator
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.delegate.view];
    
}
-(void) sendBall:(UISwipeGestureRecognizer *) sender
{


    self.colorBarPicker.hidden = YES;
    self.infColorBarPicker.hidden = YES;
    [self createBallImageGrapic];
    [self.delegate.view addSubview:combinedImage];
        //[self.delegate.view addSubview:combinedImage];
   // [self setUpBallAnimation:0];

    //[self.delegate setAllViewToZeroAlpha];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self.delegate setAllViewToZeroAlpha];
        } completion:^(BOOL completed){
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                //[self.delegate setAllViewToZeroAlpha];
                self.backgroundView = nil;
                
                combinedImage.center = CGPointMake(self.ballView.frame.origin.x, self.ballView.frame.origin.y - [UIScreen mainScreen].bounds.size.height * 2);} completion:
             ^(BOOL completed) {
                 self.delegate.view.userInteractionEnabled = NO;
                 CALayer * marker = [CALayer layer];
                 [marker setBounds:CGRectMake(0, 0, kDefaultThickness, kDefaultLength)];
                 [marker setCornerRadius:kDefaultThickness*0.5];
                 [marker setBackgroundColor:[kDefaultColor CGColor]];
                 [marker setPosition:CGPointMake(kDefaultHUDSide*0.5, kDefaultHUDSide*0.5+kDefaultSpread)];
                 CAReplicatorLayer * spinnerReplicator = [CAReplicatorLayer layer];
                 [spinnerReplicator setBounds:CGRectMake(0, 0, kDefaultHUDSide, kDefaultHUDSide)];
                 [spinnerReplicator setCornerRadius:10.0];
                 [spinnerReplicator setBackgroundColor:[kDefaultHUDColor CGColor]];
                 [spinnerReplicator setPosition:CGPointMake(CGRectGetMidX([self.delegate.view frame]),
                                                            CGRectGetMidY([self.delegate.view frame]))];
                 CGFloat angle = (2*M_PI)/(kDefaultNumberOfSpinnerMarkers);
                 CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
                 [spinnerReplicator setInstanceCount:kDefaultNumberOfSpinnerMarkers];
                 [spinnerReplicator setInstanceTransform:instanceRotation];
                 [spinnerReplicator addSublayer:marker];
                 [[self.delegate.view layer] addSublayer:spinnerReplicator];
                 
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
-(NSMutableArray*) loadSpinnerImageArray
{
    NSMutableArray *spinnerImages = [[NSMutableArray alloc]init];
    for (int i = 1; i < 20; i++)
    {
        [spinnerImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",i]]];
    }
    return spinnerImages;
}
-(void) bounceBall: (UITapGestureRecognizer *) sender
{
    [self createBallImageGrapic];
    [self.contentView addSubview:combinedImage];
    
    [UIView animateWithDuration:0.4 animations:^{
        combinedImage.frame = CGRectMake(combinedImage.frame.origin.x, combinedImage.frame.origin.y - 60, combinedImage.frame.size.width, combinedImage.frame.size.height);
    } completion:^(BOOL completed){
        [self setUpBallAnimation:0];
        [ballImage addGestureRecognizer:send];
        
    }];
}

-(void) createBallImageGrapic
{
    UIGraphicsBeginImageContext([self.ballView.circleLayer frame].size);
    [self.ballView.circleLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(ballImage.frame.size);
    
    [circle drawAtPoint:CGPointMake(1, 2)];
    [ballImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *ballImageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    combinedImage = [[BallView alloc] initWithImage:ballImageCopy];
    combinedImage.userInteractionEnabled = YES;
    [combinedImage addGestureRecognizer:send];
    combinedImage.frame = CGRectMake(ballImage.frame.origin.x, ballImage.frame.origin.y, ballImage.frame.size.width, ballImage.frame.size.height);
    [ballImage removeFromSuperview];
    [self.ballView removeFromSuperview];
    [combinedImage setupEmitter];
}
-(void) setUpBallAnimation: (int) tap
{
    [animator removeAllBehaviors];

    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[combinedImage]];
    [animator addBehavior:gravityBehavior];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[combinedImage]];

    [collisionBehavior addBoundaryWithIdentifier:@"floor"
                                       fromPoint:CGPointMake([UIScreen mainScreen].bounds.origin.x, ballImage.frame.origin.y + ballImage.frame.size.height)
                                         toPoint:CGPointMake([UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width,ballImage.frame.origin.y + ballImage.frame.size.height)];
    [animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[combinedImage]];
    ballBehavior.elasticity = 0.4;
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.0;
    [animator addBehavior:ballBehavior];
}
- (void)awakeFromNib
{
    // Initialization code
}
- (IBAction)ballColorChanged:(InfColorBarPicker *)sender {
        float hue = sender.value;
        [self.ballView  updateColor:[UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1]];
    [self.delegate updateBallColor:hue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) resizeBallToScreen: (CGFloat) height
{
    self.ballImageView.frame = CGRectMake(self.ballImageView.frame.origin.x, self.ballImageView.frame.origin.y, height * (10/260), height * (10/260));
    self.ballView.frame = CGRectMake(self.ballView.frame.origin.x, self.ballView.frame.origin.y, height * (10/260), height * (10/260));
    self.backgroundColor = [Utils UIColorFromRGB:0xFFFEFF];
 

}

#pragma mark UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p{
    if ([identifier isEqualToString:@"floor"])
    {
        [combinedImage removeFromSuperview];
        [self.contentView addSubview:self.ballView];
        [self.contentView addSubview:ballImage];
    }
    
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id)item withBoundaryIdentifier:(id)identifier{
    
    if ([identifier isEqualToString:@"floor"])
    {
        [self.contentView addSubview:combinedImage];
        [self.ballView removeFromSuperview];
        [ballImage removeFromSuperview];
    }

}
@end
