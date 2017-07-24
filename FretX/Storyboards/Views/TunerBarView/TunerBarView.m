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
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
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
        if(_currentPitch == -1){
            targetPos = center;
            if(_currentPos < center){
                CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
            } else {
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            }
        } else {
            targetPos = (CGFloat)(_currentPitch-_centerPitch)*ratioHzPixel + center;
            float currentPitchInCents = (float)[MusicUtils hzToCentWithHz:(double)_currentPitch];
            float centerPitchInCents = (float)[MusicUtils hzToCentWithHz:(double)_centerPitch];
            if(fabsf(currentPitchInCents-centerPitchInCents) < _TUNING_THRESHOLD_CENTS){
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            } else if (targetPos < center ){
                CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
            } else if (targetPos > center){
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            }
            
            if(targetPos > width){
                targetPos = width;
            }
            if(targetPos < 0){
                targetPos = 0;
            }
            
            CGFloat deltaPos = targetPos - _currentPos;
            CGFloat velocity = _ACCELERATION * deltaPos;
            _currentPos += (CGFloat)(deltaTime/1000) * velocity;
            
            if(_currentPos > width){
                _currentPos = width;
            }
            if(_currentPos < 0){
                _currentPos = 0;
            }
            
            if(_currentPos > center){
                CGRect animatedBar = CGRectMake(center, 0, _currentPos, height);
                CGContextFillRect(context, animatedBar);
            } else {
                CGRect animatedBar = CGRectMake(_currentPos, 0, center, height);
                CGContextFillRect(context, animatedBar);
            }

            if(_currentPitch != -1 && ((float)(fabsf(currentPitchInCents-centerPitchInCents)) < _TUNING_THRESHOLD_CENTS)){
                //show green tick
            }
            
        }
    }
    
    
    
}


@end
