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
    int value;
    UITextView *ballTitleTextView;
    UIButton *peopleButton, *inviteButton, *addButton, *dismiss;
    NSMutableDictionary *tableViewCellReferences;
    NSString *defaultString;
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
    value = 3;
    tableViewCellReferences = [[NSMutableDictionary alloc] init];
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
    CGFloat deviceWidth = [[UIScreen mainScreen] bounds].size.width;
    CollapsableHeaderView *headerView =[[CollapsableHeaderView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 45)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;

}
-(void) dismissSelf: (UIButton *) sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

    
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
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("%d", indexPath.row);
    UITableViewCell *cell;
    cell = [self.ballTableView dequeueReusableCellWithIdentifier:@"commentTableViewCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture:)];
    [cell addGestureRecognizer:tap];
    CommentTableViewCell *comment = (CommentTableViewCell *) cell;
    [tableViewCellReferences setObject:comment forKey:[NSNumber numberWithInt:indexPath.row]];

    if (indexPath.row % 3 == 1) {
        comment.textView.text = @"11111111111111111111111111 11111111111111111111111111 11111111111111111111111111";
    } else {
        comment.textView.text = @"0000000000  ";
    }
    if (indexPath.row == value - 1)
    {
        
        [self loadMore:nil];
    }
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell  *cell = [tableViewCellReferences objectForKey:[NSNumber numberWithInt:indexPath.row]];
    tableViewCellReferences;
    if (cell)
    {
        
    }
    if (!cell) return 5;
    return cell.textView.contentSize.height + 10;

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
    ToolbarSingleton *toolbBarManager = [ToolbarSingleton sharedManager];
    [toolbBarManager changeDoneButtonTitle:@"Post"];
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
    NSString *content = textView.text;
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
@end
