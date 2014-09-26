//
//  BallViewController.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/27/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallView.h"
#import "CatchPhraseTableViewCell.h"
#import "BallGraphicTableViewCell.h"
#import "BallTableView.h"
#import "LinedTextView.h"

@interface CatchViewController : UIViewController <UITextViewDelegate, BallViewDelegate, CatchPhaseTableViewCellDelegate, ToolbarSingletonDelegate>
- (IBAction)viewPeopleButton:(id)sender;

@property (strong, nonatomic) IBOutlet BallTableView *ballTableView;
@property (strong, nonatomic) IBOutlet BallView *seperatorView;
@property (strong, nonatomic) IBOutlet LinedTextView *postStatusTextView;
@property (strong, nonatomic) IBOutlet UIView *threadInitialPostView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property UIImageView *memeView;
@property UIImage *memeImage;
@property BOOL didPinchPaper;
@end
