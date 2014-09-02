//
//  NewBallViewController.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/10/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorBarPicker.h"
#import "BallView.h"
#import "CollapsebleTableView.h"
#import "BallGraphicTableViewCell.h"
#import "CatchPhraseTableViewCell.h"
typedef NS_ENUM(NSUInteger, Mood) {
    HAPPY = 0,
    PARTY,
    ROMANCE,
    RANDOM,
};

@interface NewBallViewController : UIViewController <UITextViewDelegate, BallViewDelegate, CatchPhaseTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet BallView *ballView;
@property (strong, nonatomic) IBOutlet ColorBarPicker *colorBarPicker;
@property (strong, nonatomic) IBOutlet InfColorBarPicker *infColorBarPicker;
@property (strong, nonatomic) IBOutlet UIImageView *ballImageView;
@property (strong, nonatomic) IBOutlet UITextView *messageView;
@property (nonatomic) Mood currentMood;
@property NSString *defaultText;
@property UIDynamicAnimator *animator;
@end
