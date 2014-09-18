//
//  PickFriendsTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/9/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "PickFriendsTableViewCell.h"
#import "PickFriendTableViewCell.h"
@interface PickFriendsTableViewCell()
{
    NSMutableDictionary *rowToFriend;
}
@end
@implementation PickFriendsTableViewCell
@synthesize pickedIndexes;
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
    [self setUp];
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
    self.friendsTableView.allowsMultipleSelection = YES;
    pickedIndexes = [[NSMutableArray alloc] init];
    //let the row be the index and the object at specified index be the tablecell
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
    if (!rowToFriend) {
        rowToFriend = [[NSMutableDictionary alloc] init];
    }
    PickFriendTableViewCell *cell;
    cell = [self.friendsTableView dequeueReusableCellWithIdentifier: @"pickFriendTableViewCell" forIndexPath: indexPath];
    cell.accessoryView = cell.pickFriendButton;
    NSNumber *row = [NSNumber numberWithInteger:indexPath.row];
    if (![rowToFriend objectForKey:row])
    {
        NSMutableDictionary *friendData = [[NSMutableDictionary alloc] init];
        [friendData setObject:[NSString stringWithFormat:@"First Last (row %i)", indexPath.row] forKey:@"name"];
        [friendData setObject:[NSString stringWithFormat:@"First(%i)", indexPath.row]forKey:@"first_name"];
        [rowToFriend setObject: friendData forKey:indexPath];

    }
    pickedIndexes;
    if ([pickedIndexes containsObject:indexPath]) {
        [cell.pickFriendButton.circleLayer setFillColor:cell.pickFriendButton.color.CGColor];
    } else {
        [cell.pickFriendButton.circleLayer setFillColor:[UIColor whiteColor].CGColor];
    }
    
    cell.friendName.text = [[rowToFriend objectForKey:indexPath] objectForKey:@"name"];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
    
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PickFriendTableViewCell *cell = (PickFriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.pickFriendButton.circleLayer.fillColor == cell.pickFriendButton.color.CGColor) {
        [cell.pickFriendButton.circleLayer setFillColor:[UIColor whiteColor].CGColor];
        [pickedIndexes removeObject:indexPath];
        [self updateHeaderViewLabel];
    } else {
        [cell.pickFriendButton.circleLayer setFillColor:cell.pickFriendButton.color.CGColor];
        [pickedIndexes addObject:indexPath];
        [self updateHeaderViewLabel];
        
    }
}

-(void) updateHeaderViewLabel
{
    NSString *newTitle = @" ";
    for (int i = 0; i < [pickedIndexes count]; i++)
    {
        NSIndexPath *path = [pickedIndexes objectAtIndex:i];
        NSMutableDictionary *friendData = [rowToFriend objectForKey:path];
       if (i == 0)
       {
           newTitle = [friendData objectForKey:@"first_name"];
       } else
       {
           newTitle = [newTitle stringByAppendingString:[NSString stringWithFormat:@", %@", [friendData objectForKey:@"first_name"]]];
       }
    }
    [self.delegate updatePickFriendHeaderView:newTitle];
}
@end
