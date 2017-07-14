//
//  LightsTutorialViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "LightsTutorialViewController.h"

#import "TutorialStateView.h"

typedef enum{
    LightsStateON = 1,
    LightsStateConnected,
    LightsStateSuccessHit,
    LightsStateOFF
}LightsState;

@interface LightsTutorialViewController ()

@property (weak) TutorialStateView* tutorialStatesView;
@property (weak) IBOutlet UIView* statesContainerView;

//data
@property (assign) int state;

@end

@implementation LightsTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.state = LightsStateON;
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self.tutorialStatesView setupStatesCount:4];
    
    [self.tutorialStatesView selectState:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark - Actions

- (IBAction)onUnderStoodButton:(UIButton*)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
