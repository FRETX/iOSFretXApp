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
#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import "DLRadioButton.h"

typedef enum{
    SettingStateGuitar = 1,
    SettingStateHand,
    SettingStateSkill
}SettingState;

@interface MainSettingsViewController () {
    
    FIRDatabaseReference *dbRef;
}

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

    self.navigationController.navigationBarHidden = YES;
    
    self.state = 1;
    [self layout];
    
    NSString *currentUID = [[[FIRAuth auth] currentUser] uid];
    dbRef = [[[[FIRDatabase database] reference] child: @"users"] child: currentUID];
    [dbRef observeSingleEventOfType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dic = snapshot.value;
        
        if (!dic || [dic isEqual:[NSNull null]]) {
            return;
        }
        
        NSDictionary *pref_dic = [dic objectForKey: @"prefs"];
        NSString *mHandedness = [pref_dic objectForKey: @"hand"];
        if ([mHandedness isEqualToString: @"right"]) {
            [(DLRadioButton*)[self.handContainerView viewWithTag:2] setSelected:YES];
        } else
            [(DLRadioButton*)[self.handContainerView viewWithTag:1] setSelected:YES];
        
        NSString *mGuitar = [pref_dic objectForKey: @"guitar"];
        if ([mGuitar isEqualToString: @"classical"]) {
            [(DLRadioButton*)[self.guitarContainerView viewWithTag:3] setSelected:YES];
        } else if ([mGuitar isEqualToString: @"electric"])
            [(DLRadioButton*)[self.guitarContainerView viewWithTag:1] setSelected:YES];
        else
            [(DLRadioButton*)[self.guitarContainerView viewWithTag:2] setSelected:YES];
        
        NSString *mLevel = [pref_dic objectForKey: @"level"];
        if ([mLevel isEqualToString: @"beginner"]) {
            [(DLRadioButton*)[self.skillContainerView viewWithTag:1] setSelected:YES];
        } else
            [(DLRadioButton*)[self.skillContainerView viewWithTag:2] setSelected:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self.tutorialStatesView setupStatesCount:3];
    
    [self layoutState:self.state];
}

#pragma mark -

- (void)layout{
    
    [self addStatesView];
    
    //user
    NSString* userName = [(AppDelegate*)([UIApplication sharedApplication].delegate) mUserName];
    self.userNameLabel.text = [NSString stringWithFormat:@"Hi, %@",userName];
}

- (void)addStatesView{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TutorialStateView"  owner:self  options:nil];
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

- (IBAction)onGuitarButton:(UIButton*)sender{

    switch (sender.tag) {
        case 1:
            [[[dbRef child: @"prefs"] child: @"guitar"] setValue: @"electric"];
            break;
        case 2:
            [[[dbRef child: @"prefs"] child: @"guitar"] setValue: @"acoustic"];
            break;
        case 3:
            [[[dbRef child: @"prefs"] child: @"guitar"] setValue: @"classical"];
            break;
    }
}

- (IBAction)onHandButton:(UIButton*)sender{

    if (sender.tag == 1) {
        [[[dbRef child: @"prefs"] child: @"hand"] setValue: @"left"];
    } else {
        [[[dbRef child: @"prefs"] child: @"hand"] setValue: @"right"];
    }
}

- (IBAction)onSkillButton:(UIButton*)sender{
    
    // change Skill Level
    if (sender.tag == 1) {
        [[[dbRef child: @"prefs"] child: @"level"] setValue: @"beginner"];
    } else
    {
        [[[dbRef child: @"prefs"] child: @"level"] setValue: @"player"];
    }

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
