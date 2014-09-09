//
//  CommentTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/1/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "CommentTableViewCell.h"
#define MAX_HEIGHT 150

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.attachedImage.hidden = NO;
    }
    return self;
}

-(void) setUp
{


 
    self.attachedImage.layer.cornerRadius = 5;
    self.attachedImage.layer.masksToBounds = YES;
    self.attachedImage.layer.borderWidth = 2;
    self.attachedImage.layer.borderColor = [UIColor clearColor].CGColor;
   // if (arc4random() % 2 == 0) {
        self.attachedImage.hidden = YES;
    self.attachedImage = nil;
//        if (arc4random() % 2 == 0)
//        {
//            if (arc4random() % 2 == 0) {
//                self.attachedImage.image = [UIImage imageNamed:@"tumblr_mnxid4jaQc1rf2f7ho1_400.png"];
//            } else {
//                self.attachedImage.image = [UIImage imageNamed:@"photo-6-768x1024.jpg"];
//            }
//            [self.attachedImage setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, self.textView.frame.size.height/2, self.attachedImage.frame.size.width, self.attachedImage.frame.size.height)];
//            UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, self.textView.frame.size.height/2, [UIScreen mainScreen].bounds.size.width, self.attachedImage.frame.size.height)];
//            self.textView.textContainer.exclusionPaths = @[exclusionPath];
//            [self.attachedImage removeFromSuperview];
//            [self.textView addSubview:self.attachedImage];
//        } else {
//            self.attachedImage = nil;
//        }

    
    //}
}

- (void)awakeFromNib
{
    // Initialization code
    [self setUp];
    self.attachedImage.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    // Configure the view for the selected state
}

@end
