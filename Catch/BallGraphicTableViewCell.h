//
//  BallGraphicTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/22/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallView.h"
#import "ColorBarPicker.h"
@protocol BallViewDelegate
@property UIView *view;
@required
-(void)updateBallColor:(CGFloat) value;
@required
-(void)setAllViewToZeroAlpha;
@end
@interface BallGraphicTableViewCell : UITableViewCell
@property UIImageView *ballImageView;
@property (strong, nonatomic) IBOutlet BallView *ballView;
@property (strong, nonatomic) IBOutlet InfColorBarPicker *infColorBarPicker;
@property (strong, nonatomic) IBOutlet ColorBarPicker *colorBarPicker;
@property id<BallViewDelegate> delegate;
-(void) setUp;
- (void) resizeBallToScreen: (CGFloat) height;
@end
