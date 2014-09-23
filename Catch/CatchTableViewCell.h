//
//  CatchTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/11/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"
@protocol CatchTableViewCellDelegate;
@interface CatchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ballImageView;
@property BOOL isOpened;
@property id<CatchTableViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *ballTitle;
@property (strong, nonatomic) IBOutlet UIImageView *attachedImage;
-(void) setUp;
@end
@protocol CatchTableViewCellDelegate
-(void) catchBall: (CatchTableViewCell*) cell;
@end