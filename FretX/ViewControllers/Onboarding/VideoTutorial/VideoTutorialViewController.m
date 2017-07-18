//
//  VideoTutorialViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "VideoTutorialViewController.h"

#import <Intercom/Intercom.h>

#import "YTPlayerView.h"
#import "AppDelegate.h"

typedef enum{
    VideoIndex1 = 1,
    VideoIndex2,
    VideoIndex3,
    VideoIndex4
}VideoIndex;

@interface VideoTutorialViewController () <YTPlayerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//ui
@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) IBOutlet UIView *controllView;
@property (nonatomic, strong) IBOutlet UIView *controllFinalView;
@property (nonatomic, strong) IBOutlet UIView *controllShadowView;

//data
@property (assign) int currentVideoIndex;

@property (assign) BOOL isSingleVideo;
@property (assign) int singleVideoIdx;

@end

@implementation VideoTutorialViewController

//youtube IDs for onboarding videos: iXvujYv875s OV3ac52jVBU SEmHjtdAPWU NQkJRxoZMLE
//4 vids in total

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_isSingleVideo) {
        self.currentVideoIndex = _singleVideoIdx;
    }else{
        self.currentVideoIndex = 1;
    }
    
    [self setupPlayerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //rotate
    [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)showSingleViedeo:(int)idx {
    _isSingleVideo =  YES;
    _singleVideoIdx = idx;
}

#pragma mark - Layout

- (void)setupPlayerView{
    
    self.playerView.delegate = self;
    
    NSDictionary* playerParams = @{@"controls"    : @2,
                                   @"autoplay"    : @0,
                                   @"fs"          : @0,
                                   @"showinfo"    : @1,
                                   @"playsinline" : @1,
                                   @"modestbranding" : @1,
                                   @"rel" : @0};
    
    NSString* videoID = [self youtubeIDForIndex:self.currentVideoIndex];
    [self.playerView loadWithVideoId:videoID playerVars:playerParams];
}

#pragma mark - 

- (void)showFinalPopup{
    
    if (self.currentVideoIndex < VideoIndex4) {
        
        if (!self.controllView.superview) {
            [self.view addSubview:self.controllView];
            self.controllView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[v]-(30)-|" options:0 metrics:nil views:@{@"v":self.controllView}]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[v]-(30)-|" options:0 metrics:nil views:@{@"v":self.controllView}]];
        }
        self.controllView.hidden =
        self.controllShadowView.hidden = NO;
        
    } else{
        
        if (!self.controllFinalView.superview) {
            [self.view addSubview:self.controllFinalView];
            self.controllFinalView.center = self.view.center;
        }
        self.controllFinalView.hidden =
        self.controllShadowView.hidden = NO;
    }
}

- (void)hideFinalPopup {
    self.controllView.hidden =
    self.controllFinalView.hidden =
    self.controllShadowView.hidden = YES;
}

#pragma mark - Player

- (NSString*)youtubeIDForIndex:(VideoIndex)videoIndex{
    
    //iXvujYv875s OV3ac52jVBU SEmHjtdAPWU NQkJRxoZMLE
    //4 vids in total
    NSString* result = @"";
    switch (videoIndex) {
        case VideoIndex1: result = @"iXvujYv875s";  break;
        case VideoIndex2: result = @"OV3ac52jVBU";  break;
        case VideoIndex3: result = @"SEmHjtdAPWU";  break;
        case VideoIndex4: result = @"NQkJRxoZMLE";  break;
        default:
            break;
    }
    return result;
}

#pragma mark - Actions 

- (IBAction)onDone:(id)sender {
    
    self.currentVideoIndex++;
    [self hideFinalPopup];
    self.playerView.hidden = YES;
   
    [self setupPlayerView];
    [self.playerView playVideo];
}

- (IBAction)onReloadVideo:(id)sender {
    [self.playerView seekToSeconds:0 allowSeekAhead:YES];
    [self.playerView playVideo];
    [self hideFinalPopup];
}

- (IBAction)onNeedAssistance:(id)sender {
    [Intercom presentMessenger];
}

- (IBAction)onReady:(id)sender {
    
    //rotate
    [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:NO];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    [self performSegueWithIdentifier:kBLEConnectionSegue sender:self];
}

- (IBAction)onPhoto:(id)sender {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    self.playerView.hidden = NO;
    [playerView playVideo];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    if (state == kYTPlayerStateEnded) {
        if (self.isSingleVideo) {
            
            //rotate
            [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:NO];
            NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self showFinalPopup];
        }
    }
}

- (void)playerView:(nonnull YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    NSLog(@"PlayerError = %ld",(long)error);
}

#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    [picker dismissViewControllerAnimated:NO completion:^{
        [Intercom presentMessageComposerWithInitialMessage:@"I've set up my FretX on my guitar, here is a picture!"];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
