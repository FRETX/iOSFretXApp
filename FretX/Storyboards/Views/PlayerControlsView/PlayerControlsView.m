//
//  PlayerControlsView.m
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "PlayerControlsView.h"

@interface PlayerControlsView ()

@property (weak) IBOutlet UIButton* playerButton;

@property (nonatomic, weak) IBOutlet UISlider *timeLineSlider;
@property (nonatomic, weak) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel *timePassedLabel;

//data
@property (assign) float duration;
@end

@implementation PlayerControlsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public

- (void)setupWithDuration:(float)duration{
    self.duration = duration;
    self.timePassedLabel.text = @"00:00";
    self.timeLeftLabel.text = [self durationStringFromSeconds:self.duration/1000];
}

- (void)setupCurrentTime:(float)currentTime{
    
    self.timeLineSlider.value = currentTime / self.duration;
    
    self.timePassedLabel.text = [self durationStringFromSeconds:currentTime/1000];
    self.timeLeftLabel.text = [self durationStringFromSeconds:(self.duration - currentTime)/1000];
}

- (void)setupState:(ControlsState)controlsState{
    
    UIImage* imageIcon;
    switch (controlsState) {
            case ControlsStatePlaying:
                imageIcon = [UIImage imageNamed:@"PauseButtonIcon"];
            break;
            case ControlsStatePaused:
                imageIcon = [UIImage imageNamed:@"PlayButtonIcon"];
            break;
        default:
            break;
    }
    
    [self.playerButton setImage:imageIcon forState:UIControlStateNormal];
}

#pragma mark - Private

- (NSString*)durationStringFromSeconds:(float)audioDurationSeconds{
    
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

#pragma mark - Actions

- (IBAction)onPlayerButton:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(didTapPlayerButton)]) {
        [self.delegate didTapPlayerButton];
    }
}


@end
