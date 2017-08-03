//
//  VideoPlayerViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "VideoPlayerViewController.h"

#import <Intercom/Intercom.h>

#import "YTPlayerView.h"
#import "AppDelegate.h"

typedef enum{
    VideoIndex1 = 1,
    VideoIndex2,
    VideoIndex3,
    VideoIndex4
}VideoIndex;

@interface VideoPlayerViewController () <YTPlayerViewDelegate>

//ui
@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;
//@property (nonatomic, strong) IBOutlet UIView *controllView;
//@property (nonatomic, strong) IBOutlet UIView *controllFinalView;
//@property (nonatomic, strong) IBOutlet UIView *controllShadowView;

//data
@property (copy) void(^videoPlayingEndBlock)(void);
@property (strong) NSString* videoID;
@property (weak) UIViewController* targetController;

@end

@implementation VideoPlayerViewController

//youtube IDs for onboarding videos: iXvujYv875s OV3ac52jVBU SEmHjtdAPWU NQkJRxoZMLE
//4 vids in total

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //rotate
    [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

#pragma mark - Public

- (void)playOnTargetController:(UIViewController*)controller youtubeVideoID:(NSString*)youtubeVideoID completion:(void(^)(void))completion{
    
    self.videoPlayingEndBlock = completion;
    self.targetController = controller;
    self.videoID = youtubeVideoID;
    [controller presentViewController:self animated:NO completion:^{
        
        [self setupPlayerView];
    }];
}

#pragma mark - Layout

- (void)setupPlayerView{
    
    self.playerView.delegate = self;
    
    NSDictionary* playerParams = @{@"controls"    : @2,
                                   @"autoplay"    : @1,
                                   @"fs"          : @0,
                                   @"showinfo"    : @1,
                                   @"playsinline" : @1,
                                   @"modestbranding" : @1,
                                   @"rel" : @0};
    
    [self.playerView loadWithVideoId:self.videoID playerVars:playerParams];
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    self.playerView.hidden = NO;
    [playerView playVideo];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    if (state == kYTPlayerStateEnded) {

        //rotate
        [(AppDelegate*)([UIApplication sharedApplication].delegate) setIsLanscapeMode:NO];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        [self.targetController dismissViewControllerAnimated:YES completion:^{
            
            if (self.videoPlayingEndBlock)
                self.videoPlayingEndBlock();
        }];

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

