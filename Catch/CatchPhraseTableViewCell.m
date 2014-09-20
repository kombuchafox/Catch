//
//  CatchPhraseTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/24/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "CatchPhraseTableViewCell.h"
#import "Utils.h"
#import "LinedTextView.h"
#import "ToolbarSingleton.h"
#import <UIKit/UIKit.h>

#define kDefaultNumberOfSpinnerMarkers 12
#define kDefaultSpread 35.0
#define kDefaultColor ([Utils UIColorFromRGB:0xFFFFFF])
#define kDefaultThickness 8.0
#define kDefaultLength 25.0
#define kDefaultSpeed 1.0
#define kAddPictureXOffset 75
#define kAddPictureYOffset 45
#define kAddPictureYOffset4 -30
// HUD defaults
#define kDefaultHUDSide 160.0
#define kDefaultHUDColor ([UIColor colorWithWhite:0.0 alpha:0.3])
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kMarkerAnimationKey @"MarkerAnimationKey"
@interface CatchPhraseTableViewCell()
{
    UITextView *topTextView;
    UITextView *bottomTextView;
    UIView *layer;
    BOOL toggleTextBoxes;
    int fontSize;
    CGFloat contentOffset;
    UIImageView *imageView;
    UILabel *characterCount;
    UIToolbar *_inputAccessoryView;
    UIButton *doneButton;
    BOOL didPinch;
}
@end
@implementation CatchPhraseTableViewCell

@synthesize defaultString, memeView,memeImage, pinchLabel;
@synthesize animator, boundary, send, ballTap;

-(void) setMemeImage:(UIImage *)newValue
{
    if (imageView) {
        [imageView removeFromSuperview];
    }
    memeImage = newValue;
   imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.center.x/2, self.textView.center.y/2, 100, 120)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:pan];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.textView.center.x/2, self.textView.center.y/2, [UIScreen mainScreen].bounds.size.width, 70)];
    
    self.textView.textContainer.exclusionPaths  = @[exclusionPath];
    
    [self.textView addSubview:imageView];
    imageView.image = newValue;
    [self.textView addSubview: imageView];
    
    
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.textView];
    UIBezierPath *exclusionPath;
    CGFloat newY, newX;
//    if (recognizer.view.center.y + translation.y > 100) {
        newY = recognizer.view.center.y + translation.y;
//    } else {
//        newY = 110;
//    }
//    if (recognizer.view.center.x + translation.x > 25) {
        newX = recognizer.view.center.x + translation.x;
//    } else {
//        newX = 75;
//    }

    recognizer.view.center = CGPointMake(newX, newY);
    exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, newY - 25, self.textView.frame.size.width, 70)];

    self.textView.textContainer.exclusionPaths = @[exclusionPath];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.textView];
    
}
-(UIImage *) memeImage
{
    return self.memeImage;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}
-(void) setUp
{
    [super setUp];
    pinchLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x , 0, self.textView.frame.size.width, 13)];
    pinchLabel.text = @"Pinch to post";
    pinchLabel.font = [UIFont systemFontOfSize:13];
    pinchLabel.textAlignment = NSTextAlignmentCenter;

     contentOffset =self.textView.contentOffset.y;
    [self.addPictureButton removeFromSuperview];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    boundary = self.ballGraphic.frame.size.height + self.ballGraphic.frame.origin.y * 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renderTextView:)];
    [self.contentView addGestureRecognizer:tap];
    self.textView.delegate = self;
    self.defaultString = @"Say something playful 👾👅";

    
    layer = [[UIView alloc] initWithFrame:self.textView.frame];
    layer.alpha = 1;
    [self.contentView addSubview:self.memeView ];
    [layer addSubview:topTextView];
    [layer addSubview:bottomTextView];
    self.memeView.hidden = YES;
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.delegate.view];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.contentView addGestureRecognizer:pinchGesture];
    //[self.textView addGestureRecognizer:pinchGesture];
        [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, 15, self.textView.frame.size.width, self.textView.frame.size.height)];
            [self.contentView addSubview:pinchLabel];
        } completion:^(BOOL completed){
        }];

    self.textView.clipsToBounds = YES;

    

    
}

- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:_inputAccessoryView];

    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        
        if (CGRectContainsPoint(CGRectMake(doneButton.frame.origin.x - 20, doneButton.frame.origin.y - 40, doneButton.frame.size.width + 20, doneButton.frame.size.height + 100), point))
        {
            NSLog(@"lol");
            [self doneButton];
        }
        if (CGRectContainsPoint(CGRectMake(self.addPictureButton.frame.origin.x - 20, self.addPictureButton.frame.origin.y, self.addPictureButton.frame.size.width + 20, self.addPictureButton.frame.size.height + 100), point))
        {
            NSLog(@"lol");
            [self addPicture: nil];
        }
    }
}
-(CGSize) getOffset
{
    if (IS_IPHONE_5)
    {
        return CGSizeMake(kAddPictureXOffset, kAddPictureYOffset);
    } else {
        return CGSizeMake(kAddPictureXOffset, -20);
    }
}



-(void) handlePinch: (UIPinchGestureRecognizer *) sender
{
    [self.delegate collapsePaper];
    didPinch = YES;
    if (sender.scale < 1){
        [self.delegate collapsePaper];
        didPinch = YES;
    }
    else {
        didPinch = NO;
    }
    
}
-(void) sendBall:(UISwipeGestureRecognizer *) sender
{
    
    
    [self.ballGraphic removeFromSuperview];
    [self.delegate.view addSubview: self.ballGraphic];
    //[self.delegate.view addSubview:self.ballGraphic];
    // [self setUpBallAnimation:0];
    
    //[self.delegate setAllViewToZeroAlpha];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self.delegate setAllViewToZeroAlpha];
    } completion:^(BOOL completed){
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            //[self.delegate setAllViewToZeroAlpha]
            self.ballGraphic.frame = CGRectMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y - [UIScreen mainScreen].bounds.size.height * 2, self.ballGraphic.frame.size.width, self.ballGraphic.frame.size.height);
            self.backgroundView = nil;
            } completion:
         ^(BOOL completed) {

             CGPoint actual = CGPointMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y);
             if (actual.y > 0) {
                 [UIView animateWithDuration:0.5 animations:^{
                     self.ballGraphic.frame = CGRectMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y - [UIScreen mainScreen].bounds.size.height * 2, self.ballGraphic.frame.size.width, self.ballGraphic.frame.size.height);
                 }];
             }
             self.delegate.view.userInteractionEnabled = NO;
             CALayer * marker = [CALayer layer];
             [marker setBounds:CGRectMake(0, 0, kDefaultThickness, kDefaultLength)];
             [marker setCornerRadius:kDefaultThickness*0.5];
             [marker setBackgroundColor:[kDefaultColor CGColor]];
             [marker setPosition:CGPointMake(kDefaultHUDSide*0.5, kDefaultHUDSide*0.5+kDefaultSpread)];
             CAReplicatorLayer * spinnerReplicator = [CAReplicatorLayer layer];
             [spinnerReplicator setBounds:CGRectMake(0, 0, kDefaultHUDSide, kDefaultHUDSide)];
             [spinnerReplicator setCornerRadius:10.0];
             [spinnerReplicator setBackgroundColor:[kDefaultHUDColor CGColor]];
             [spinnerReplicator setPosition:CGPointMake(CGRectGetMidX([self.delegate.view frame]),
                                                        CGRectGetMidY([self.delegate.view frame]))];
             CGFloat angle = (2*M_PI)/(kDefaultNumberOfSpinnerMarkers);
             CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
             [spinnerReplicator setInstanceCount:kDefaultNumberOfSpinnerMarkers];
             [spinnerReplicator setInstanceTransform:instanceRotation];
             [spinnerReplicator addSublayer:marker];
             [[self.delegate.view layer] addSublayer:spinnerReplicator];
             
             [marker setOpacity:0.0];
             CABasicAnimation * fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
             [fade setFromValue:[NSNumber numberWithFloat:1.0]];
             [fade setToValue:[NSNumber numberWithFloat:0.0]];
             [fade setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
             [fade setRepeatCount:HUGE_VALF];
             [fade setDuration:kDefaultSpeed];
             CGFloat markerAnimationDuration = kDefaultSpeed/kDefaultNumberOfSpinnerMarkers;
             [spinnerReplicator setInstanceDelay:markerAnimationDuration];
             [marker addAnimation:fade forKey:kMarkerAnimationKey];
         }];
    }];
}
-(void) renderTextView: (UITapGestureRecognizer *)sender
{
    if (self.ballGraphic.hidden)
    {
        CGPoint location = [sender locationInView:self.textView];
        UITextPosition * start=[self.textView closestPositionToPoint:location];
        UITextPosition *end = [self.textView positionFromPosition:start
                                                   offset:0];
        [self.textView becomeFirstResponder];
        [self.textView setSelectedTextRange:[self.textView textRangeFromPosition:start toPosition:end]];
    } else {

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addPicture:(UIButton *)sender
{
    [_inputAccessoryView removeFromSuperview];
    [self.delegate presentPhotoAlbum:sender];
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
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, 0, self.textView.frame.size.width, self.textView.frame.size.height)];
        [self.pinchLabel setFrame:CGRectMake(pinchLabel.frame.origin.x, -10, pinchLabel.frame.size.width, pinchLabel.frame.size.height)];
        self.pinchLabel.alpha = 0.2;
    } completion:^(BOOL completed){
        [self.pinchLabel removeFromSuperview];

        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height - 200);
    }];
    
    ToolbarSingleton *toolbBarManager = [ToolbarSingleton sharedManager];
    toolbBarManager.delegate = self;
    CGRect frame = toolbBarManager.keyboardToolbar.frame;
    if (self.delegate.checkKeyBoardHeight)
    {
        frame.origin = CGPointMake(0, 253);
    } else {
        frame.origin = CGPointMake(0, 317);
    }
    toolbBarManager.keyboardToolbar.frame = frame;
    CGRect delegateFrame = self.delegate.view.frame;
    delegateFrame.size = [UIScreen mainScreen].bounds.size;
    [self.delegate.view setFrame: delegateFrame];
    [self.delegate.view addSubview:toolbBarManager.keyboardToolbar];
    self.textView = textView;



}

-(void)createInputAccessoryView: (UITextView *) textView {

   // }
}
- (void)textViewDidChange:(UITextView *)textView
{

//    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize]
//                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame))
//                          lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.delegate updateText:textView.text];
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
+ (void)selectTextForInput:(UITextView *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}
-(void)doneButton
{
    [_inputAccessoryView removeFromSuperview];
    ToolbarSingleton *toolbBarManager = [ToolbarSingleton sharedManager];
    [toolbBarManager.keyboardToolbar removeFromSuperview];
    [self.textView endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    return YES;
}
#pragma mark UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p{
    
    
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id)item withBoundaryIdentifier:(id)identifier{

    
}

#pragma mark UISrollViewDelegate


@end
