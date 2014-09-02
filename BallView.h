//
//  BallView.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/12/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallView : UIImageView
@property UIColor *color;
- (void) drawCircle:(UIColor *)color;
-(void) updateColor: (UIColor *) color;
-(void) setupEmitter;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end
