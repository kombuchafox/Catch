//
//  HomeViewController.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/10/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "HomeViewController.h"
#import "CircleButton.h"
#import "Utils.h"
#import "SettingsViewController.h"
#import "FriendsViewController.h"
#import "CatchTableViewCell.h"
#import "NewCatchViewController.h"
#import "CatchViewController.h"

@interface HomeViewController()
@property (strong, nonatomic) IBOutlet CircleButton *inTheAirButton;
@property (strong, nonatomic) IBOutlet CircleButton *addBallButton;

@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) NSArray* _testArray;
@property (strong, nonatomic) NSArray* _labelArray;
@property (strong, nonatomic) IBOutlet UITableView *catchesTableView;
@property (strong, nonatomic) IBOutlet UIView *statusBarView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation HomeViewController
@synthesize _testArray;
@synthesize _labelArray;
@synthesize inTheAirButton;
@synthesize addBallButton;

-(void)viewDidLoad
{

    //for testing
    _testArray = [NSArray arrayWithObjects:@"obj1",@"obj1",@"obj1",nil];
    _labelArray = [NSArray arrayWithObjects:@"#whatTheFuck",@"Cute as fuck jkfdshgjksdf jkkjdfsjk dfkjhg sdfg kdjsfhgkdjfs", @"#bestSex",nil];


    [self.view setBackgroundColor:[Utils UIColorFromRGB:0xFCFCEB]];
    [self.addBallButton drawCircle:[Utils UIColorFromRGB:0xF2877D ]];
    [self.inTheAirButton drawCircle:[Utils UIColorFromRGB:0xF7C811 ]];
    //[self.incomingBallsButton drawCircle:[Utils UIColorFromRGB:0x90D4D4 ]];
    int height = self.navigationController.navigationBar.frame.size.height;
    int width = self.navigationController.navigationBar.frame.size.width;
    UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    homeLabel.backgroundColor = [UIColor clearColor];
    homeLabel.textColor = [Utils UIColorFromRGB:0xFFFFFF];
    homeLabel.text = @"Catch";
    homeLabel.font = [UIFont fontWithName:@"noteworthy" size:30];
    homeLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0];
    homeLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = homeLabel;
    [self.navigationController.navigationBar setBarTintColor:[Utils UIColorFromRGB:0xc93532]];
    [self.toolBar setBackgroundColor:[Utils UIColorFromRGB:0xD73033]];
    [self.statusBarView setBackgroundColor:[Utils UIColorFromRGB:0xD73033]];
    [self.settingsButton setContentEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.friendsButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -15)];

}
-(void)viewDidAppear:(BOOL)animated
{
    CGFloat height;
    int availableScreen = [[UIScreen mainScreen] bounds].size.height - self.navigationController.navigationBar.frame.size.height - 10;
    height = availableScreen;
    [self.catchesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.catchesTableView setFrame:CGRectMake(self.catchesTableView.frame.origin.x,
                                               self.catchesTableView.frame.origin.y,
                                               self.catchesTableView.frame.size.width,
                                               height)];
    [self.navigationController.navigationBar setBarTintColor:[Utils UIColorFromRGB:0xc93532]];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}





#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_testArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatchTableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [self.catchesTableView dequeueReusableCellWithIdentifier:@"findFriends"];
    } else if (indexPath.row > 0) {
        if (indexPath.row % 2 == 0)
        {
            cell = [self.catchesTableView dequeueReusableCellWithIdentifier:@"incomingBall"];
            cell.isOpened = NO;
        } else {
            cell = [self.catchesTableView dequeueReusableCellWithIdentifier:@"openedBallCell"];
            cell.isOpened = YES;
        }
        
            cell.delegate = self;
        [cell setUp];
//        const CGFloat fontSize = 25;
//        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
//        UIFont *regFont = [UIFont systemFontOfSize:fontSize];
        cell.ballTitle.text = _labelArray[indexPath.row - 1];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:regFont, NSFontAttributeName,nil];
        //NSDictionary *subattributes = [NSDictionary dictionaryWithObjectsAndKeys:boldFont,NSFontAttributeName, nil];
        //NSRange range = NSMakeRange(10, 5);
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_labelArray[0] attributes:attributes];
        //[string setAttributes:subattributes range:range];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) return 40;
    if (indexPath.row == 2) return 140;
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (IBAction)test:(id)sender {
    [self.navigationController.navigationBar setBarTintColor:[Utils UIColorFromRGB:0xAC8CFF]];
    NewCatchViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewCatchViewController"];
    rootVC.checkKeyBoardHeight = YES;
    [self.navigationController pushViewController:rootVC animated:YES];

}
- (IBAction)pushFriendsViewController:(UIButton *)sender {
    
}

#pragma  mark CatchTableViewCellDelegate
-(void) catchBall:(CatchTableViewCell *)cell
{
    CatchViewController *ballViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CatchViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ballViewController];
    [self presentViewController:navigationController animated:YES completion:nil];

}

@end
