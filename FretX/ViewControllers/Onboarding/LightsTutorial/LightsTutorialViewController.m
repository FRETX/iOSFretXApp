//
//  LightsTutorialViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "LightsTutorialViewController.h"
#import "UIImage+animatedGIF.h"
#import "TutorialStateView.h"
#import <Intercom/Intercom.h>

typedef enum{
    LightsStateON = 1,
    LightsStateConnected,
    LightsStateSuccessHit,
    LightsStateOFF
}LightsState;

@interface LightsTutorialViewController ()

@property (weak) TutorialStateView* tutorialStatesView;
@property (weak) IBOutlet UIView* statesContainerView;
@property (weak) IBOutlet UIView* troubleshotingView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

//data
@property (assign) int state;

@end

@implementation LightsTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.state = LightsStateON;
    [self layout];
    [self layoutState:self.state];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHideHelp)];
    [self.view addGestureRecognizer:self.tapGesture];
    [self.tapGesture setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self.tutorialStatesView setupStatesCount:4];
    
    [self.tutorialStatesView selectState:1];
}

- (void)layout{
    
    [self addStatesView];
  
}

- (void)addStatesView{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TutorialStateView"
                                                      owner:self
                                                    options:nil];
    
    self.tutorialStatesView = [nibViews firstObject];
    CGRect bounds = self.statesContainerView.bounds;
    [self.tutorialStatesView setFrame:bounds];
    [self.statesContainerView addSubview:self.tutorialStatesView];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Screens Settings


- (NSString*)questionForState:(LightsState)state{
    
    NSString* question = @""; NSData *data = nil;
    switch (state) {
        case LightsStateON:
             data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"on_light" ofType:@"gif"]];

            question = @"When your device is \"ON\"";
            break;
        case LightsStateConnected:
            data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"light1" ofType:@"gif"]];
            
            question = @"When your device is \"Connected\"";
            break;
        case LightsStateSuccessHit:
            data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"light2" ofType:@"gif"]];
            
            question = @"When you hit \"SUCCESS\"";
            break;
        case LightsStateOFF:
            data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"light3" ofType:@"gif"]];
            
            question = @"Turning your device \"OFF\"";
            break;
        default:
            break;
    }
    
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFData:data];
    
    return question;
}

#pragma mark - Actions

//LightsStateON
//LightsStateConnected
//LightsStateSuccessHit
//LightsStateOFF

- (void)layoutState:(LightsState)state{
    
    self.questionLabel.text = [self questionForState:state];
    [self.tutorialStatesView selectState:state];
}

- (IBAction)onUnderStoodButton:(UIButton*)sender{
    if (self.state >= LightsStateOFF) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else{
        self.state++;
        [self layoutState:self.state];
    }
}

- (IBAction)onNeedHelp:(id)sender{
    [self.troubleshotingView setHidden:NO];
    [self.tapGesture setEnabled:YES];
}

- (void)onHideHelp{
    [self.troubleshotingView setHidden:YES];
    [self.tapGesture setEnabled:NO];
}

@end
