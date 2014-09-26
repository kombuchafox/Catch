//
//  PeopleInThreadViewController.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/25/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleInThreadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *peopleTableView;

@end
