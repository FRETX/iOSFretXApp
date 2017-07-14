//
//  TimeConverter.m
//  FretX
//
//  Created by Developer on 7/14/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "TimeConverter.h"

@implementation TimeConverter


+ (NSString*)durationStringFromSeconds:(float)audioDurationSeconds{
    
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    
    if (audioDurationSeconds/3600 > 1) {
        hours = audioDurationSeconds/3600;
        if (audioDurationSeconds - hours*3600 > 0 ){
            audioDurationSeconds = audioDurationSeconds - hours*3600;
        }
    }
    
    if (audioDurationSeconds/60 > 1) {
        minutes = audioDurationSeconds / 60;
        if (audioDurationSeconds - minutes*60 > 0 )
            seconds = audioDurationSeconds - minutes*60;
    } else
        seconds = audioDurationSeconds;
    
    NSString* stringHours;
    if (hours == 0) {
        stringHours = @"00";
    } else if (hours > 0 && hours <= 9) {
        stringHours = [NSString stringWithFormat:@"0%d",hours];
    } else {
        stringHours = [NSString stringWithFormat:@"%d",hours];
    }
    
    NSString* stringMinutes;
    if (minutes == 0) {
        stringMinutes = @"00";
    } else if (minutes > 0 && minutes <= 9) {
        stringMinutes = [NSString stringWithFormat:@"0%d",minutes];
    } else {
        stringMinutes = [NSString stringWithFormat:@"%d",minutes];
    }
    
    NSString* stringSeconds;
    if (seconds == 0) {
        stringSeconds = @"00";
    } else if (seconds > 0 && seconds <= 9) {
        stringSeconds = [NSString stringWithFormat:@"0%d",seconds];
    } else {
        stringSeconds = [NSString stringWithFormat:@"%d",seconds];
    }
    
    NSString* stringAudioDuration = @"";
    if (hours > 0)
        stringAudioDuration = [NSString stringWithFormat:@"%@:%@:%@",stringHours,stringMinutes,stringSeconds];
    else
        stringAudioDuration = [NSString stringWithFormat:@"%@:%@",stringMinutes,stringSeconds];
    
    return stringAudioDuration;
}

@end
