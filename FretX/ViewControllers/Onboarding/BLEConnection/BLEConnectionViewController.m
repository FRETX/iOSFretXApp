//
//  BLEConnectionViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "BLEConnectionViewController.h"
#import <FretXBLE/FretXBLE-Swift.h>
#import "UIImage+animatedGIF.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import <Intercom/Intercom.h>

@interface BLEConnectionViewController () <FretxProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak,nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation BLEConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // place animation in imageView
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"light0" ofType:@"gif"]];
    self.imageView.image = [UIImage animatedImageWithAnimatedGIFData:data];
    
    //
    FretxBLE.sharedInstance.delegate = self;
    [FretxBLE.sharedInstance connect];
}

#pragma mark -  Actions

- (IBAction)onPressConnectionButton:(id)sender{
    [FretxBLE.sharedInstance connect];
}

- (IBAction)onPressDoItLaterButton:(id)sender{
    
    [self performSegueWithIdentifier:kLightsIndicatorsSegue sender:self];
}

- (IBAction)onNeedAssistanceButton:(id)sender{
    [Intercom presentMessenger];
}


#pragma mark - Bluetooth delegate methods

- (void) didStartScan{
//    [self showMessage:@"Device start scan" withTitle:@""];
    self.statusLabel.text = @"Searching device";
}

- (void) didConnect{
//    [self showMessage:@"Device conected"];
    self.statusLabel.text = @"Device conected";
}

- (void) didDisconnect{
    [self showMessage:@"Device disconected"];
    self.statusLabel.text = @"Couldn't connect your Fretx";
}

- (void)didScanTimeout{
    [self showMessage:@"Couldn't connect your Fretx"];
    self.statusLabel.text = @"Couldn't connect your Fretx";
}

- (void)didBLEStateChangeWithState:(CBManagerState)state {}

#pragma mark - UIAlertAction

- (void)showMessage:(NSString*)message {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:message
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
