//
//  BaseViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "BaseViewController.h"
#import <FretXBLE/FretXBLE-Swift.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class MelodiesViewController, LearnProgrammsViewController, TunerViewController, SettingsViewController;

@interface BaseViewController () <FretxProtocol>
@property FretxBLE* bluetooth;
@end

@implementation BaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigation];
    _bluetooth = [FretxBLE sharedInstance];
    [_bluetooth verboseOn];
    _bluetooth.delegate = self;
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

- (void)setupNavigation{
    
    [self setupNavigationItem];
    if (![self.navigationController.viewControllers[0] isEqual:self]) {
        [self addLeftBarItem];
    }
    [self addRightBarItems];
}

- (void)setupNavigationItem{
    
    //titleView
    UIImageView* titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 76, 44)];
    titleImageView.image = [UIImage imageNamed:@"WhiteBarFretxLogo"];
    self.navigationItem.titleView = titleImageView;
}

- (void)addLeftBarItem{
    //left
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WhiteBackIcon"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(onBackButton:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)addRightBarItems{

    if(_bluetooth.isScanning){
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [activityIndicator startAnimating];
        UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        self.navigationItem.rightBarButtonItem = activityItem;
    } else {
        NSString *imageName;
        if(_bluetooth.isConnected) {
            imageName =  @"GuitarHeadSelected";
        } else {
            imageName = @"GuitarHeadDeselected";
        }
        UIBarButtonItem* btItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(onGuitarHeadButton:)];
        self.navigationItem.rightBarButtonItem = btItem;
    }
    
    
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)onGuitarHeadButton:(UIBarButtonItem*)sender{
    [self addRightBarItems];
    
    if(_bluetooth.isConnected){
        [_bluetooth disconnect];
    } else {
        [_bluetooth connect];
    }
    
//    if ([self respondsToSelector:@selector(guitarHeadButtonTapped:)]) {
//        [self performSelector:@selector(guitarHeadButtonTapped:) withObject:sender];
//    }
}

#pragma mark - Bluetooth delegate methods

- (void) didBLEStateChangeWithState:(CBManagerState)state{
    
}

- (void) didConnect{
    [self addRightBarItems];
}

- (void) didDisconnect{
    [self addRightBarItems];
}

- (void) didScanTimeout{
    [self addRightBarItems];
}





- (void)onBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
