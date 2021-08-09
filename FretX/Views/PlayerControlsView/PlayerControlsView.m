//
//  PlayerControlsView.m
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "PlayerControlsView.h"

#import "TimeConverter.h"

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
    self.timeLeftLabel.text = [TimeConverter durationStringFromSeconds:self.duration/1000];
}

- (void)setupCurrentTime:(float)currentTime{
    
    self.timeLineSlider.value = currentTime / self.duration;
    
    self.timePassedLabel.text = [TimeConverter durationStringFromSeconds:currentTime/1000];
    self.timeLeftLabel.text = [TimeConverter durationStringFromSeconds:(self.duration - currentTime)/1000];
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



#pragma mark - Actions

- (IBAction)onChangeValueTimeSlider:(UISlider*)sender{
    
    float newTimePositionMs = sender.value * self.duration;
    if ([self.delegate respondsToSelector:@selector(didSeekNewTimePosition:)]) {
        [self.delegate didSeekNewTimePosition:newTimePositionMs];
    }
}

- (IBAction)onPlayerButton:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(didTapPlayerButton)]) {
        [self.delegate didTapPlayerButton];
    }
}


@end
