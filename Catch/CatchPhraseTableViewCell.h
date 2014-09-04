//
//  CatchPhraseTableViewCell.h
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/24/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CatchPhaseTableViewCellDelegate
@property UIView *view;
@property BOOL didPinchPaper;
@required
-(void)updateText:(NSString *) newText;
-(void) collapsePaper;
-(void) presentPhotoAlbum: (UIButton*) sender;
@required
-(void)updateBallColor:(CGFloat) value;
@required
-(void)setAllViewToZeroAlpha;
@end

@interface CatchPhraseTableViewCell : UITableViewCell <UITextViewDelegate>
@property UITextView *textView;
@property UIImageView *memeView;
@property UIImage *memeImage;
@property NSString *defaultString;
@property id<CatchPhaseTableViewCellDelegate> delegate;
@property UILabel *pinchLabel;
- (IBAction)addPicture:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *ballGraphic;
@property (strong, nonatomic) IBOutlet UIButton *addPictureButton;
-(void) toggleContents;
@end
