//
//  CompletionPopupView.h
//  FretX
//
//  Created by Developer on 7/6/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompletionPopupView;

@protocol CompletionPopupViewDelegate <NSObject>

- (void)didTapReplayCompletionPopup:(CompletionPopupView*)completionPopupView;
- (void)didTapBackCompletionPopup:(CompletionPopupView*)completionPopupView;
- (void)didTapPlayAnotherCompletionPopup:(CompletionPopupView*)completionPopupView;
@end

@interface CompletionPopupView : UIView

@property (weak) id<CompletionPopupViewDelegate> delegate;

- (void)setupWithSongName:(NSString*)name nextVideoLessonYoutubeID:(NSString*)youtubeID;

- (void)showCompletionPopupAnimated:(BOOL)animated;
- (void)hideCompletionPopupAnimated:(BOOL)animated;

@end
