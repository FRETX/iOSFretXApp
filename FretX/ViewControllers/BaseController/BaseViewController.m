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

#import "MelodiesViewController.h"

@class MelodiesViewController, LearnProgrammsViewController, TunerViewController, SettingsViewController;

@interface BaseViewController () <FretxProtocol>

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
    
    [self setRightBarItems];
}

#pragma mark - Public

- (void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
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
//    [self setRightBarItems];
}

- (void)setupNavigationItem{
    
    //titleView
    UIImageView* titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 69, 40)];
    titleImageView.image = [UIImage imageNamed:@"WhiteBarFretxLogo"];
    self.navigationItem.titleView = titleImageView;
}

- (void)addLeftBarItem{
    //left
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WhiteBackIcon"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(onBaseBackButton:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setRightBarItems{
    
    NSArray* rightItems;
    
    UIBarButtonItem* guitarItem = [self getGuitarItem];
    self.guitarItem = guitarItem;
    
    if ([self.navigationController.viewControllers[0] isKindOfClass:[MelodiesViewController class]]) {
        
        UIBarButtonItem* eyeItem = [self getEyeItem];
        self.eyeItem = eyeItem;
        //rightItems = @[guitarItem, eyeItem, searchItem];
        UIBarButtonItem* searchItem = [self isKindOfClass:[MelodiesViewController class]] ? [self getSearchItem] : nil;
        
        if (searchItem) {
            rightItems = @[guitarItem, eyeItem, searchItem];
        } else{
            rightItems = @[guitarItem, eyeItem];
        }
    }else{
        rightItems = @[guitarItem];
    }
    
    self.navigationItem.rightBarButtonItems = rightItems;
}

- (void)updateBluetoothButton{
    [self setRightBarItems];
}

#pragma mark - 

- (UIBarButtonItem*)getGuitarItem{
    
    UIBarButtonItem* guitarItem;
    if(FretxBLE.sharedInstance.isScanning){
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [activityIndicator startAnimating];
        guitarItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        NSLog(@"attempting to set scanning animation");
//        self.navigationItem.rightBarButtonItem = activityItem;
    } else {
        NSString *imageName;
        if(FretxBLE.sharedInstance.isConnected) {
            imageName =  @"GuitarHeadSelected";
        } else {
            imageName = @"GuitarHeadDeselected";
        }
        guitarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(onGuitarHeadButton:)];
//        self.navigationItem.rightBarButtonItem = btItem;
    }
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
    if ([NavigationManager defaultManager].needToOpenPreviewScreen) {
        image = [UIImage imageNamed:@"EyeIconSelected"];
    } else{
        image = [UIImage imageNamed:@"EyeIconDeselected"];
    }
    return image;
}

- (UIBarButtonItem*)getSearchItem{
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SearchIconSelected"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(onTapSearchButton:)];
    return searchItem;
}

#pragma mark - Override


#pragma mark - Actions

- (void)onTapSearchButton:(UIBarButtonItem*)sender{
    
    if ([self respondsToSelector:@selector(onSearchButton:)]) {
        [self performSelector:@selector(onSearchButton:) withObject:sender];
    }
}

- (void)onGuitarHeadButton:(UIBarButtonItem*)sender{
    if(FretxBLE.sharedInstance.isScanning){
        return;
    }
    if(FretxBLE.sharedInstance.isConnected){
        [FretxBLE.sharedInstance disconnect];
    } else {
        [FretxBLE.sharedInstance connect];
    }
    
}

- (void)onEyeButton:(UIBarButtonItem*)sender{
    
    [NavigationManager defaultManager].needToOpenPreviewScreen = ![NavigationManager defaultManager].needToOpenPreviewScreen;
    self.eyeItem.image = [self eyeIconImage];
}

- (void)onBaseBackButton:(UIBarButtonItem*)sender{
    
    
    if ([self respondsToSelector:@selector(onBackButton:)]) {
        [self performSelector:@selector(onBackButton:) withObject:sender];
    } else{
        [self popViewController];
    }
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

@end
