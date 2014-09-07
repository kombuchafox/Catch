//
//  LinedTextView.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/29/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "LinedTextView.h"
#import "Utils.h"
#define DEFAULT_HORIZONTAL_COLOR    [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f]
#define DEFAULT_VERTICAL_COLOR      [UIColor colorWithRed:0.957f green:0.416f blue:0.365f alpha:0.7f]
#define DEFAULT_MARGINS             UIEdgeInsetsMake(5.0f, 10.0f, 0.0f, -10.0f)
#define kMaxFieldHeight 9999

@interface LinedTextView (){
    int hasBeenInstatiated;
}

@property (nonatomic, assign) UIView *webDocumentView;

@end
@implementation LinedTextView

+ (void)initialize
{
    if (self == [LinedTextView class])
    {
        id appearance = [self appearance];
        [appearance setContentMode:UIViewContentModeRedraw];
        [appearance setHorizontalLineColor:DEFAULT_HORIZONTAL_COLOR];
        [appearance setVerticalLineColor:DEFAULT_VERTICAL_COLOR];
        [appearance setMargins:DEFAULT_MARGINS];
    }
}
- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width);
    self = [super initWithFrame:frame];
    if (self)
    {

        // Recycling the font is necessary
        // For proper line/text alignment
        UIFont *font = self.font;
        self.font = nil;
        self.font = font;
        // iOS 7 container text view is UITextContainerView
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITextContainerView"]) {
                self.webDocumentView = subview;
            }
        }

        self.margins = [self.class.appearance margins];
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    contentSize = (CGSize) {
        .width = contentSize.width - self.margins.left - self.margins.right,
        .height = MAX(contentSize.height, self.bounds.size.height - self.margins.top)
    };
    self.webDocumentView.frame = (CGRect) {
        .origin = self.webDocumentView.frame.origin,
        .size = contentSize
    };
    [super setContentSize:contentSize];
}
-(BOOL)sizeFontToFit:(NSString*)aString minSize:(float)aMinFontSize maxSize:(float)aMaxFontSize
{
//    float fudgeFactor = 16.0;
//    float fontSize = aMaxFontSize;
//    
//    self.font = [self.font fontWithSize:fontSize];
//    
//    CGSize tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
//    CGSize stringSize = [aString sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
//    
//    while (stringSize.height >= self.frame.size.height - 50)
//    {
//        if (fontSize <= aMinFontSize) // it just won't fit
//            return NO;
//        
//        fontSize -= 1.0;
//        self.font = [self.font fontWithSize:fontSize];
//        tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
//        stringSize = [aString sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
//    }
    
    return YES; 
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    
    if (self.horizontalLineColor)
    {
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, self.horizontalLineColor.CGColor);
        
        // Create un-mutated floats outside of the for loop.
        // Reduces memory access.
        CGFloat baseOffset = 8 + self.font.descender;
        CGFloat screenScale = [UIScreen mainScreen].scale;
        CGFloat boundsX = self.bounds.origin.x;
        CGFloat boundsWidth = self.bounds.size.width;
        
        // Only draw lines that are visible on the screen.
        // (As opposed to throughout the entire view's contents)
        NSInteger firstVisibleLine = MAX(1, (self.contentOffset.y / self.font.lineHeight));
        NSInteger lastVisibleLine = ceilf((self.contentOffset.y + self.bounds.size.height) / self.font.lineHeight);
        for (NSInteger line = firstVisibleLine; line <= lastVisibleLine; ++line)
        {
            CGFloat linePointY = (baseOffset + (self.font.lineHeight * line));
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
        CGContextMoveToPoint(context, -1.0f, self.contentOffset.y);
        CGContextAddLineToPoint(context, -1.0f, self.contentOffset.y + self.bounds.size.height);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }

        [self reDrawBorders];

    
    // release the path
    
    self.layer.cornerRadius = 7;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.5;
}
CGMutablePathRef createRoundedCornerPath(CGRect rect, CGFloat cornerRadius) {
    
    // create a mutable path
    CGMutablePathRef path = CGPathCreateMutable();
    
    // get the 4 corners of the rect
    CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGPoint bottomLeft = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    
    // move to top left
    CGPathMoveToPoint(path, NULL, topLeft.x + cornerRadius, topLeft.y);
    
    // add top line
    CGPathAddLineToPoint(path, NULL, topRight.x - cornerRadius, topRight.y);
    
    // add top right curve
    CGPathAddQuadCurveToPoint(path, NULL, topRight.x, topRight.y, topRight.x, topRight.y + cornerRadius);
    
    // add right line
    CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y - cornerRadius);
    
    // add bottom right curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomRight.x - cornerRadius, bottomRight.y);
    
    // add bottom line
    CGPathAddLineToPoint(path, NULL, bottomLeft.x + cornerRadius, bottomLeft.y);
    
    // add bottom left curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y, bottomLeft.x, bottomLeft.y - cornerRadius);
    
    // add left line
    CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y + cornerRadius);
    
    // add top left curve
    CGPathAddQuadCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x + cornerRadius, topLeft.y);
    
    // return the path
    return path;
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

-(void) reDrawBorders {
    CGContextRef context = UIGraphicsGetCurrentContext();
    const CGFloat outlineStrokeWidth = 1;
    const CGFloat outlineCornerRadius = 7.0f;
    
    const CGColorRef redColor = [[Utils UIColorFromRGB:0xDCE8E0] CGColor];
    
    
    // inset the rect because half of the stroke applied to this path will be on the outside
    CGRect insetRect = CGRectInset(CGRectMake(-10, -5, self.frame.size.width, self.contentSize.height + 5), outlineStrokeWidth/2.0f, outlineStrokeWidth/2.0f);
    
    // get our rounded rect as a path
    CGMutablePathRef path = createRoundedCornerPath(insetRect, outlineCornerRadius);
    
    // add the path to the context
    CGContextAddPath(context, path);
    
    // set the stroke params
    CGContextSetStrokeColorWithColor(context, redColor);
    CGContextSetLineWidth(context, outlineStrokeWidth);
    
    // draw the path
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    hasBeenInstatiated = 1;
}
#pragma mark - Property methods

- (void)setHorizontalLineColor:(UIColor *)horizontalLineColor
{
    _horizontalLineColor = horizontalLineColor;
    [self setNeedsDisplay];
}

- (void)setVerticalLineColor:(UIColor *)verticalLineColor
{
    _verticalLineColor = verticalLineColor;
    [self setNeedsDisplay];
}

- (void)setMargins:(UIEdgeInsets)margins
{
    _margins = margins;
    self.contentInset = (UIEdgeInsets) {
        .top = self.margins.top,
        .left = self.margins.left ,
        .bottom = self.margins.bottom,
        .right = self.margins.right
    };
    [self setContentSize:self.contentSize];
}


@end
