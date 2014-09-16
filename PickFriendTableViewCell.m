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
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFriend:)];
//    [self addGestureRecognizer:tap];

}
- (void)awakeFromNib
{
     [self setUp];
    // Initialization code
}
-(void) tapFriend: (bool) picked
{
    if (picked) {
        [self.pickFriendButton.circleLayer setFillColor:self.pickFriendButton.color.CGColor];
    } else {
        [self.pickFriendButton.circleLayer setFillColor:[UIColor whiteColor].CGColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    

}

@end
