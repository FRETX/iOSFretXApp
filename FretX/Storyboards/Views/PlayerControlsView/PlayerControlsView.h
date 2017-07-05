//
//  PlayerControlsView.h
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ControlsStatePlaying,
    ControlsStatePaused
}ControlsState;

@protocol PlayerControlsViewDelegate <NSObject>

- (void)didTapPlayerButton;

- (void)didSeekNewTimePosition:(float)newTime;

@end

@interface PlayerControlsView : UIView

@property (weak) id<PlayerControlsViewDelegate> delegate;

- (void)setupWithDuration:(float)duration;
- (void)setupCurrentTime:(float)currentTime;

- (void)setupState:(ControlsState)controlsState;

@end
