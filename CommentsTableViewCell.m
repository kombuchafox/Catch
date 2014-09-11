//
//  CommentTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/1/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentsTableView.stringIdentifier = @"commentsTableView";
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    // Configure the view for the selected state
}

@end
