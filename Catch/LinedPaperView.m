//
//  LinedPaperView.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 9/22/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "LinedPaperView.h"
#define DEFAULT_HORIZONTAL_COLOR    [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f]
#define DEFAULT_VERTICAL_COLOR      [UIColor colorWithRed:0.957f green:0.416f blue:0.365f alpha:0.7f]
#define DEFAULT_MARGINS             UIEdgeInsetsMake(5.0f, 10.0f, 0.0f, -10.0f)
#define kMaxFieldHeight 9999
@interface LinedPaperView()
{
    CGFloat defaultLineHeight;
}
@end
@implementation LinedPaperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 
    defaultLineHeight = 40;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    self.horizontalLineColor = DEFAULT_HORIZONTAL_COLOR;
    self.verticalLineColor  = DEFAULT_VERTICAL_COLOR;

    if (self.horizontalLineColor)
    {
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, self.horizontalLineColor.CGColor);

    // Create un-mutated floats outside of the for loop.
    // Reduces memory access.
    CGFloat baseOffset = 8 + 25;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat boundsX = self.bounds.origin.x;
    CGFloat boundsWidth = self.bounds.size.width;

    // Only draw lines that are visible on the screen.
    // (As opposed to throughout the entire view's contents)
    NSInteger firstVisibleLine = MAX(1, (self.bounds.origin.y / defaultLineHeight));
    NSInteger lastVisibleLine = ceilf((self.bounds.origin.y + self.bounds.size.height) / defaultLineHeight);
    for (NSInteger line = firstVisibleLine; line <= lastVisibleLine; ++line)
    {
    CGFloat linePointY = (baseOffset + (defaultLineHeight * line));
    // Rounding the point to the nearest pixel.
    // Greatly reduces drawing time.
    CGFloat roundedLinePointY = roundf(linePointY * screenScale) / screenScale;
    CGContextMoveToPoint(context, boundsX, roundedLinePointY);
    CGContextAddLineToPoint(context, boundsWidth, roundedLinePointY);
    }
    CGContextClosePath(context);
    CGContextStrokePath(context);
    }

    if (self.verticalLineColor)
    {
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, self.verticalLineColor.CGColor);
    CGContextMoveToPoint(context, 10.0f, self.bounds.origin.y);
    CGContextAddLineToPoint(context, 10.0f, self.bounds.origin.y+ self.bounds.size.height);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    }


    // release the path

    self.layer.cornerRadius = 5;
    // self.layer.borderColor = [[Utils UIColorFromRGB:0xDCE8E0] CGColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.4;
 
}


@end
