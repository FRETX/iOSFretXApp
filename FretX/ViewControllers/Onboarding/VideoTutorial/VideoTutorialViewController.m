//
//  VideoTutorialViewController.m
//  FretX
//
//  Created by Developer on 7/13/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "VideoTutorialViewController.h"

#import "YTPlayerView.h"

typedef enum{
    VideoIndex1 = 1,
    VideoIndex2,
    VideoIndex3,
    VideoIndex4
}VideoIndex;

@interface VideoTutorialViewController () <YTPlayerViewDelegate>

//ui
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
//data
@property (assign) int currentVideoIndex;

@end

@implementation VideoTutorialViewController

//youtube IDs for onboarding videos: iXvujYv875s OV3ac52jVBU SEmHjtdAPWU NQkJRxoZMLE
//4 vids in total

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentVideoIndex = 1;
    [self layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self openNextController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Layout

- (void)layout{
    
    [self setupPlayerView];
}

- (void)setupPlayerView{
    
//    [self.indicatorView startAnimating];
    
    self.playerView.delegate = self;
    
    NSDictionary* playerParams = @{
                                   @"controls"    : @1,
                                   @"autoplay"    : @1,
                                   @"fs"          : @1,
                                   @"showinfo"    : @0,
                                   @"playsinline" : @1
                                   };
    
    NSString* videoID = [self youtubeIDForIndex:self.currentVideoIndex];
    [self.playerView loadWithVideoId:videoID playerVars:playerParams];
}

#pragma mark - 

- (void)showFinalPopup{
#warning TEST
    [self openNextController];
}

#pragma mark - Player

- (void)playVideo{
    
    [self.playerView playVideo];
    
}

- (void)openNextController{
    
    [self performSegueWithIdentifier:kBLEConnectionSegue sender:self];
}


- (NSString*)youtubeIDForIndex:(VideoIndex)videoIndex{
    
    //iXvujYv875s OV3ac52jVBU SEmHjtdAPWU NQkJRxoZMLE
//    4 vids in total
    NSString* result = @"";
    switch (videoIndex) {
        case VideoIndex1:
            result = @"iXvujYv875s";
            break;
        case VideoIndex2:
            result = @"OV3ac52jVBU";
            break;
        case VideoIndex3:
            result = @"SEmHjtdAPWU";
            break;
        case VideoIndex4:
            result = @"NQkJRxoZMLE";
            break;
            
        default:
            break;
    }
    return result;
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    
    self.playerView.hidden = NO;
    NSLog(@"playerViewDidBecomeReady");

    [self playVideo];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didPlayTime:(float)playTime{
    

}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    if (state == kYTPlayerStatePlaying) {
        
    } else {
       
    }
    
    if (state == kYTPlayerStateEnded) {
        
    
        if (self.currentVideoIndex < VideoIndex4) {
            self.currentVideoIndex++;
            [self layout];
        } else{
            [self showFinalPopup];
        }
    }
    
    NSString* strState = @"";
    switch (state) {
        case kYTPlayerStateUnstarted:
            strState = @"kYTPlayerStateUnstarted";
            break;
        case kYTPlayerStateEnded:
            strState = @"kYTPlayerStateEnded";
            break;
        case kYTPlayerStatePlaying:
            strState = @"kYTPlayerStatePlaying";
            break;
        case kYTPlayerStatePaused:
            strState = @"kYTPlayerStatePaused";
            break;
        case kYTPlayerStateBuffering:
            strState = @"kYTPlayerStateBuffering";
            break;
        case kYTPlayerStateQueued:
            strState = @"kYTPlayerStateQueued";
            break;
        case kYTPlayerStateUnknown:
            strState = @"kYTPlayerStateUnknown";
            break;
            
        default:
            break;
    }
    NSLog(@"PlayerState = %@",strState);
}

- (void)playerView:(nonnull YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    
    NSString* strError = @"";
    
    switch (error) {
        case kYTPlayerErrorInvalidParam:
            strError = @"kYTPlayerErrorInvalidParam";
            break;
        case kYTPlayerErrorHTML5Error:
            strError = @"kYTPlayerErrorHTML5Error";
            break;
        case kYTPlayerErrorVideoNotFound:
            strError = @"kYTPlayerErrorVideoNotFound";
            break;
        case kYTPlayerErrorNotEmbeddable:
            strError = @"kYTPlayerErrorNotEmbeddable";
            break;
        case kYTPlayerErrorUnknown:
            strError = @"kYTPlayerErrorUnknown";
            break;
            
        default:
            break;
    }
    NSLog(@"PlayerError = %@",strError);
}


@end
