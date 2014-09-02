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
#import <UIKit/UIKit.h>

#define kDefaultNumberOfSpinnerMarkers 12
#define kDefaultSpread 35.0
#define kDefaultColor ([Utils UIColorFromRGB:0xE8240C])
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


#define kMarkerAnimationKey @"MarkerAnimationKey"
@interface CatchPhraseTableViewCell()
{
    UITextView *topTextView;
    UITextView *bottomTextView;
    UIView *layer;
    BOOL toggleTextBoxes;
    UISwipeGestureRecognizer *send;
    UITapGestureRecognizer *ballTap;
    UIDynamicAnimator *animator;
    CGFloat boundary;
    int fontSize;
    CGFloat contentOffset;
    UIImageView *imageView;
}
@end
@implementation CatchPhraseTableViewCell

@synthesize defaultString, memeView,memeImage;

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
    
    
//    self.textView = [[UITextView alloc] initWithFrame:self.contentView.frame];
//    self.textView.font = [UIFont systemFontOfSize:30];
//    self.textView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.contentView addSubview:self.textView];
//    
//    NSDictionary* views = @{@"textView": self.textView};
//    NSArray* vContrains=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
//    NSArray* hContrains=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[textView]-0-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
//    [self.contentView addConstraints:vContrains];
//    [self.contentView addConstraints:hContrains];
     contentOffset =self.textView.contentOffset.y;
    [self.addPictureButton setFrame:CGRectMake(self.frame.size.width - [self getOffset].width, self.frame.size.height + [self getOffset].height,CGRectGetWidth(self.addPictureButton.frame), CGRectGetHeight(self.addPictureButton.frame))];
    [self.addPictureButton removeFromSuperview];
    [self.contentView addSubview:self.addPictureButton];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    boundary = self.ballGraphic.frame.size.height + self.ballGraphic.frame.origin.y * 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renderTextView:)];
    [self.contentView addGestureRecognizer:tap];
    self.textView.delegate = self;
    self.defaultString = @"Say something playful 👾👅";
    //self.memeView = [[UIImageView alloc] initWithFrame:self.textView.frame];
    layer = [[UIView alloc] initWithFrame:self.textView.frame];
    layer.alpha = 1;
    [self.contentView addSubview:self.memeView ];
    [layer addSubview:topTextView];
    [layer addSubview:bottomTextView];
    self.memeView.hidden = YES;
    
    self.ballGraphic.userInteractionEnabled = YES;
    send = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sendBall:)];
    send.direction = UISwipeGestureRecognizerDirectionUp;
    [self.ballGraphic addGestureRecognizer:send];
    ballTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounceBall:)];
    [self.ballGraphic addGestureRecognizer:ballTap];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.delegate.view];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.contentView addGestureRecognizer:pinchGesture];
    //[self.textView addGestureRecognizer:pinchGesture];
    NSAttributedString *text = [NSAttributedString new];
    

    
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
-(void) bounceBall: (UITapGestureRecognizer *) sender
{
    //[self.ballGraphic removeFromSuperview];
    [self.contentView addSubview:self.ballGraphic];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.ballGraphic.frame = CGRectMake(self.ballGraphic.frame.origin.x, self.ballGraphic.frame.origin.y - 60, self.ballGraphic.frame.size.width, self.ballGraphic.frame.size.height);
    } completion:^(BOOL completed){
        [self setUpBallAnimation:0];
        
    }];
}
-(void) setUpBallAnimation: (int) tap
{
    [animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ballGraphic]];
    [animator addBehavior:gravityBehavior];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ballGraphic]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"floor"
                                       fromPoint:CGPointMake([UIScreen mainScreen].bounds.origin.x, boundary)
                                         toPoint:CGPointMake([UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width,boundary)];
    [animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballGraphic]];
    ballBehavior.elasticity = 0.4;
    ballBehavior.resistance = 0.0;
    ballBehavior.friction = 0.0;
    [animator addBehavior:ballBehavior];
}

-(void) handlePinch: (UIPinchGestureRecognizer *) sender
{
    CGFloat scale = sender.scale;
    
    if (sender.scale < 1){
        self.textView.hidden = YES;
        self.ballGraphic.hidden = NO;
    }
    else {
        self.ballGraphic.hidden = YES;
        self.textView.hidden = NO;
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
             CGPoint point = CGPointMake(self.ballGraphic.frame.origin.x, -810);
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

-(void) toggleContents
{

    
}

- (IBAction)addPicture:(UIButton *)sender
{
    [self.delegate presentPhotoAlbum:sender];
}
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:defaultString]) textView.text = @"";
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height- 150);
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *content = textView.text;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize]
                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame))
                          lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.delegate updateText:textView.text];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"" ]){
        textView.text = defaultString;
    }

    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height+150);
   // LinedTextView *linedTextView = (LinedTextView *)self.textView;

}
+ (void)selectTextForInput:(UITextView *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}
- (void)keyboardWillShow:(NSNotification *)note {
    // create custom button
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [self.textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
#pragma mark UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p{
    
    
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id)item withBoundaryIdentifier:(id)identifier{

    
}

#pragma mark UISrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{


    
    
    // do whatever you need to with scrollDirection here.
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (contentOffset < scrollView.contentOffset.y)
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, @"\n\n\n"];
    
    contentOffset = scrollView.contentOffset.y;
}

@end
