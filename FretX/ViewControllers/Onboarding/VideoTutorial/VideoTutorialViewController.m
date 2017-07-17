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

@interface VideoTutorialViewController () <YTPlayerViewDelegate>

//ui
@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) IBOutlet UIView *controllView;
@property (nonatomic, strong) IBOutlet UIView *controllShadowView;

//data
@property (assign) int currentVideoIndex;

@end

@implementation VideoTutorialViewController

//youtube IDs for onboarding videos: iXvujYv875s OV3ac52jVBU SEmHjtdAPWU NQkJRxoZMLE
//4 vids in total

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //rotate
    [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.currentVideoIndex = 1;
    [self setupPlayerView];
}

#pragma mark - Layout

- (void)setupPlayerView{
    
    self.playerView.delegate = self;
    
    NSDictionary* playerParams = @{@"controls"    : @1,
                                   @"autoplay"    : @1,
                                   @"fs"          : @1,
                                   @"showinfo"    : @0,
                                   @"playsinline" : @1};
    
    NSString* videoID = [self youtubeIDForIndex:self.currentVideoIndex];
    [self.playerView loadWithVideoId:videoID playerVars:playerParams];
}

#pragma mark - 

- (void)showFinalPopup{

    if (self.currentVideoIndex < VideoIndex4) {
        
        [self.playerView seekToSeconds:0 allowSeekAhead:YES];
        [self.playerView pauseVideo];
        
        if (!self.controllView.superview) {
            [self.view addSubview:self.controllView];
            self.controllView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[v]-(30)-|" options:0 metrics:nil views:@{@"v":self.controllView}]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[v]-(30)-|" options:0 metrics:nil views:@{@"v":self.controllView}]];
        }
        self.controllView.hidden =
        self.controllShadowView.hidden = NO;
        
    } else{
        //rotate
        [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:NO];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [self performSegueWithIdentifier:kBLEConnectionSegue sender:self];
    }
}

- (void)hideFinalPopup {
    self.controllView.hidden =
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

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    self.playerView.hidden = NO;
    [playerView playVideo];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    if (state == kYTPlayerStateEnded) {
        [self showFinalPopup];
    }
}

- (void)playerView:(nonnull YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    NSLog(@"PlayerError = %ld",(long)error);
}

@end
