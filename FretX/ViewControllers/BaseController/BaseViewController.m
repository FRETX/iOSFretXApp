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

#import "NavigationManager.h"

@class MelodiesViewController, LearnProgrammsViewController, TunerViewController, SettingsViewController;

@interface BaseViewController ()

@property (strong) UIBarButtonItem* guitarItem;
@property (strong) UIBarButtonItem* eyeItem;

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

- (void)addRightBarItems{
    
    NSArray* rightItems;
    
    UIBarButtonItem* guitarItem = [self getGuitarItem];
    self.guitarItem = guitarItem;
    
    if ([self.navigationController.viewControllers[0] isEqual:self]) {
        UIBarButtonItem* eyeItem = [self getEyeItem];
        self.eyeItem = eyeItem;
        rightItems = @[guitarItem,eyeItem];
    }else{
        rightItems = @[guitarItem];
    }
    
    self.navigationItem.rightBarButtonItems = rightItems;
}

#pragma mark - 

- (UIBarButtonItem*)getGuitarItem{
    UIImage* image = nil;
    image = [UIImage imageNamed:@"GuitarHeadDeselected"];
    
    UIBarButtonItem* guitarItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(onGuitarHeadButton:)];
    return guitarItem;
}

- (UIBarButtonItem*)getEyeItem{
    UIImage* image = [self eyeIconImage];
    UIBarButtonItem* eyeItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(onEyeButton:)];
    return eyeItem;
}

- (UIImage*)eyeIconImage{
    UIImage* image = nil;
    if ([NavigationManager defaultManager].needToOpenYoutubeScreen) {
        image = [UIImage imageNamed:@"EyeIconSelected"];
    } else{
        image = [UIImage imageNamed:@"EyeIconDeselected"];
    }
    return image;
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

- (void)onEyeButton:(UIBarButtonItem*)sender{
    
    [NavigationManager defaultManager].needToOpenYoutubeScreen = ![NavigationManager defaultManager].needToOpenYoutubeScreen;
    self.eyeItem.image = [self eyeIconImage];
}

- (void)onBackButton:(id)sender{
    
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
