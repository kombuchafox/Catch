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

@interface NewBallViewController : UIViewController <UITextViewDelegate, BallViewDelegate, CatchPhaseTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backButton;
-(void) collapsePaper;
@property BOOL didPinchPaper;
@property NSString *defaultText;
@property UIDynamicAnimator *animator;
@end
