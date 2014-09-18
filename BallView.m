//
//  BallView.m
//  Catch - Share Happy
//
//  Created by Ian Fox on 8/12/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//

#import "BallView.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
@interface BallView()
{
    CAEmitterLayer *lineEmitter;
    UIView *separator;
}

@end
@implementation BallView
@synthesize circleLayer;


-(void) setupEmitter
{
//    lineEmitter = (CAEmitterLayer*)self.layer; //2
//    //configure the emitter layer
//    lineEmitter.emitterPosition = CGPointMake(0, 0);
//    lineEmitter.emitterSize = CGSizeMake(0, 0);
//    
//    CAEmitterCell* fire = [CAEmitterCell emitterCell];
//    fire.birthRate = 0;
//    fire.lifetime = .3;
//    fire.lifetimeRange = 0.5;
//    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
//    fire.contents = (id)[[UIImage imageNamed:@"line.png"] CGImage];
//    [fire setName:@"line"];
//    
//    fire.velocity = 10;
//    fire.velocityRange = 20;
//    fire.emissionRange = M_PI;
//    
//    fire.scaleSpeed = 0.3;
//    fire.spin = 0.5;
//    
//    lineEmitter.renderMode = kCAEmitterLayerAdditive;
//    
//    //add the cell to the layer and we're done
//    lineEmitter.emitterCells = [NSArray arrayWithObject:fire];
//    [lineEmitter setValue:[NSNumber numberWithInt:100] forKeyPath:@"emitterCells.line.birthRate"];
}
+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}
- (void) drawCircle:(UIColor *)color
{

    self.color = color;
    
    self.circleLayer = [CAShapeLayer layer];
    [self.circleLayer setBounds:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]))];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [self.circleLayer setPath:[path CGPath]];
    
    [self.circleLayer setStrokeColor:[color CGColor]];
    
    [self.circleLayer setLineWidth:2.0f];
    [self.circleLayer setFillColor:self.color.CGColor];
    [self.layer addSublayer:self.circleLayer];
    //[self.layer insertSublayer:self.circleLayer atIndex:0];
}
-(void) drawSeparator
{
    [separator removeFromSuperview];
    separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 0.7)];
    separator.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:separator];
}

-(void) updateColor: (UIColor*) color
{
    self.color = color;
    [self.circleLayer setFillColor:self.color.CGColor];
    [self.circleLayer setStrokeColor: self.color.CGColor];
}
@end
