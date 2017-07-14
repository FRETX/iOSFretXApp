//
//  TutorialStateView.m
//  FretX
//
//  Created by Developer on 7/14/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "TutorialStateView.h"

#define kCircleHeight 12.f

@interface TutorialStateView ()

@property (nonatomic, weak) IBOutlet UIView* mainView;
@property (nonatomic, weak) IBOutlet UIView* redLineView;
@property (nonatomic, weak) IBOutlet UIView* grayLineView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* redLineWidthConstraint;
//data
@property (assign) int statesCount;
@end

@implementation TutorialStateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public

- (void)setupStatesCount:(int)statesCount{
    
    self.statesCount = statesCount;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (view.tag > 0)
            [view removeFromSuperview];
    }];
    
    for (int i = 0; i < statesCount; i++) {
        
        UIView* view = [self circleViewForState:i inStatesCount:statesCount];
        
        [self.mainView addSubview:view];
    }
    
    [self bringLinesToFront];
}

- (void)selectState:(int)state{
    
    //deselct all views at first
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self deselectView:view];
    }];
    
    UIView* view = [self viewWithTag:state];
    [self selectView:view];
    
    [self updateRedLineWidthForState:state];
    
    [self bringLinesToFront];
}

#pragma mark - Private

- (void)bringLinesToFront{
    
 //   [self.mainView bringSubviewToFront:self.grayLineView];
    [self.mainView bringSubviewToFront:self.redLineView];
}

- (void)updateRedLineWidthForState:(int)state{

    UIView* view = [self viewWithTag:state];
    self.redLineWidthConstraint.constant = view.frame.origin.x;
    [self layoutIfNeeded];
}

- (UIView*)circleViewForState:(int)state inStatesCount:(int)statesCount{
    
    float stateWidth = self.frame.size.width / (statesCount - 1);
    
    float y = self.frame.size.height/2 - kCircleHeight/2;
    
    CGRect rect = CGRectMake(stateWidth * state, y, kCircleHeight, kCircleHeight);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.layer.cornerRadius = kCircleHeight/2;
    view.backgroundColor = [UIColor darkGrayColor];

    view.layer.borderWidth = kCircleHeight/4;
    
    view.tag = state+1;
    
    return view;
}

- (void)selectView:(UIView*)view{
    view.layer.borderColor = [UIColor redColor].CGColor;
//    view.layer.borderWidth = kCircleHeight/4;
}

- (void)deselectView:(UIView*)view{
    view.layer.borderColor = [UIColor whiteColor].CGColor;
//    view.layer.borderWidth = 0;
}

@end
