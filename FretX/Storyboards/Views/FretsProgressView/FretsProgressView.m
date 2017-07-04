//
//  FretsProgressView.m
//  FretX
//
//  Created by Developer on 7/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "FretsProgressView.h"

#define WideStyleHeight 22
#define DefaultStyleHeight 10

#define ThubmImageInset 2

#define AppearanceDuration 0.26
#define MovementDuration 0.65

@interface FretsProgressView ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* progessWidthConstraint;
@property (nonatomic, weak) IBOutlet UIImageView* emojiImageView;

@property (nonatomic, weak) IBOutlet UIView* progressThumbView;
@property (nonatomic, weak) IBOutlet UIView* progressBGView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* progessBGHeightConstraint;
@property (assign) ProgressViewStyle style;
@end

@implementation FretsProgressView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.progressThumbView.layer.borderColor = [UIColor blackColor].CGColor;
    self.progressBGView.layer.borderColor = [UIColor blackColor].CGColor;
}

#pragma mark - Public

- (void)setupProgress:(float)progressValue{
    
    if (progressValue < 0) {
        progressValue = 0;
    } else if (progressValue > 1){
        progressValue = 1;
    }
    
    float progressWidth = [self widthForProgressValue:progressValue];
    self.progessWidthConstraint.constant = progressWidth;
    
    [self layoutIfNeeded];
}

- (void)setupStyle:(ProgressViewStyle)progressViewStyle{
    
    [self layoutIfNeeded];
    float width = self.emojiImageView.frame.size.width - (ThubmImageInset*2);
    
    if (progressViewStyle == ProgressViewStyleWide) {
        
        self.progressThumbView.layer.borderWidth = 0;
        self.progressBGView.layer.borderWidth = 0;
        
        self.progressThumbView.layer.cornerRadius = width/2;
        self.progressBGView.layer.cornerRadius = width/2;
        
        self.progressThumbView.backgroundColor = [UIColor clearColor];
        self.progressBGView.backgroundColor = [UIColor colorWithRed:28/255.f green:183/255.f blue:35/255.f alpha:1.0f];
        
        self.progessBGHeightConstraint.constant = width;
        
        self.emojiImageView.alpha = 0.f;
        self.progressBGView.alpha = 0.f;
        
    } else if (progressViewStyle == ProgressViewStyleDefault) {

//        self.progressThumbView.layer.borderWidth = 1;
//        self.progressBGView.layer.borderWidth = 1;
//        
//        self.progressThumbView.layer.cornerRadius = 0;
//        self.progressBGView.layer.cornerRadius = 0;
//        
//        self.progressThumbView.backgroundColor = [UIColor colorWithRed:102/255.f green:234/255.f blue:51/255.f alpha:1.0f];
//        
//        self.progessHeightConstraint.constant = DefaultStyleHeight;
        
        self.emojiImageView.alpha = 1.f;
        self.progressThumbView.alpha = 1.f;
    }
    self.style = progressViewStyle;
    [self layoutIfNeeded];
}

- (void)showAnimation{
    
    static BOOL isAnimatingNow = NO;
    
//    if (isAnimatingNow) {
//        UIView canc
//        return;
//    }
    
    //reset animation
    self.emojiImageView.alpha = 1.f;
    self.progressBGView.alpha = 1.f;
    self.progessWidthConstraint.constant = [self widthForProgressValue:0];
    [self layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:AppearanceDuration animations:^{
        
        weakSelf.emojiImageView.alpha = 1.f;
        weakSelf.progressBGView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
        weakSelf.progessWidthConstraint.constant = [self widthForProgressValue:1];
        [UIView animateWithDuration:MovementDuration animations:^{

            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:AppearanceDuration animations:^{
                
                weakSelf.emojiImageView.alpha = 0.f;
                weakSelf.progressBGView.alpha = 0.f;
            }];
        }];
    }];
}

#pragma mark - Private

- (float)widthForProgressValue:(float)progressValue{
    
    float width = self.style == ProgressViewStyleDefault ? self.frame.size.width : self.frame.size.height;
//    float width =  self.frame.size.width ;
    
//    float thumbHalfWidth = self.emojiImageView.frame.size.width / 2;
//    float fullWidth = self.frame.size.width;
    float minWidth = self.emojiImageView.frame.size.width / 2 - ThubmImageInset;
    float maxWidth = width - minWidth;
    
    float result = width * progressValue;//self.emojiImageView.frame
    if (result < minWidth) {
        result = minWidth;
    } else if (result > maxWidth) {
        result = maxWidth + ThubmImageInset;
    }
    return result;
}




@end
