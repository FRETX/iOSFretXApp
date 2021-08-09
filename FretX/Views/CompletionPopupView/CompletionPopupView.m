//
//  CompletionPopupView.m
//  FretX
//
//  Created by Developer on 7/6/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "CompletionPopupView.h"

#import "UIImageView+AFNetworking.h"

@interface CompletionPopupView ()

@property (weak) IBOutlet UILabel* messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView* songThumbImageView;
@end

@implementation CompletionPopupView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

#pragma mark - Public

- (void)setupWithSongName:(NSString*)name nextVideoLessonYoutubeID:(NSString*)youtubeID{
    
    self.messageLabel.text = [NSString stringWithFormat:@"You successfully played:\n%@",name];
    
    NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youtubeID]];
//    [self.thumbImageButton setImageForState:UIControlStateNormal withURL:youtubeURL];
    [self.songThumbImageView setImageWithURL:youtubeURL placeholderImage:[UIImage imageNamed:@"DefaultThumb"]];
}

- (void)showCompletionPopupAnimated:(BOOL)animated{
    
    self.hidden = NO;
    float duration = animated ? 0.35f : 0.f;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1.f;
    }];
}

- (void)hideCompletionPopupAnimated:(BOOL)animated{
    
    float duration = animated ? 0.35f : 0.f;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
}

//- (void)showCompletionPopupAnimated:(BOOL)animated{
//    
//    self.completionPopupView.hidden = NO;
//    float duration = animated ? 0.3f : 0.f;
//    [UIView animateWithDuration:duration animations:^{
//        self.completionPopupView.alpha = 1.f;
//    }];
//}
//
//- (void)hideCompletionPopupAnimated:(BOOL)animated{
//    
//    float duration = animated ? 0.3f : 0.f;
//    [UIView animateWithDuration:duration animations:^{
//        self.completionPopupView.alpha = 0.f;
//    } completion:^(BOOL finished) {
//        
//        self.completionPopupView.hidden = YES;
//    }];
//}

#pragma mark - Actions

- (IBAction)onTapGestureRecognizer:(UITapGestureRecognizer*)sender{
    
    [self hideCompletionPopupAnimated:YES];
}

- (IBAction)onReplayButton:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(didTapReplayCompletionPopup:)]) {
        [self.delegate didTapReplayCompletionPopup:self];
    }
}

- (IBAction)onBackButton:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(didTapBackCompletionPopup:)]) {
        [self.delegate didTapBackCompletionPopup:self];
    }
}

- (IBAction)onPlayAnotherButton:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(didTapPlayAnotherCompletionPopup:)]) {
        [self.delegate didTapPlayAnotherCompletionPopup:self];
    }
}

@end
