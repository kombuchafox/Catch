//
//  PickFriendsTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/9/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "PickFriendsTableViewCell.h"
#import "PickFriendTableViewCell.h"
@implementation PickFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setUp
{
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
#pragma mark UITableViewDelegateMethods
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView new];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    cell = [self.friendsTableView dequeueReusableCellWithIdentifier:@"pickFriendTableViewCell"];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *) tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
