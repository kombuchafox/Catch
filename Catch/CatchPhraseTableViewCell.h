//
//  CatchPhraseTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/24/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolbarSingleton.h"
#import "PaperBallTableViewCell.h"
@protocol CatchPhaseTableViewCellDelegate
@property UIView *view;
@property BOOL didPinchPaper;
@property BOOL checkKeyBoardHeight;
@required
-(void)updateText:(NSString *) newText;
-(void) collapsePaper;
-(void) presentPhotoAlbum: (UIButton*) sender;
-(BOOL) shouldUploadThread:(UIImage *) image withText:(NSString *)text;
-(void) postThread;
@required
-(void)updateBallColor:(CGFloat) value;
@required
-(void)setAllViewToZeroAlpha;
@optional
-(void) goToOpenPaper: (UITapGestureRecognizer *) sender;
@end

@interface CatchPhraseTableViewCell : PaperBallTableViewCell <UITextViewDelegate, ToolbarSingletonDelegate, UICollisionBehaviorDelegate>
@property UITextView *textView;
@property UIImageView *memeView;
@property UIImage *memeImage;
@property NSString *defaultString;
@property id<CatchPhaseTableViewCellDelegate> delegate;
@property UILabel *pinchLabel;
- (IBAction)addPicture:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *ballGraphic;
@property (strong, nonatomic) IBOutlet UIButton *addPictureButton;
@end
