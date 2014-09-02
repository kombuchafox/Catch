//
//  TransitionHomeManager.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/10/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionDirection) {
    HOME = 0,
    LEFT,
    RIGHT
};
@interface TransitionHomeManager : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property TransitionDirection transitionTo;
//@property
@end
