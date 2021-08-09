//
//  AdditionalControlsView.h
//  FretX
//
//  Created by Developer on 7/5/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TimeDelayNone = 1,
    TimeDelayQuarterSecond,
    TimeDelayHalfSecond,
    TimeDelayOneSecond
}TimeDelay;

typedef enum{
    CutPointA = 1,
    CutPointB
}CutPoint;

@class AdditionalControlsView;

@protocol AdditionalControlsViewDelegate <NSObject>

- (void)didTapLoopAdditionalControls:(AdditionalControlsView*)additionalControlsView;
- (void)additionalControls:(AdditionalControlsView*)additionalControlsView didTapCutPoint:(CutPoint)cutPoint;
- (void)additionalControls:(AdditionalControlsView*)additionalControlsView didTapTimeDelay:(TimeDelay)timeDelay;
- (void)didTapCollapseAdditionalControls:(AdditionalControlsView*)additionalControlsView;
- (void)didTapExpandAdditionalControls:(AdditionalControlsView*)additionalControlsView;

@end

@interface AdditionalControlsView : UIView

@property (weak) id<AdditionalControlsViewDelegate> delegate;

//- (void)layoutDelay:(TimeDelay)timeDelay;
- (void)layoutLoop:(BOOL)loop;
- (void)deselectTimePointsButtons;

@end
