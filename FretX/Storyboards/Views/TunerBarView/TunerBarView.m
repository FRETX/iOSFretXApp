//
//  TunerBarView.m
//  FretX
//
//  Created by Onur Babacan on 24/07/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "TunerBarView.h"
#import <UIKit/UIKit.h>
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <math.h>

@implementation TunerBarView

-(void) myInit {
    self.TUNING_THRESHOLD_CENTS = 6;
    self.ACCELERATION = 7;
    self.prevTime = nil;
    self.currentPitch = -1;
    self.barMarginVertical = 3;
}

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self){[self myInit];}
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){[self myInit];}
    return self;
}

-(void) setPitch:(float) pitch{
    self.currentPitch = pitch;
    [self setNeedsDisplay];
}

-(void) setTargetPitch:(float)targetPitch leftPitch:(float)leftPitch rightPitch:(float)rightPitch{
    if(leftPitch >= rightPitch || targetPitch < leftPitch || targetPitch > rightPitch){
        NSLog(@"setTargetPitch failed");
        return;
    }
    self.leftmostPitch = leftPitch;
    self.rightmostPitch = rightPitch;
    self.centerPitch = targetPitch;
    NSLog(@"left: %f center: %f right: %f",_leftmostPitch,_centerPitch,_rightmostPitch);
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    NSLog(@"Drawing");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, true);
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat center = width / 2;
    CGFloat ratioHzPixel = width / (CGFloat) (_rightmostPitch - _leftmostPitch);
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    //Draw background
    CGContextClearRect(context, rect);
//    CGFloat components[] = {0.5, 0.5, 0.5, 1.0};
//    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, rect);
    //Draw the middle line
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 5.0);
    CGContextMoveToPoint(context, center, 0);
    CGContextAddLineToPoint(context, center, height);
    CGContextStrokePath(context);
    
    if(_prevTime == nil){
        _prevTime = [NSDate date];
        _currentPos = center;
        return;
    } else {
        NSDate *currentTime = [NSDate date];
        NSTimeInterval deltaTime = [currentTime timeIntervalSinceDate:_prevTime];
        _prevTime = currentTime;
        CGFloat targetPos;
        float currentPitchInCents = (float)[MusicUtils hzToCentWithHz:(double)_currentPitch];
        float centerPitchInCents = (float)[MusicUtils hzToCentWithHz:(double)_centerPitch];
        if(_currentPitch == -1){
            targetPos = center;
            if(_currentPos < center){
                CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
            } else {
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            }
        } else {
            targetPos = (CGFloat)(_currentPitch-_centerPitch)*ratioHzPixel + center;
            
            if(fabsf(currentPitchInCents-centerPitchInCents) < _TUNING_THRESHOLD_CENTS){
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            } else if (targetPos < center ){
                CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
            } else if (targetPos > center){
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            }
        }
        
        if(targetPos > width){
            targetPos = width;
        }
        if(targetPos < 0){
            targetPos = 0;
        }
        CGFloat deltaPos = targetPos - _currentPos;
        CGFloat velocity = _ACCELERATION * deltaPos;
        _currentPos += (CGFloat)(deltaTime) * velocity;
        
        if(_currentPos > width){
            _currentPos = width;
        }
        if(_currentPos < 0){
            _currentPos = 0;
        }
        
        CGRect animatedBar = CGRectMake(0, 0, 0, 0);
        if(_currentPos > center){
            animatedBar = CGRectMake(center, _barMarginVertical, _currentPos-center, height-2*_barMarginVertical);
        } else {
            animatedBar = CGRectMake(_currentPos, _barMarginVertical, center-_currentPos, height-2*_barMarginVertical);
        }
        CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 10);
        CGContextFillRect(context, animatedBar);
        if(_currentPitch != -1 && ((float)(fabsf(currentPitchInCents-centerPitchInCents)) < _TUNING_THRESHOLD_CENTS)){
            //show green tick
        }

    }
    
    
    
}


@end
