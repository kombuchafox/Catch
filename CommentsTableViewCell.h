//
//  CommentsTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/1/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinedTextView.h"
#import "BallTableView.h"
@interface CommentsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet BallTableView *commentsTableView;

@end
