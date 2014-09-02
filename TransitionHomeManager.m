//
//  TransitionHomeManager.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/10/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "TransitionHomeManager.h"
#import "AddMessageViewController.h"
#import "NewBallViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface TransitionHomeManager()
@property BOOL toHome;

@end

@implementation TransitionHomeManager
@synthesize toHome;

-(instancetype)init
{
    self = [super init];
    self.toHome = YES;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"hdsjkhslkdjghdfsgljkhdfsgkjfhds");
    NewBallViewController *newBallVC;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    if (self.toHome)
    {
        newBallVC = (NewBallViewController *)fromVC;
        [containerView addSubview:toVC.view];
        CGRect startRect = CGRectMake(0, CGRectGetHeight(toVC.view.frame), CGRectGetWidth(toVC.view.bounds), CGRectGetHeight(toVC.view.bounds));
        CGPoint transformedPoint = CGPointApplyAffineTransform(startRect.origin, toVC.view.transform);
        toVC.view.frame = CGRectMake(transformedPoint.x, transformedPoint.y, startRect.size.width, startRect.size.height);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{} completion:^(BOOL finished) {
            newBallVC.messageView.hidden = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
        }];
        
    } else {
        [containerView bringSubviewToFront:fromVC.view];
        CGRect endRect = CGRectMake(0,
                                    CGRectGetHeight(fromVC.view.bounds),
                                    CGRectGetWidth(fromVC.view.frame),
                                    CGRectGetHeight(fromVC.view.frame));
        CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromVC.view.transform);
        fromVC.view.frame = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:5
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                         }];
        
        
    }
    
}

-(id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{

    self.toHome = NO;
    return self;
}
-(id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NSLog(@"hdsjkhslkdjghdfsgljkhdfsgkjfhds");
    self.toHome = YES;
    return self;
}




@end
