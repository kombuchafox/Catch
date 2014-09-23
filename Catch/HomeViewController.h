//
//  HomeViewController.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/10/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionHomeManager.h"
#import "CatchTableViewCell.h"
@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CatchTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *newsFeedTable;

@property TransitionHomeManager *logoutTransitionDelegate;
@end
