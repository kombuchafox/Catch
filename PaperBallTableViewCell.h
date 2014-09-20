//
//  PaperBallTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/19/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaperBallTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ballGraphic;
-(void) setUp;
@property UIDynamicAnimator *animator;
@property CGFloat boundary;
@property UISwipeGestureRecognizer *send;
@property UITapGestureRecognizer *ballTap;
@end
