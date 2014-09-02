//
//  CommentTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/1/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinedTextView.h"
@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet LinedTextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *attachedImage;
-(void) setUp;
@end
