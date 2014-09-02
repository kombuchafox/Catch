//
//  ColorBarPicker.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/12/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "ColorBarPicker.h"
#import "HSBSupport.h"
#define kContentInsetX 10
@implementation ColorBarPicker

//------------------------------------------------------------------------------

static CGImageRef createContentImage()
{
	float hsv[] = { 0.0f, 1.0f, 1.0f };
	return createHSVBarContentImage(InfComponentIndexHue, hsv);
}

//------------------------------------------------------------------------------

- (void) drawRect: (CGRect) rect
{
	CGImageRef image = createContentImage();
	
	if (image) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextDrawImage(context, [self bounds], image);
		
		CGImageRelease(image);
	}
}

//------------------------------------------------------------------------------

@end

//==============================================================================

@implementation InfColorBarPicker {
	
}

////------------------------------------------------------------------------------
#pragma mark	Drawing
//------------------------------------------------------------------------------

//- (void) layoutSubviews
//{
//}
//
////------------------------------------------------------------------------------
//#pragma mark	Properties
////------------------------------------------------------------------------------
//
- (void) setValue: (float) newValue
{
	if (newValue != _value) {
		_value = newValue;
		
		[self sendActionsForControlEvents: UIControlEventValueChanged];
		[self setNeedsLayout];
	}
}
//
////------------------------------------------------------------------------------
//#pragma mark	Tracking
////------------------------------------------------------------------------------
//
- (void) trackIndicatorWithTouch: (UITouch*) touch
{
    NSLog(@"here");
	float percent = 1 - ([touch locationInView: self].y - kContentInsetX)
    / (self.bounds.size.height - 2 * kContentInsetX);
	
	self.value = pin(0.0f, percent, 1.0f);
}
//
////------------------------------------------------------------------------------
//
- (BOOL) beginTrackingWithTouch: (UITouch*) touch
                      withEvent: (UIEvent*) event
{
	[self trackIndicatorWithTouch: touch];
	
	return YES;
}

//------------------------------------------------------------------------------

- (BOOL) continueTrackingWithTouch: (UITouch*) touch
                         withEvent: (UIEvent*) event
{
	[self trackIndicatorWithTouch: touch];
	
	return YES;
}

//------------------------------------------------------------------------------
#pragma mark	Accessibility
//------------------------------------------------------------------------------

- (UIAccessibilityTraits) accessibilityTraits
{
	UIAccessibilityTraits t = super.accessibilityTraits;
	
	t |= UIAccessibilityTraitAdjustable;
	
	return t;
}

//------------------------------------------------------------------------------

- (void) accessibilityIncrement
{
	float newValue = self.value + 0.05;
	
	if (newValue > 1.0)
		newValue -= 1.0;
    
	self.value = newValue;
}

//------------------------------------------------------------------------------

- (void) accessibilityDecrement
{
	float newValue = self.value - 0.05;
	
	if (newValue < 0)
		newValue += 1.0;
	
	self.value = newValue;
}

//------------------------------------------------------------------------------

- (NSString*) accessibilityValue
{
	return [NSString stringWithFormat: @"%d degrees hue", (int) (self.value * 360.0)];
}
//
////------------------------------------------------------------------------------

@end

//==============================================================================
