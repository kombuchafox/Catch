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

@interface BallViewController : UIViewController <UITextViewDelegate, BallViewDelegate, CatchPhaseTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet BallTableView *ballTableView;

@end
