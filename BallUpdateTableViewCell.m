//
//  BallUpdateTableViewCell.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/28/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "BallUpdateTableViewCell.h"
#import "Utils.h"

@implementation BallUpdateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}
-(void) drawSeparator
{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 10, self.contentView.frame.size.width, 1.2)];
    separator.backgroundColor = [Utils UIColorFromRGB:0xFFFFFF];
    [self.contentView addSubview:separator];
}
-(void) setUp
{

    self.ballStoryScrollView.delegate = self;
    self.ballStoryScrollView.scrollEnabled = YES;
    self.ballStoryScrollView.contentSize = CGSizeMake(500, 150);
    [self drawSeparator];

}
- (void)awakeFromNib
{
    // Initialization code
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did end decelerating");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"Did scroll");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    NSLog(@"Did end dragging");
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Did begin decelerating");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Did begin dragging");
}

@end
