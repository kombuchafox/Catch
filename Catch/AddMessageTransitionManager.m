//
//  AddMessageTransition.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/15/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "AddMessageTransitionManager.h"
#import "AddMessageViewController.h"
#import "AppNavigationController.h"
#import "NewCatchViewController.h"

@interface AddMessageTransitionManager()
@property BOOL toAddMessageVC;
@end
@implementation AddMessageTransitionManager

-(instancetype) init
{
    self = [super init];
    self.toAddMessageVC = YES;
    return self;
}

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
//    AddMessageViewController *addMessageVC;
//    AppNavigationController *navVC;
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView *containerView = [transitionContext containerView];
//
//    if (self.toAddMessageVC)
//    {
//        if ([toVC isKindOfClass:[AddMessageViewController class]])
//        {
//            
//            addMessageVC = (AddMessageViewController *)toVC;
//            navVC = (AppNavigationController *)fromVC;
//            if ([[navVC.viewControllers objectAtIndex:1] isKindOfClass:[NewBallViewController class]])
//            {
//                NewBallViewController *newballVC = [navVC.viewControllers objectAtIndex:1];
//                NSString  *h = newballVC.messageView.text;
//                NSString  *hh = newballVC.defaultText;
//                if (![newballVC.messageView.text isEqual:newballVC.defaultText]){
//                    addMessageVC.messageView.text = newballVC.messageView.text;
//                }
//            }
//            
//        }
//        [containerView addSubview:toVC.view];
//        CGFloat deviceScreen = CGRectGetWidth(toVC.view.frame);
//        CGRect startRect = CGRectMake(0, 0, CGRectGetWidth(toVC.view.frame), CGRectGetHeight(toVC.view.frame));
//        toVC.view.frame = startRect;
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//
//            toVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(toVC.view.frame), CGRectGetHeight(toVC.view.frame));
//            } completion:^(BOOL value) {
//
//                
//            toVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            
//        }];
//        
//    } else {
//
//        if ([toVC isKindOfClass:[AppNavigationController class]])
//        {
//            navVC = (AppNavigationController *)toVC;
//            if ([[navVC.viewControllers objectAtIndex:1] isKindOfClass:[NewBallViewController class]])
//            {
//                NewBallViewController *newballVC = [navVC.viewControllers objectAtIndex:1];
//                AddMessageViewController *addMessageVC = (AddMessageViewController *) fromVC;
//                newballVC.messageView.hidden = NO;
//                if (addMessageVC.message.length != 0) {
//                    newballVC.messageView.text = addMessageVC.message;
//                } else {
//                    newballVC.messageView.text = newballVC.defaultText;
//                }
//            }
//            
//        }
//        [containerView addSubview:fromVC.view];
//        CGRect endRect= CGRectMake(0, CGRectGetHeight(fromVC.view.frame), CGRectGetWidth(fromVC.view.frame), CGRectGetHeight(fromVC.view.frame));
//        fromVC.view.frame = endRect;
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:nil completion:^(BOOL value){
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        }];
//    }
    
}
-(id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.toAddMessageVC = NO;
    return self;
}
-(id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.toAddMessageVC = YES;
    return self;
}
@end
