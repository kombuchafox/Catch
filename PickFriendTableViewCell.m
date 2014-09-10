//
//  PickFriendTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/9/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "PickFriendTableViewCell.h"
#import "Utils.h"
@implementation PickFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}
-(void) setUp
{
    self.pickFriendButton.backgroundColor = [UIColor clearColor];
    [self.pickFriendButton drawCircle:[Utils UIColorFromRGB:0xAC8CFF]];
    [self.pickFriendButton addTarget:self action:@selector(tapFriend:) forControlEvents:UIControlEventTouchDown];
}
- (void)awakeFromNib
{
     [self setUp];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

}
-(void) tapFriend:(CircleButton *) sender
{
    [self.pickFriendButton setSelected:YES];
}
@end
