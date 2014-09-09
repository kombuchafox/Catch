//
//  PickFriendsTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/9/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickFriendsTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *friendsTableView;

@end
