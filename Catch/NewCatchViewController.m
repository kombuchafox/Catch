//
//  NewBallViewController.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/10/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "NewCatchViewController.h"
#import "AppNavigationController.h"
#import "AddMessageViewController.h"
#import "AddMessageTransitionManager.h"
#import "NewBallTableView.h"
#import "Utils.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "FriendsViewController.h"
#import "BallGraphicTableViewCell.h"
#import "CatchPhraseTableViewCell.h"
#import "CollapsableHeaderView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PickFriendsTableViewCell.h"
#import "UIImage+ResizeAdditions.h"
#import "HomeViewController.h"


#define headerViewHeight 45.0
#define navigationTitle  @"New Catch"
#define defaultThrowToLabel @"Throw To..."

@interface NewCatchViewController()
{
    int defaultHeight;
    float sectionBallHue;
    NSDictionary *identifierToSection;
    BallGraphicTableViewCell *tCell;
    bool ballRowExpanded;
    NSString *defaultCatchPhraseHeader;
    CollapsableHeaderView *catchPhraseHeaderView, *sendToHeaderView;
    CatchPhraseTableViewCell *catchPhraseViewCell;
    UIButton *camera;
    UIButton *cancelButton;
    UIButton *okButton;
    PickFriendsTableViewCell *friendsTableViewCell;
    NSMutableArray *chosenFriends;

    
}
@property (strong, nonatomic)   NSArray *colorArray;
@property (strong, nonatomic) IBOutlet NewBallTableView *ballTableView;
@property AddMessageTransitionManager *addMessageTransitionManager;
@property BallView *ballSectionView;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier threadPostBackgroundTaskId;

@end
@implementation NewCatchViewController
@synthesize ballSectionView, ballTableView, animator;
-(void) viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self setNeedsStatusBarAppearanceUpdate];
    identifierToSection = [[NSDictionary alloc] init];
    defaultHeight = 30;
    
}
-(void) setUp
{

    self.ballTableView.scrollEnabled = FALSE;
    //setup navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[Utils UIColorFromRGB:0xAC8CFF]];
    [self.view setBackgroundColor:[Utils UIColorFromRGB:0xF5F5F5]];
    int height = self.navigationController.navigationBar.frame.size.height + 0;
    int width = self.navigationController.navigationBar.frame.size.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, -3, width/2, height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [Utils UIColorFromRGB:0xFFFFFF];
    label.text = @"New Catch";
    label.font = [UIFont systemFontOfSize:31.5];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0];
    label.textAlignment = NSTextAlignmentCenter;
    UIView *overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width/2, height)];
    [overView addSubview:label];
    self.navigationItem.titleView = overView;
    self.ballTableView.delegate = self;
    ballRowExpanded = true;
    [self.backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    self.ballTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUp];
}



- (IBAction)pushFriendsViewController:(UIButton *)sender {
    [self.navigationController.navigationBar setBarTintColor:[Utils UIColorFromRGB:0xD73033]];
    FriendsViewController *friends = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    [self.navigationController pushViewController:friends animated:YES];
}
- (IBAction)popViewController:(id)sender {
    
    [self.navigationController.navigationBar setBarTintColor:[Utils UIColorFromRGB:0xD73033]];
    [self.navigationController.navigationBar setTranslucent:NO];
    HomeViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:@[self]];
    [vcs insertObject:rootVC atIndex:0];
    [self.navigationController setViewControllers:vcs animated:NO];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
#pragma mark UITableViewDelegateMethods
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//{
    CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
   CollapsableHeaderView *headerView =[[CollapsableHeaderView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth,headerViewHeight + 5)];
//    //add tap gesture
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collapseCell:)];
    [headerView addGestureRecognizer:singleTap];
    
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(92, 0, deviceWidth- 92, headerViewHeight - 10)];
    UIImageView *ballImageLayer;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:28];
    title.textAlignment = NSTextAlignmentCenter;
    if (!cancelButton)
    {
    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, headerViewHeight, headerViewHeight)];
    [cancelButton setTitle: @"✕" forState: UIControlStateNormal];

    cancelButton.titleLabel.font = [UIFont systemFontOfSize:30];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(goToOpenPaper:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!okButton)
    {
        okButton = [[UIButton alloc]initWithFrame:CGRectMake(deviceWidth - headerViewHeight - 5, 0, headerViewHeight, headerViewHeight)];
        [okButton setTitle: @"✔︎"forState: UIControlStateNormal];
        [okButton addTarget:self action:@selector(flingBall:) forControlEvents:UIControlEventTouchUpInside];
        okButton.userInteractionEnabled = FALSE;
        okButton.titleLabel.font = [UIFont systemFontOfSize:30];
        okButton.titleLabel.textColor = [UIColor lightGrayColor];
    }

    switch (section) {
        case 0:
            
            if (!ballRowExpanded)
            {
                headerView.backgroundColor = [Utils UIColorFromRGB:0xE8E4D8];
                ballImageLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crumpled_paper.png"]];
                ballImageLayer.alpha = 0.6f;
                ballImageLayer.frame = CGRectMake(0, 20, headerViewHeight, headerViewHeight);
                [ballImageLayer setCenter: CGPointMake(self.view.center.x, 23)];
                [headerView addSubview:ballSectionView];
                [headerView addSubview:ballImageLayer];
                [headerView setFrame:CGRectMake(0,0, deviceWidth, 1)];
                headerView.sectionTag = @"0";
            } else {
                headerView.frame =CGRectMake(0, 0, deviceWidth, .5);
                headerView.alpha = 0;
            }
            [title setCenter:headerView.center];
            break;
        case 2:
            title.font = [UIFont systemFontOfSize:30];
            title.frame =  CGRectMake(10, 0, deviceWidth - headerViewHeight, headerViewHeight);
            headerView.backgroundColor = [Utils UIColorFromRGB:0x83CDFF];
            if([catchPhraseViewCell.textView.text isEqualToString: catchPhraseViewCell.defaultString])
            {
                title.text = defaultCatchPhraseHeader;
            } else {
                title.text = catchPhraseViewCell.textView.text;
                title.font = [UIFont boldSystemFontOfSize:40];
            }
            
            headerView.sectionTag = @"0";
            catchPhraseHeaderView = headerView;
            break;
        case 1:
            headerView.backgroundColor = [Utils UIColorFromRGB:0xE8A731];
            headerView.frame = CGRectMake(0, 0, deviceWidth, headerViewHeight);
            [headerView addSubview:cancelButton];
            [headerView addSubview:okButton];
            if ([chosenFriends count] > 0)
            {
                title.text = [self titleFromFriendList];
            } else {
                title.text = defaultThrowToLabel;
            }
            headerView.sectionTag = @"1";
            sendToHeaderView = headerView;
            [title setCenter:headerView.center];
            //initialize as hidden;

            break;
        default:
            break;
    }
//    //create border
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, deviceWidth, 0.4f)];
    
    border.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:border];
    [headerView addSubview:title];
    headerView.titleLabel = title;
    return headerView;
}
-(void) goToOpenPaper: (UITapGestureRecognizer *) sender
{
    self.didPinchPaper = NO;
    catchPhraseViewCell.textView.hidden = NO;
    catchPhraseViewCell.ballGraphic.hidden = YES;
    [friendsTableViewCell.pickedIndexes removeAllObjects];
    [self openPaper];
    [friendsTableViewCell clearData];
    chosenFriends = nil;
    okButton.userInteractionEnabled = NO;
    okButton.titleLabel.textColor = [UIColor lightGrayColor];
}
-(void) flingBall: (UITapGestureRecognizer *) sender
{
    catchPhraseViewCell.textView.hidden = YES;
    catchPhraseViewCell.ballGraphic.hidden = NO;
     [self openPaper];
}
-(void) presentPhotoAlbum: (UIButton*) sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    // Don't forget to add UIImagePickerControllerDelegate in your .h
    picker.delegate = self;
    //link to photo album right now
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0 && !self.didPinchPaper) {
       return 0.1;
    }
    return headerViewHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("%d", indexPath.section);
    UITableViewCell *cell;
    CGRect frame;
    switch (indexPath.section) {
        case 0:
            if (!catchPhraseViewCell)
            {
                catchPhraseViewCell = [self.ballTableView dequeueReusableCellWithIdentifier:@"CatchPhraseCell"];
                catchPhraseViewCell.delegate = self;

                //frame = catchPhraseViewCell.addPictureButton.frame;
            }
            cell = catchPhraseViewCell;
            break;
        case 1:
            cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"friendsTableViewCell"];
            
            friendsTableViewCell = (PickFriendsTableViewCell *) cell;
            friendsTableViewCell.friendsTableView.delegate = friendsTableViewCell;
            friendsTableViewCell.friendsTableView.dataSource = friendsTableViewCell;
            friendsTableViewCell.delegate = self;
            break;
        case 2:
            if (!tCell) {
            tCell = [self.ballTableView dequeueReusableCellWithIdentifier:@"interactiveBallGraphic"];
            [tCell setUp];
            [tCell resizeBallToScreen: [self tableView:tableView heightForRowAtIndexPath:indexPath]];
            tCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tCell.delegate = self;
            }
            cell = tCell;
            break;
        default:
            cell = [[UITableViewCell alloc] init];
            break;
    }

    return cell;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height;

    if (!self.didPinchPaper && indexPath.section == 0 &&  catchPhraseViewCell.textView.hidden) {
        height = [UIScreen mainScreen].bounds.size.height - headerViewHeight - 65;
        cancelButton.hidden = YES;
        okButton.hidden = YES;
    } else if (!self.didPinchPaper && indexPath.section == 0) {
        height = [UIScreen mainScreen].bounds.size.height - headerViewHeight - 20;
        cancelButton.hidden = NO;
        okButton.hidden = NO;
    } else if (indexPath.section == 1){
        cancelButton.hidden = NO;
        okButton.hidden = NO;
        height = [UIScreen mainScreen].bounds.size.height - headerViewHeight*2 - 65;
    }

    return height;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}




#pragma mark CollapseableDataSource
-(BOOL) isInitiallyCollapsed:(NSNumber *)section
{
    if ([section intValue] == 0) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark BallViewDelegate
-(void) updateBallColor:(CGFloat)value
{
    [ballSectionView updateColor:[UIColor colorWithHue:value saturation:1 brightness:1 alpha:1]];
}
-(void)setAllViewToZeroAlpha
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.titleView = nil;
    self.navigationController.navigationBar.translucent = YES;
    self.backButton.titleLabel.text = @"";
}

-(void) changeOriginYBy: (CGFloat) newY for:(UIView *) view;
{
    view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height);
}

#pragma mark TapGesuteMethod
-(void)collapseCell:(UITapGestureRecognizer *) tap
{
    if ([tap.view isKindOfClass:[CollapsableHeaderView class]])
    {
        CollapsableHeaderView *view = (CollapsableHeaderView *)tap.view;
        switch ([view.sectionTag intValue]) {
            case 0:
                
                self.didPinchPaper = NO;
                [self openPaper];
                self.ballTableView.scrollEnabled = false;
                ballRowExpanded = true;
                break;
            case 1:
                
                self.ballTableView.scrollEnabled = FALSE;
                ballRowExpanded = false;
                [self collapsePaper];
                break;
            case 2:
                ballRowExpanded = false;
                self.ballTableView.scrollEnabled = false;
                break;
            default:
                break;
        }
        
       [self.ballTableView expandHeader:[view.sectionTag intValue]];

    }
}

-(void) collapsePaper
{
    self.didPinchPaper = TRUE;
    ballRowExpanded = false;
    [self.ballTableView expandHeader:1];

}
-(void) openPaper
{

    self.didPinchPaper = FALSE;

    ballRowExpanded = true;
    [self.ballTableView expandHeader:0];

    
}
#pragma mark CatchPhraseDelegate
-(void) updateText:(NSString *)newText
{
    if ([newText isEqualToString:@""]) {
        catchPhraseHeaderView.titleLabel.text = defaultCatchPhraseHeader;
        catchPhraseHeaderView.titleLabel.font = [UIFont systemFontOfSize:36];
    } else {
        catchPhraseHeaderView.titleLabel.text = newText;
        catchPhraseHeaderView.titleLabel.font = [UIFont boldSystemFontOfSize:36];
    }
}

-(BOOL) shouldUploadThread:(UIImage *) image withText:(NSString *)text
{
    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [image thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
            
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}
-(void) postThread
{    // Make sure there were no errors creating the image files
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your thread" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    PFObject *thread = [PFObject objectWithClassName:@"Thread"];
    [thread setObject:self.photoFile forKey:@"image"];
    [thread setObject:self.thumbnailFile forKey:@"thumbnailImage"];
    [thread setObject:@"helloWorld" forKey:@"content"];
    self.threadPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.threadPostBackgroundTaskId];
    }];
    [thread saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (succeeded)
         {
            [self popViewController:nil];
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your thread" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
             [alert show];

         }
         [[UIApplication sharedApplication] endBackgroundTask:self.threadPostBackgroundTaskId];
     }];
}
#pragma mark UIImagePickerControllDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    catchPhraseViewCell.memeImage = pickedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark miscallenanous
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark PickFriendTableViewDelegate
-(void) updatePickFriendHeaderView: (NSMutableArray *) friends;
{
    chosenFriends = friends;
    if ([friends count] > 0)
    {
        sendToHeaderView.titleLabel.text = [self titleFromFriendList];
        sendToHeaderView.titleLabel.font = [UIFont systemFontOfSize:20];
        [okButton.titleLabel setTextColor:[UIColor whiteColor]];
        okButton.userInteractionEnabled = TRUE;
    } else
    {
        [okButton.titleLabel setTextColor:[UIColor lightGrayColor]];
        okButton.userInteractionEnabled = FALSE;
        sendToHeaderView.titleLabel.text = defaultThrowToLabel;
        sendToHeaderView.titleLabel.font = [UIFont systemFontOfSize:28];
    }
}
-(NSString*) titleFromFriendList
{
    NSString *newTitle = @" ";
    for (int i = 0; i < [chosenFriends count]; i++)
    {
        NSMutableDictionary *friendData = [chosenFriends objectAtIndex:i];
        if (i == 0)
        {
            newTitle = [friendData objectForKey:@"first_name"];
        } else
        {
            newTitle = [newTitle stringByAppendingString:[NSString stringWithFormat:@", %@", [friendData objectForKey:@"first_name"]]];
        }
    }
    return newTitle;
}
@end
