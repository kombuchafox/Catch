//
//  BallViewController.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/27/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "CatchViewController.h"
#import "CollapsableHeaderView.h"
#import "Utils.h"
#import "CommentsTableViewCell.h"
#import "CommentTableViewCell.h"
#import "ImageInspectorViewController.h"
#import "ToolbarSingleton.h"
#import "PickFriendsTableViewCell.h"
#import "PaperBallTableViewCell.h"
#define toolBarButtonSize 45
#define headerViewHeight 45.0
#define defaultThrowToLabel @"Throw To..."

@interface CatchViewController () <UITableViewDataSource, UITableViewDelegate>
{
    int defaultHeight;
    float sectionBallHue;
    NSDictionary *identifierToSection;
    BallGraphicTableViewCell *tCell;
    bool ballRowExpanded;
    NSString *defaultCatchPhraseHeader;
    CollapsableHeaderView *catchPhraseHeaderView, *sendToHeaderView;
    CatchPhraseTableViewCell *catchPhraseViewCell;
    int value;
    UITextView *ballTitleTextView;
    UIButton *peopleButton, *inviteButton, *addButton, *dismiss;
    NSMutableDictionary *tableViewCellReferences;
    NSString *defaultString;
    UIButton *cancelButton;
    UIButton *okButton;
    bool renderCrumpledBall;
    PickFriendsTableViewCell *pickFriendsCell;
}

@property BallView *ballSectionView;
@end

@implementation CatchViewController
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
    value = 6;
    tableViewCellReferences = [[NSMutableDictionary alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = YES;

    [self.view setBackgroundColor:[Utils UIColorFromRGB:0xF5F5F5]];
    ballRowExpanded = false;
    self.ballTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchedTableView:)];
    [self.view addGestureRecognizer:pinch];
    [self.seperatorView drawSeparator];
    defaultString = @"What's really on your mind?";
    self.postStatusTextView.text = defaultString;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide]  ;
    
}

-(void) pinchedTableView: (UIPinchGestureRecognizer *) sender
{
//    if (!self.didPinchPaper)
//    {
        self.didPinchPaper = TRUE;
        [self.ballTableView expandHeader:1];
    [UIView animateWithDuration:0.2 animations:
     ^{
         self.seperatorView.hidden = TRUE;
         self.ballTableView.frame = CGRectMake(0, self.seperatorView.frame.origin.y, [UIScreen mainScreen].bounds.size.width,
                                               [UIScreen mainScreen].bounds.size.height - self.seperatorView.frame.origin.y);
     }
     ];

}

- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
}

- (IBAction)dismissNewBall:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}






#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
#pragma mark UITableViewDelegateMethods
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat deviceWidth = [UIScreen mainScreen].bounds.size.width;
    CollapsableHeaderView *headerView = [[CollapsableHeaderView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(92, 0, deviceWidth- 92, headerViewHeight - 10)];
    UIImageView *ballImageLayer;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:28];
    title.textAlignment = NSTextAlignmentCenter;

    if (!cancelButton)
    {
        cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, headerViewHeight, headerViewHeight)];
        [cancelButton setTitle: @"✖︎" forState: UIControlStateNormal];
        
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:30];
        cancelButton.titleLabel.textColor = [UIColor whiteColor];
        [cancelButton addTarget:self action:@selector(goToOpenPaper:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!okButton)
    {
        okButton = [[UIButton alloc]initWithFrame:CGRectMake(deviceWidth - headerViewHeight - 5, 0, headerViewHeight, headerViewHeight)];
        [okButton setTitle: @"✔︎"forState: UIControlStateNormal];
        [okButton addTarget:self action:@selector(flingBall:) forControlEvents:UIControlEventTouchUpInside];
        okButton.titleLabel.font = [UIFont systemFontOfSize:30];
        okButton.titleLabel.textColor = [UIColor lightGrayColor];
        okButton.userInteractionEnabled = FALSE;
    }
    if (section == 1) {
        headerView.backgroundColor = [Utils UIColorFromRGB:0xE8A731];
        headerView.frame = CGRectMake(0, 0, deviceWidth, headerViewHeight);
        [headerView addSubview:cancelButton];
        [headerView addSubview:okButton];
        title.text = defaultThrowToLabel;
        headerView.sectionTag = @"1";
        sendToHeaderView = headerView;
        sendToHeaderView.titleLabel = title;
        [sendToHeaderView addSubview:sendToHeaderView.titleLabel];
        [title setCenter:headerView.center];
        //initialize as hidden;
    }
    return headerView;

}
-(void) flingBall:(UITapGestureRecognizer *) sender
{
    renderCrumpledBall = YES;
    self.ballTableView.scrollEnabled = FALSE;
    [self goToCrumpledBall];
}
-(void) dismissSelf: (UIButton *) sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
-(void) goToOpenPaper:(UITapGestureRecognizer *)sender
{
    self.didPinchPaper = FALSE;
    [self.ballTableView expandHeader:0];
    [UIView animateWithDuration:0.2 animations:
     ^{
         self.seperatorView.hidden = FALSE;
         self.ballTableView.frame = CGRectMake(0, self.seperatorView.frame.size.height + self.seperatorView.frame.origin.y, [UIScreen mainScreen].bounds.size.width,self.ballTableView.frame.size.height - self.seperatorView.frame.size.height);
     }
     ];
    [pickFriendsCell clearData];
    self.ballTableView.scrollEnabled = YES;
    okButton.userInteractionEnabled = NO;
    okButton.titleLabel.textColor = [UIColor lightGrayColor];
}
-(void) goToCrumpledBall
{
    [self.ballTableView expandHeader:0];
}
-(void) presentPhotoAlbum: (UIButton*) sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.didPinchPaper)
    {
    return 0.1;
    } else
    {
        if (section == 1) return 45;
        return 0.1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        if (renderCrumpledBall)
        {
            cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"crumpledPaperCell"];
            PaperBallTableViewCell *paperCell = (PaperBallTableViewCell *) cell;
            [paperCell setUp];
        } else {
            cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"commentTableViewCell"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
            [cell addGestureRecognizer:tap];
            CommentTableViewCell *comment = (CommentTableViewCell *) cell;
            [tableViewCellReferences setObject:comment forKey:[NSNumber numberWithInt:indexPath.row]];
            
            if (indexPath.row % 3 == 1) {
                comment.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ";
            } else if (indexPath.row % 3 == 0) {
                comment.textView.text = @" quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat";
            } else {
                comment.textView.text = @"factor tum poen legum odioque civiuda.";
            }
            if (indexPath.row == value - 1)
            {
                
                [self loadMore:nil];
            }
        }
    } else {
        cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"friendsTableViewCell"];
        pickFriendsCell = (PickFriendsTableViewCell *) cell;
        pickFriendsCell.delegate = self;
        
    }
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.didPinchPaper)
    {
        CommentTableViewCell *cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"commentTableViewCell"];
        if (indexPath.row % 3 == 1) {
            cell.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ";
        } else if (indexPath.row % 3 == 0) {
            cell.textView.text = @" quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat";
        } else {
            cell.textView.text = @"factor tum poen legum odioque civiuda.";
        }
        
        int height = [Utils measureHeightOfUITextView:cell.textView];
        return height + 10;
    } else {
        return self.ballTableView.frame.size.height - 100;
    }

}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if (renderCrumpledBall) return 1;
            return value;
            break;
        case 1:
            return 1;
        default:
            return 1;
            break;
    }
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
        return NO;
    }
}
#pragma mark BallViewDelegate
-(void) updateBallColor:(CGFloat)value
{
    //[ballSectionView updateColor:[UIColor colorWithHue:value saturation:1 brightness:1 alpha:1]];
}
-(void)setAllViewToZeroAlpha
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.titleView = nil;
    self.navigationController.navigationBar.translucent = YES;
    
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
                self.ballTableView.scrollEnabled = FALSE;
                
                break;
            case 1:

                self.ballTableView.scrollEnabled = FALSE;
                ballRowExpanded = false;
                break;
            case 2:
                ballRowExpanded = true;
                self.ballTableView.scrollEnabled = false;
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

    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void) loadMore: (UITapGestureRecognizer *) sender
{
    value += 3;
    [self.ballTableView reloadData];
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

#pragma mark UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)note {
    // create custom button
    
    
    
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    

    
    if ([textView.text isEqualToString: defaultString]) {
        
        textView.text = @"";
    }
    ToolbarSingleton *toolbBarManager = [ToolbarSingleton sharedManager];
    [toolbBarManager changeDoneButtonTitle:@"Post"];
    CGRect frame = toolbBarManager.keyboardToolbar.frame;

    frame.origin = CGPointMake(0, 317);
    toolbBarManager.keyboardToolbar.frame = frame;
    [self.view addSubview:toolbBarManager.keyboardToolbar];
    toolbBarManager.delegate = self;
    CGRect bFrame = self.ballTableView.frame;
    CGRect sFrame = self.seperatorView.frame;
    CGRect tFrame = self.postStatusTextView.frame;
    [self.seperatorView setFrame:CGRectMake(sFrame.origin.x, sFrame.origin.y, bFrame.size.width, sFrame.size.height + 150)];
    [self.seperatorView drawSeparator];
    [self.ballTableView setFrame:CGRectMake(bFrame.origin.x, bFrame.origin.y + 150, bFrame.size.width, bFrame.size.height)];

    [self.postStatusTextView setFrame:CGRectMake(tFrame.origin.x, tFrame.origin.y, tFrame.size.width, tFrame.size.height + 150)];
    [self.postStatusTextView setFont:[UIFont systemFontOfSize:24]];
    

    
    
}


-(void) doneButton
{
    ToolbarSingleton *toolBar = [ToolbarSingleton sharedManager];
    [toolBar.keyboardToolbar removeFromSuperview];
    [self.postStatusTextView endEditing:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{

    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    ToolbarSingleton *toolBar = [ToolbarSingleton sharedManager];
    toolBar.characterCount.text = [NSString stringWithFormat:@"%d", 100 - textView.text.length];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"" ]){
        textView.text = defaultString;
    }
    CGRect bFrame = self.ballTableView.frame;
    CGRect sFrame = self.seperatorView.frame;
    CGRect tFrame = self.postStatusTextView.frame;
    [self.seperatorView setFrame:CGRectMake(sFrame.origin.x, sFrame.origin.y, bFrame.size.width, sFrame.size.height - 150)];
    [self.seperatorView drawSeparator];
    [self.ballTableView setFrame:CGRectMake(bFrame.origin.x, bFrame.origin.y - 150, bFrame.size.width, bFrame.size.height)];
    
    [self.postStatusTextView setFrame:CGRectMake(tFrame.origin.x, tFrame.origin.y, tFrame.size.width, tFrame.size.height - 150)];
    [self.postStatusTextView setFont:[UIFont systemFontOfSize:17]];
    
}
#pragma mark PickFriendTableViewDelegate
-(void) updatePickFriendHeaderView: (NSMutableArray *) friends;
{
    NSString *newTitle = @" ";
    for (int i = 0; i < [friends count]; i++)
    {
        NSMutableDictionary *friendData = [friends objectAtIndex:i];
        if (i == 0)
        {
            newTitle = [friendData objectForKey:@"first_name"];
        } else
        {
            newTitle = [newTitle stringByAppendingString:[NSString stringWithFormat:@", %@", [friendData objectForKey:@"first_name"]]];
        }
    }
    if (![newTitle isEqualToString:@" "])
    {
        sendToHeaderView.titleLabel.text = newTitle;
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
@end
