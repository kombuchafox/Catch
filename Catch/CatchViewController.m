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
#define toolBarButtonSize 45
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
    UIButton *dismiss;
    NSMutableArray *text;
    int value;
    UITextView *ballTitleTextView;
    UIButton *peopleButton, *inviteButton, *addButton;
    NSString *defaultString;
    UIToolbar *_inputAccessoryView;
    UIButton *addPictureButton;
    UIButton *doneButton;
    UILabel *characterCount;
}
//@property AddMessageTransitionManager *addMessageTransitionManager;
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
    value = 3;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = YES;

    [self.view setBackgroundColor:[Utils UIColorFromRGB:0xF5F5F5]];
    ballRowExpanded = false;
    self.ballTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.seperatorView drawSeparator];
    defaultString = @"What's really on your mind?";
    self.postStatusTextView.text = defaultString;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide]  ;
    
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
    return 1;
    
}
#pragma mark UITableViewDelegateMethods
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //{
//    BallTableView *table = (BallTableView *)tableView;
    CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
//    if (![table.stringIdentifier isEqualToString:@"commentsTableView"])
//    {
//        CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
        CollapsableHeaderView *headerView =[[CollapsableHeaderView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 45)];
        headerView.backgroundColor = [UIColor lightGrayColor];
//        //add tap gesture
//        headerView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collapseCell:)];
//        [headerView addGestureRecognizer:singleTap];
//        
//        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, deviceWidth- 20, defaultHeight)];
//        UIImageView *ballImageLayer;
//        title.textColor = [UIColor whiteColor];
//        title.font = [UIFont systemFontOfSize:36];
//        title.textAlignment = NSTextAlignmentCenter;
//
//        switch (section) {
//            case 2:
//                headerView.frame = CGRectMake(0, 0, deviceWidth, 50);
//                headerView.backgroundColor = [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f];
//     
//                title.textColor = [UIColor darkGrayColor];
//                title.text = @"People";
//                
//                headerView.sectionTag = @"1";
//                sendToHeaderView = headerView;
//                [title setCenter:headerView.center];
//                break;
//            case 0:
//                ballTitleTextView= [[UITextView alloc] initWithFrame:CGRectMake(10, 5, deviceWidth - 35, headerView.frame.size.height)];
//                ballTitleTextView.userInteractionEnabled = NO;
//                ballTitleTextView.text = @"#selfieGame";
//                ballTitleTextView.font = [UIFont boldSystemFontOfSize:18];
//                ballTitleTextView.textColor = [UIColor whiteColor];
//                ballTitleTextView.backgroundColor = [UIColor clearColor];
//                headerView.backgroundColor = [UIColor darkGrayColor];
//
//                dismiss = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - toolBarButtonSize + 5, 15, toolBarButtonSize, toolBarButtonSize)];
//                
//                
//                [dismiss setTitle:@"✖︎" forState:UIControlStateNormal];
//                dismiss.titleLabel.font = [UIFont systemFontOfSize:30];
//                [dismiss addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
//                headerView.frame = CGRectMake(0, 0, deviceWidth, 65);
//                [headerView addSubview:dismiss];
//                [headerView addSubview:ballTitleTextView];
//                headerView.sectionTag = @"0";
//                [headerView removeGestureRecognizer:singleTap];
//                catchPhraseHeaderView = headerView;
//                break;
//            case 1:
//                headerView.frame = CGRectMake(0, 0, deviceWidth, 50);
//                headerView.sectionTag = @"1";
//                sendToHeaderView = headerView;
//                [title setCenter:headerView.center];
//                break;
//            default:
//                break;
//        }
//        //create border
//        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, deviceWidth, 0.4f)];
//        
//        border.backgroundColor = [UIColor lightGrayColor];
//    //    [headerView addSubview:border];
//        [headerView addSubview:title];
//        headerView.titleLabel = title;
//        return headerView;
//    } else {
    return headerView;
//    }
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
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("%d", indexPath.row);
    UITableViewCell *cell;
//    UIView *ballView;
//    BallTableView *table = (BallTableView *) tableView;
//    if (![table.stringIdentifier isEqualToString:@"commentsTableView"])
//    {
//        
//        switch (indexPath.section) {
//            case 0:
//                if (indexPath.row == value) {
//                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//
//                    ballView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 35)];
//                    ballView.center = cell.center;
//                    ballView.layer.cornerRadius = 2;
//                    [ballView setBackgroundColor:[UIColor clearColor]];
//                    ballView.layer.borderWidth = 0.7;
//                    [cell.contentView addSubview:ballView];
//                    UILabel *loadMore = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100, 35)];
//                    loadMore.text = @"load more";
//                    loadMore.textColor = [UIColor darkGrayColor];
//                    loadMore.textAlignment = NSTextAlignmentCenter;
//                    [ballView addSubview:loadMore];
//                    [cell.contentView setBackgroundColor:[UIColor clearColor]];
//                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore:)];
//                    [ballView addGestureRecognizer:tap];
//                } else if (indexPath.row == 0) {
//                    cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"commentsTableViewCell"];
//                    CommentsTableViewCell *cellObj = (CommentsTableViewCell*) cell;
//                    cellObj.commentsTableView.stringIdentifier = @"commentsTableView";
//                    commentsTableViewCell = cellObj.commentsTableView;
//                    cellObj.commentsTableView.delegate = self;
//                    cellObj.commentsTableView.dataSource = self;
//                    [commentsTableViewCell setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//                }
//                break;
//            default:
//                cell = [[UITableViewCell alloc] init];
//                break;
//        }
//    } else {
//        if (indexPath.row == value)
//        {
    cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"commentTableViewCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
    [cell addGestureRecognizer:tap];
    // Do your cell customisation
    // cell.titleLabel.text = data.title;
    
    if (indexPath.row == value - 1)
    {
        
        [self loadMore:nil];
    }
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
//    BallTableView *table = (BallTableView *) tableView;
//    if ([table.stringIdentifier isEqualToString:@"commentsTableView"])
//    {
//
//
//        if (indexPath.row == value) return 50;
//        return 130;
//    } else {
//        switch (indexPath.section){
//            case 1:
//                height = [UIScreen mainScreen].bounds.size.height - 65;
//                break;
//            default:
//                height = [UIScreen mainScreen].bounds.size.height - 70 - toolBarButtonSize;
//                break;
//        }
//    }

        return 160;

}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return value;
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
    
    NSString *text = textView.text;
    
    if ([textView.text isEqualToString: defaultString]) {
        
        textView.text = @"";
    }
    [self createInputAccessoryView: textView];
    [textView setInputAccessoryView:_inputAccessoryView];
    CGRect bFrame = self.ballTableView.frame;
    CGRect sFrame = self.seperatorView.frame;
    CGRect tFrame = self.postStatusTextView.frame;
    [self.seperatorView setFrame:CGRectMake(sFrame.origin.x, sFrame.origin.y, bFrame.size.width, sFrame.size.height + 150)];
    [self.seperatorView drawSeparator];
    [self.ballTableView setFrame:CGRectMake(bFrame.origin.x, bFrame.origin.y + 150, bFrame.size.width, bFrame.size.height)];
    
    [self.postStatusTextView setFrame:CGRectMake(tFrame.origin.x, tFrame.origin.y, tFrame.size.width, tFrame.size.height)];
    

    
    
}

-(void)createInputAccessoryView: (UITextView *) textView {
        //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
        //[_inputAccessoryView addGestureRecognizer:tapGesture];
        
        _inputAccessoryView = [[UIToolbar alloc] init];
        _inputAccessoryView.translucent = YES;
        _inputAccessoryView.barTintColor = [UIColor lightGrayColor];
        UIView *keyBoard = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
        
        _inputAccessoryView.frame = CGRectMake(0, keyBoard.frame.origin.y - 35, self.view.frame.size.width, 35);
        
        UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:addPictureButton];
        
        
        //Use this to put space in between your toolbox buttons
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil action:nil];
        
        doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 300)];
        [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self action:nil];
        characterCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
        characterCount.text = @"100";
        characterCount.textColor = [UIColor whiteColor];
        UIBarButtonItem *characterLabel = [[UIBarButtonItem alloc] initWithCustomView:characterCount];
        doneItem.tintColor = [UIColor whiteColor];
        doneItem.customView = doneButton;
        NSArray *items = [NSArray arrayWithObjects:cameraItem, flexItem, characterLabel, flexItem, doneItem, nil];
        [_inputAccessoryView setItems:items animated:YES];
        [self.view addSubview:_inputAccessoryView];
 
}
-(void) doneButton: (UITapGestureRecognizer *) sender
{
    [_inputAccessoryView removeFromSuperview];
    [self.postStatusTextView endEditing:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *content = textView.text;
    //    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize]
    //                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame))
    //                          lineBreakMode:NSLineBreakByWordWrapping];
    
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    
    characterCount.text = [NSString stringWithFormat:@"%d", 100 - textView.text.length];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"" ]){
        textView.text = defaultString;
    }
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height+200);
    
    
}
@end
