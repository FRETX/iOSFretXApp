//
//  MainSettingsViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MainSettingsViewController.h"

#import "NotSureViewController.h"
#import "TutorialStateView.h"

typedef enum{
    SettingStateGuitar = 1,
    SettingStateHand,
    SettingStateSkill
}SettingState;

@interface MainSettingsViewController ()

//ui
@property (weak) IBOutlet UILabel* userNameLabel;

@property (weak) TutorialStateView* tutorialStatesView;
@property (weak) IBOutlet UIView* statesContainerView;

@property (weak) IBOutlet UILabel* questionLabel;

@property (weak) IBOutlet UIView* guitarContainerView;
@property (weak) IBOutlet UIView* handContainerView;
@property (weak) IBOutlet UIView* skillContainerView;

//data
@property (assign) int state;

@end

@implementation MainSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.state = 1;

    [self layout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self.tutorialStatesView setupStatesCount:3];
    
    [self layoutState:self.state];
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

#pragma mark -

- (void)layout{
    
    [self addStatesView];
    
    //user
    NSString* userName = @"";
    self.userNameLabel.text = [NSString stringWithFormat:@"Hi, %@",userName];
    
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

- (void)layoutState:(SettingState)state{
    
    self.questionLabel.text = [self questionForState:state];
    [self showViewForState:state];
    [self.tutorialStatesView selectState:state];
}

#pragma mark -

- (NSString*)questionForState:(SettingState)state{
    
    NSString* question = @"";
    switch (state) {
        case SettingStateGuitar:
            question = @"What kind of guitar do you have?";
            break;
        case SettingStateHand:
            question = @"Are you LEFT or RIGHT-HANDED?";
            break;
        case SettingStateSkill:
            question = @"What is your level skill?";
            break;
        default:
            break;
    }
    return question;
}

- (void)showViewForState:(int)state{
    
    self.guitarContainerView.hidden = YES;
    self.handContainerView.hidden = YES;
    self.skillContainerView.hidden = YES;
    
    switch (state) {
        case SettingStateGuitar:
            self.guitarContainerView.hidden = NO;
            break;
        case SettingStateHand:
            self.handContainerView.hidden = NO;
            break;
        case SettingStateSkill:
            self.skillContainerView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - Actions

- (void)onBackButton:(UIBarButtonItem*)sender{
    
    if (self.state > SettingStateGuitar){
        self.state--;
        [self layoutState:self.state];
    } else{
        [super popViewController];
    }
}

//SettingStateGuitar,
//SettingStateHand,
//SettingStateSkill
//
- (IBAction)onGuitarButton:(id)sender{
    
    
}

- (IBAction)onHandButton:(id)sender{
    
    
}

- (IBAction)onSkillButton:(id)sender{
    
    
}

- (IBAction)onNextStateButton:(id)sender{
    
    if (self.state >= SettingStateSkill) {
        
        [self performSegueWithIdentifier:kOpenFretxKitSegue sender:self];
    } else{
        self.state++;
        [self layoutState:self.state];
    }
 
}

- (IBAction)onNotSure:(id)sender {
    NotSureViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NotSureViewController class])];
    [controller showForViewController:self];
}

@end
