//
//  TunerBarView.h
//  FretX
//
//  Created by Onur Babacan on 24/07/2017.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TunerBarView : UIView

@property float centerPitch;
@property float currentPitch;
@property float TUNING_THRESHOLD_CENTS;
@property CGFloat ACCELERATION;
@property NSDate *prevTime;
@property CGFloat currentPos;
@property float rightmostPitch;
@property float leftmostPitch;

-(void) setPitch:(float) pitch;
-(void) setTargetPitch:(float)targetPitch leftPitch:(float)leftPitch rightPitch:(float)rightPitch;
@end
