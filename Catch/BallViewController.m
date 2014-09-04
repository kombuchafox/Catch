//
//  BallViewController.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/27/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "BallViewController.h"
#import "CollapsableHeaderView.h"
#import "Utils.h"
#import "CommentsTableViewCell.h"
#import "CommentTableViewCell.h"
#import "ImageInspectorViewController.h"
#define toolBarButtonSize 45
@interface BallViewController () <UITableViewDataSource, UITableViewDelegate>
{
    int defaultHeight;
    float sectionBallHue;
    NSDictionary *identifierToSection;
    BallGraphicTableViewCell *tCell;
    bool ballRowExpanded;
    NSString *defaultCatchPhraseHeader;
    CollapsableHeaderView *catchPhraseHeaderView, *sendToHeaderView;
    CatchPhraseTableViewCell *catchPhraseViewCell;
    UIButton *dismiss;
    NSMutableArray *text;
    int value;
    UITextView *ballTitleTextView;
    BallTableView *commentsTableViewCell;
    UIButton *peopleButton, *inviteButton, *addButton;
}
//@property AddMessageTransitionManager *addMessageTransitionManager;
@property BallView *ballSectionView;
@end

@implementation BallViewController
@synthesize ballSectionView;
-(void) viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    identifierToSection = [[NSDictionary alloc] init];
    defaultHeight = 40;
    
}
-(void) setUp
{
    value = 3;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = YES;

    [dismiss setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[self.view addSubview:dismiss];
    [self.view setBackgroundColor:[Utils UIColorFromRGB:0xF5F5F5]];
    
    ballRowExpanded = false;
    
    //self.ballTableView.frame = CGRectMake(self.ballTableView.frame.origin.x, self.ballTableView.frame.origin.y, self.ballTableView.frame.size.width,[UIScreen mainScreen].bounds.size.height - 64);
    defaultCatchPhraseHeader =@"Add Catch Phrase";
    self.ballTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [UIView animateWithDuration:0.1 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
}

- (IBAction)dismissNewBall:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}






#pragma mark textView delegate
-(BOOL) textViewShouldBeginEditing:(UITextView *) textView
{
//    self.messageView.textColor = [UIColor darkGrayColor];
//    AddMessageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMessageViewController"];
//    viewController.modalPresentationStyle = UIModalPresentationCustom;
//    viewController.transitioningDelegate  = self.addMessageTransitionManager;
//    [self presentViewController:viewController animated:true completion:^{
//        self.messageView.hidden = YES;
//    }];
    return false;
    
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BallTableView *table = (BallTableView *) tableView;
    if ([table.stringIdentifier isEqualToString:@"commentsTableView"]){
        return 1;
    }
    return 2;
    
}
#pragma mark UITableViewDelegateMethods
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //{
    BallTableView *table = (BallTableView *)tableView;
    CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
    if (![table.stringIdentifier isEqualToString:@"commentsTableView"])
    {
        CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
        CollapsableHeaderView *headerView =[[CollapsableHeaderView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 65)];
        //add tap gesture
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collapseCell:)];
        [headerView addGestureRecognizer:singleTap];
        
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, deviceWidth- 20, defaultHeight)];
        UIImageView *ballImageLayer;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:36];
        title.textAlignment = NSTextAlignmentCenter;

        switch (section) {
            case 2:
                headerView.frame = CGRectMake(0, 0, deviceWidth, 50);
                headerView.backgroundColor = [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f];
     
                title.textColor = [UIColor darkGrayColor];
                title.text = @"People";
                
                headerView.sectionTag = @"1";
                sendToHeaderView = headerView;
                [title setCenter:headerView.center];
                break;
            case 0:
                ballTitleTextView= [[UITextView alloc] initWithFrame:CGRectMake(10, 5, deviceWidth - 35, headerView.frame.size.height)];
                ballTitleTextView.userInteractionEnabled = NO;
                ballTitleTextView.text = @"Who's got a stronger selfie game?";
                ballTitleTextView.font = [UIFont boldSystemFontOfSize:18];
                ballTitleTextView.textColor = [UIColor whiteColor];
                ballTitleTextView.backgroundColor = [UIColor clearColor];
                headerView.backgroundColor = [UIColor darkGrayColor];

                dismiss = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - toolBarButtonSize + 5, 15, toolBarButtonSize, toolBarButtonSize)];
                
                
                [dismiss setTitle:@"✖︎" forState:UIControlStateNormal];
                dismiss.titleLabel.font = [UIFont systemFontOfSize:30];
                [dismiss addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
                headerView.frame = CGRectMake(0, 0, deviceWidth, 70);
                [headerView addSubview:dismiss];
                [headerView addSubview:ballTitleTextView];
    //            if([catchPhraseViewCell.textView.text isEqualToString: catchPhraseViewCell.defaultString])
    //            {
                    //title.text = defaultCatchPhraseHeader;
                //} else {
    //                title.text = catchPhraseViewCell.textView.text;
    //                title.font = [UIFont boldSystemFontOfSize:40];
    //            }
                
                headerView.sectionTag = @"0";
                catchPhraseHeaderView = headerView;
                break;
            case 1:
                headerView.frame = CGRectMake(0, 0, deviceWidth, 50);
//                headerView.backgroundColor = [Utils UIColorFromRGB:0xFFFFFF];
//                addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, deviceWidth/3, toolBarButtonSize)];
//                addButton.backgroundColor = [Utils UIColorFromRGB:0xFFFFF];
//                addButton.layer.borderColor = [UIColor whiteColor].CGColor;
//                addButton.layer.borderWidth = 0.8;
//                addButton.backgroundColor = [Utils UIColorFromRGB:0x88CCE8];
//                peopleButton = [[UIButton alloc] initWithFrame:CGRectMake(deviceWidth/3, 0, deviceWidth/3, toolBarButtonSize)];
//                peopleButton.backgroundColor = [Utils UIColorFromRGB:0xFFFFF];
//                peopleButton.layer.borderColor = [UIColor whiteColor].CGColor;
//                peopleButton.layer.borderWidth = 0.8;
//                peopleButton.backgroundColor = [Utils UIColorFromRGB:0x88CCE8];
//                inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(deviceWidth * 2/3, 0, deviceWidth/3, toolBarButtonSize)];
//                inviteButton.layer.borderColor = [UIColor whiteColor].CGColor;
//                inviteButton.layer.borderWidth = 0.8;
//                inviteButton.backgroundColor = [Utils UIColorFromRGB:0x88CCE8];
//                title.textColor = [UIColor whiteColor];
//
//                [headerView addSubview:addButton], [headerView addSubview:inviteButton], [headerView addSubview:peopleButton];
                headerView.sectionTag = @"1";
                sendToHeaderView = headerView;
                [title setCenter:headerView.center];
                break;
            default:
                break;
        }
        //create border
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, deviceWidth, 0.4f)];
        
        border.backgroundColor = [UIColor lightGrayColor];
    //    [headerView addSubview:border];
        [headerView addSubview:title];
        headerView.titleLabel = title;
        return headerView;
    } else {
        return [[CollapsableHeaderView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 0.1)];
    }
}
-(void) dismissSelf: (UIButton *) sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
-(void) presentPhotoAlbum: (UIButton*) sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    // Don't forget to add UIImagePickerControllerDelegate in your .h
    picker.delegate = self;
    
    //    if((UIButton *) sender == choosePhotoBtn) {
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    } else {
    //        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    }
    
    [self presentViewController:picker animated:YES completion:nil];
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BallTableView *table = (BallTableView *) tableView;
    if (![table.stringIdentifier isEqualToString:@"commentsTableView"])
    {
        switch (section) {
            case 0:
                return 70;
                
            default:
                return toolBarButtonSize;
        }
    } else {
        return 0.1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("%d", indexPath.section);
    UITableViewCell *cell;
    UIView *ballView;
    BallTableView *table = (BallTableView *) tableView;
    if (![table.stringIdentifier isEqualToString:@"commentsTableView"])
    {
        
        switch (indexPath.section) {
            case 1:
                if (indexPath.row == value) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];

                    ballView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 35)];
                    ballView.center = cell.center;
                    ballView.layer.cornerRadius = 2;
                    [ballView setBackgroundColor:[UIColor clearColor]];
                    ballView.layer.borderWidth = 0.7;
                    [cell.contentView addSubview:ballView];
                    UILabel *loadMore = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 35)];
                    loadMore.text = @"load more";
                    loadMore.textColor = [UIColor darkGrayColor];
                    loadMore.textAlignment = NSTextAlignmentCenter;
                    [ballView addSubview:loadMore];
                    [cell.contentView setBackgroundColor:[UIColor clearColor]];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore:)];
                    [ballView addGestureRecognizer:tap];
                } else if (indexPath.row == 0) {
                    cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"commentsTableViewCell"];
                    CommentsTableViewCell *cellObj = (CommentsTableViewCell*) cell;
                    cellObj.commentsTableView.stringIdentifier = @"commentsTableView";
                    commentsTableViewCell = cellObj.commentsTableView;
                    cellObj.commentsTableView.delegate = self;
                    cellObj.commentsTableView.dataSource = self;
                    [commentsTableViewCell setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                }
                break;
            default:
                cell = [[UITableViewCell alloc] init];
                break;
        }
    } else {
        if (indexPath.row == value)
        {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
            
            ballView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 35)];
            ballView.center = cell.center;
            ballView.layer.cornerRadius = 2;
            [ballView setBackgroundColor:[UIColor clearColor]];
            ballView.layer.borderWidth = 0.7;
            [cell.contentView addSubview:ballView];
            UILabel *loadMore = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 35)];
            loadMore.text = @"load more";
            loadMore.textColor = [UIColor darkGrayColor];
            loadMore.textAlignment = NSTextAlignmentCenter;
            [ballView addSubview:loadMore];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore:)];
            [ballView addGestureRecognizer:tap];
        } else {
            cell = [commentsTableViewCell dequeueReusableCellWithIdentifier:@"commentTableViewCell"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
            [cell addGestureRecognizer:tap];
            
        }
        
    }
    
    NSLog(@"e");
    
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    BallTableView *table = (BallTableView *) tableView;
    if ([table.stringIdentifier isEqualToString:@"commentsTableView"])
    {


        if (indexPath.row == value) return 50;
        return 130;
    } else {
        switch (indexPath.section){
            case 1:
                height = [UIScreen mainScreen].bounds.size.height - 65;
                break;
            default:
                height = [UIScreen mainScreen].bounds.size.height - 70 - toolBarButtonSize;
                break;
        }
    }
    return height;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BallTableView *table = (BallTableView *) tableView;
    if ([table.stringIdentifier isEqualToString:@"commentsTableView"])
    {
            return value + 1;
    }
    return 1;
}

-(void)tableView:(UITableView *) tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark CollapseableDataSource
-(BOOL) isInitiallyCollapsed:(NSNumber *)section
{
    if ([section intValue] == 0) {
        return YES;
    } else {
        return YES;
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
    
    
    //[self changeOriginYBy:self.ballTableView.frame.origin.y - 64 for:self.ballTableView];
    //    catchPhraseHeaderView.alpha = 0.2f;
    //    sendToHeaderView.alpha = 0.2f;
    
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
        [self.ballTableView expandHeader:[view.sectionTag intValue]];
        switch ([view.sectionTag intValue]) {
            case 0:
                catchPhraseHeaderView.frame = CGRectMake(catchPhraseHeaderView.frame.origin.x, catchPhraseHeaderView.frame.origin.y, catchPhraseHeaderView.frame.size.width, catchPhraseHeaderView.frame.size.height + 100);

                ballRowExpanded = false;
                self.ballTableView.scrollEnabled = YES;
                
                break;
            case 1:

                self.ballTableView.scrollEnabled = true;
                ballRowExpanded = false;
                break;
            case 2:
                ballRowExpanded = true;
                //self.ballTableView.scrollEnabled = false;
                break;
            default:
                break;
        }
    }
}
#pragma mark CatchPhraseDelegate
-(void) updateText:(NSString *)newText
{
    if ([newText isEqualToString:@""]) {
        catchPhraseHeaderView.titleLabel.text = defaultCatchPhraseHeader;
        catchPhraseHeaderView.titleLabel.font = [UIFont systemFontOfSize:36];
    } else {
        catchPhraseHeaderView.titleLabel.text = newText;
        catchPhraseHeaderView.titleLabel.font = [UIFont boldSystemFontOfSize:40];
    }
    
    
}

#pragma mark UIImagePickerControllDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    catchPhraseViewCell.memeImage = pickedImage;
    [catchPhraseViewCell toggleContents];
    //controller.imageView.image = pickedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void) loadMore: (UITapGestureRecognizer *) sender
{
    value += 3;
    [commentsTableViewCell reloadData];
}

#pragma mark miscalleanous
-(void) showPicture: (UITapGestureRecognizer *) sender
{
    if ([sender.view isKindOfClass:[CommentTableViewCell class]])
    {
        CommentTableViewCell *comment = (CommentTableViewCell *)sender.view;
        if (comment.attachedImage.image != nil) {
            ImageInspectorViewController *imageInspector = [self.storyboard instantiateViewControllerWithIdentifier:@"imageInspectorViewController"];
            imageInspector.image = comment.attachedImage.image;
            
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:imageInspector animated:YES];
        }
    }
}
@end
