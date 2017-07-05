//
//  AdditionalControlsView.m
//  FretX
//
//  Created by Developer on 7/5/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "AdditionalControlsView.h"

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

@interface AdditionalControlsView ()

@property (weak) IBOutlet UIButton* aPointButton;
@property (weak) IBOutlet UIButton* loopButton;
@property (weak) IBOutlet UIButton* bPointButton;

@property (weak) IBOutlet UIButton* clockButton;

@property (weak) IBOutlet UIButton* oneSecondButton;
@property (weak) IBOutlet UIButton* halfSecondButton;
@property (weak) IBOutlet UIButton* quarterSecondButton;
@property (weak) IBOutlet UIButton* zeroSecondButton;

@end

@implementation AdditionalControlsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -

- (void)setupDelay:(TimeDelay)timeDelay{
    
    
}

- (void)setupButton:(UIButton*)button selected:(BOOL)selected{
    
    if (selected) {
//        button set
    } else{
        
    }
}

#pragma mark - Actions

- (IBAction)onCutPointButton:(UIButton*)sender{
    
    
}

- (IBAction)onLoopButton:(UIButton*)sender{
    
    
}

- (IBAction)onTimeDelayButton:(UIButton*)sender{
    
    
}

- (IBAction)onCloseButton:(UIButton*)sender{
    
    
}

- (IBAction)onArrowUpButton:(UIButton*)sender{
    
    
}

@end
