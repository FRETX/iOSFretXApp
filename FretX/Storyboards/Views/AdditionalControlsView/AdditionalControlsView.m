//
//  AdditionalControlsView.m
//  FretX
//
//  Created by Developer on 7/5/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "AdditionalControlsView.h"


@interface AdditionalControlsView ()

@property (weak) IBOutlet UIButton* aPointButton;
@property (weak) IBOutlet UIButton* loopButton;
@property (weak) IBOutlet UIButton* bPointButton;

@property (weak) IBOutlet UIButton* clockButton;
@property (weak) IBOutlet UIButton* upArrowButton;

@property (weak) IBOutlet UIButton* oneSecondButton;
@property (weak) IBOutlet UIButton* halfSecondButton;
@property (weak) IBOutlet UIButton* quarterSecondButton;
@property (weak) IBOutlet UIButton* zeroSecondButton;

@property (weak) IBOutlet NSLayoutConstraint* buttonsViewTopConstraint;

//data
@property (assign) BOOL collapsed;
@property (assign) BOOL loop;

@end

@implementation AdditionalControlsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self setupButton:self.zeroSecondButton selected:YES];
    self.collapsed = YES;
}

#pragma mark - Public

//- (void)layoutDelay:(TimeDelay)timeDelay{
//    
//    [self deselectDelayButtons];
//    switch (timeDelay) {
//        case TimeDelayNone:
//            [self setupButton:self.zeroSecondButton selected:YES];
//            break;
//        case TimeDelayQuarterSecond:
//            [self setupButton:self.quarterSecondButton selected:YES];
//            break;
//        case TimeDelayHalfSecond:
//            [self setupButton:self.halfSecondButton selected:YES];
//            break;
//        case TimeDelayOneSecond:
//            [self setupButton:self.oneSecondButton selected:YES];
//            break;
//        default:
//            break;
//    }
//}

- (void)layoutLoop:(BOOL)loop{
    self.loop = loop;
    [self setupButton:self.loopButton selected:loop];
}

- (void)deselectTimePointsButtons{
    [self setupButton:self.bPointButton selected:NO];
    [self setupButton:self.aPointButton selected:NO];
}

#pragma mark - Private

- (void)notifyToExpandView{
    
    self.collapsed = NO;
    if ([self.delegate respondsToSelector:@selector(didTapExpandAdditionalControls:)]) {
        [self.delegate didTapExpandAdditionalControls:self];
    }
}

- (void)notifyToCollapseView{
    
    self.collapsed = YES;

    if ([self.delegate respondsToSelector:@selector(didTapCollapseAdditionalControls:)]) {
        [self.delegate didTapCollapseAdditionalControls:self];
    }
}

- (void)setupButton:(UIButton*)button selected:(BOOL)selected{
    
    //button.selected = !button.selected;
    if (selected) {
        button.backgroundColor = [UIColor colorWithRed:246/255.f green:68/255.f blue:55/255.f alpha:1.0f];
    } else{
        button.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)deselectDelayButtons{
    [self setupButton:self.oneSecondButton selected:NO];
    [self setupButton:self.halfSecondButton selected:NO];
    [self setupButton:self.quarterSecondButton selected:NO];
    [self setupButton:self.zeroSecondButton selected:NO];
}

#pragma mark - Actions

- (IBAction)onCutPointButton:(UIButton*)sender{
    
    [self setupButton:sender selected:YES];
    CutPoint cutPoint = (CutPoint)sender.tag;
    if ([self.delegate respondsToSelector:@selector(additionalControls:didTapCutPoint:)]) {
        [self.delegate additionalControls:self didTapCutPoint:cutPoint];
    }
}

- (IBAction)onLoopButton:(UIButton*)sender{
    
    [self setupButton:sender selected:!self.loop];
    self.loop = !self.loop;
    if ([self.delegate respondsToSelector:@selector(didTapLoopAdditionalControls:)]) {
        [self.delegate didTapLoopAdditionalControls:self];
    }
}

- (IBAction)onTimeDelayButton:(UIButton*)sender{
    
    [self deselectDelayButtons];
    [self setupButton:sender selected:YES];
    
    TimeDelay timeDelayType =(TimeDelay)sender.tag;
    if ([self.delegate respondsToSelector:@selector(additionalControls:didTapTimeDelay:)]) {
        [self.delegate additionalControls:self didTapTimeDelay:timeDelayType];
    }
}

- (IBAction)onCloseButton:(UIButton*)sender{
    
    [self notifyToCollapseView];
}

- (IBAction)onArrowUpButton:(UIButton*)sender{
    
    if (self.collapsed) {
        [self notifyToExpandView];
    } else{
        [self notifyToCollapseView];
    }
}

@end
