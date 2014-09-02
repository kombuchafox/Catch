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
    self.textView.text = @"lromm urmfk omkji gjkhfk kjglkdfj mkl; lorum lmdol mjlolj jkldoomkglk lsjdkjlooe row,llmfdlk gfjglkdfsoro kdfjlgdkj";
   // if (arc4random() % 2 == 0) {
        self.attachedImage.hidden = NO;
        if (arc4random() % 2 == 0)
        {
            if (arc4random() % 2 == 0) {
                self.attachedImage.image = [UIImage imageNamed:@"tumblr_mnxid4jaQc1rf2f7ho1_400.png"];
            } else {
                self.attachedImage.image = [UIImage imageNamed:@"photo-6-768x1024.jpg"];
            }
            [self.attachedImage setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, self.frame.origin.y + 10, self.attachedImage.frame.size.width, self.attachedImage.frame.size.height)];
            UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect: CGRectMake(self.attachedImage.frame.origin.x, self.attachedImage.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.attachedImage.frame.size.height)];
            self.textView.textContainer.exclusionPaths = @[exclusionPath];
            [self.attachedImage removeFromSuperview];
            [self.textView addSubview:self.attachedImage];
        }

    
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
