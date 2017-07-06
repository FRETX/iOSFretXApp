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
@end

@implementation BaseViewController



- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)viewWillAppear:(BOOL)animated{
    FretxBLE.sharedInstance.delegate = self;
    [self updateBluetoothButton];
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

- (void)updateBluetoothButton{
    if(FretxBLE.sharedInstance.isScanning){
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [activityIndicator startAnimating];
        UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        NSLog(@"attempting to set scanning animation");
        self.navigationItem.rightBarButtonItem = activityItem;
    } else {
        NSString *imageName;
        if(FretxBLE.sharedInstance.isConnected) {
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
    if(FretxBLE.sharedInstance.isScanning){
        return;
    }
    if(FretxBLE.sharedInstance.isConnected){
        [FretxBLE.sharedInstance disconnect];
    } else {
        [FretxBLE.sharedInstance connect];
    }
    
//    if ([self respondsToSelector:@selector(guitarHeadButtonTapped:)]) {
//        [self performSelector:@selector(guitarHeadButtonTapped:) withObject:sender];
//    }
}

#pragma mark - Bluetooth delegate methods

- (void) didBLEStateChangeWithState:(CBManagerState)state{
    
}

- (void) didStartScan{
    [self updateBluetoothButton];
}

- (void) didConnect{
    [self updateBluetoothButton];
}

- (void) didDisconnect{
    [self updateBluetoothButton];
}

- (void) didScanTimeout{
    [self updateBluetoothButton];
}

- (void)onBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
