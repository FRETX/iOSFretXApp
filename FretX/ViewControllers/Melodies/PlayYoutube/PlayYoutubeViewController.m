//
//  PlayYoutubeViewController.m
//  FretX
//
//  Created by Developer on 7/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "PlayYoutubeViewController.h"

#import <AVKit/AVPlayerViewController.h>
#import <AVKit/AVKit.h>

#import <AVFoundation/AVFoundation.h>

#import "ChordsTimeLineView.h"
#import "PlayerControlsView.h"
#import "GuitarNeckView.h"
#import "RequestManager.h"
#import "YTPlayerView.h"
#import "Lesson.h"
#import "Chord.h"

@interface PlayYoutubeViewController () <YTPlayerViewDelegate, PlayerControlsViewDelegate>

//ui
@property (nonatomic, weak) IBOutlet UIView* controlsContainerView;

@property (nonatomic, weak) IBOutlet UILabel* songFullNameLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
@property (nonatomic, weak) PlayerControlsView* playerControlsView;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIView* timeLineContainerView;
@property (nonatomic, weak) ChordsTimeLineView* timeLineView;


@property (nonatomic, weak) IBOutlet UILabel* testChordNameLabel;

//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong) Chord* currentChord;

@property (nonatomic, strong) NSTimer* timer;

//@property (strong) AVPlayer* player;

@end

@implementation PlayYoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [self layout];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopChordsTimer];
}

- (void)dealloc{
    [self stopChordsTimer];
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

#pragma mark - Public

- (void)setupLesson:(Lesson*)lesson{
    
    self.lesson = lesson;
}

#pragma mark - Player

- (void)playSongVideo{
    
    //[self.playerView seekToSeconds:0 allowSeekAhead:YES];
    [self.playerView playVideo];
}

- (void)resumeSongVideo{

    [self.playerView playVideo];
}

- (void)pauseSongVideo{
    [self.playerView pauseVideo];
}

- (void)stopSongVideo{
    [self.playerView stopVideo];
}

#pragma mark - Update all controls

- (void)layoutStartPlayingVideoLesson{
    [self.timeLineView move];
    [self startChordsTimer];
    [self.playerControlsView setupState:ControlsStatePlaying];
}

- (void)layoutStopPlayingVideoLesson{
    [self.timeLineView stop];
    [self stopChordsTimer];
    [self.playerControlsView setupState:ControlsStatePaused];
}

#pragma mark - Layout

- (void)layout{
    
    [self.view layoutIfNeeded];
    [self addChordsTimeLineView];
    [self addFretBoard];
    [self addControlsView];

    [self layoutLesson:self.lesson];
    
    [self setupPlayerView];
    
}

- (void)layoutLesson:(Lesson*)lesson{
    
    self.songFullNameLabel.text = lesson.melodyTitle;
    if (lesson.punches.count > 0) {
        
        [self layoutChord:lesson.punches[0]];
    }
}

- (void)layoutChord:(Chord*)chord{
    
    self.currentChord = chord;
    
#warning TEST
    self.testChordNameLabel.text = chord.chordName;
    
    [self.guitarNeckView layoutChord:self.currentChord];
}

- (void)addFretBoard{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"GuitarNeckView"
                                                      owner:self
                                                    options:nil];
    
    self.guitarNeckView = [nibViews firstObject];
    CGRect bounds = self.fretsContainerView.bounds;
    [self.guitarNeckView setFrame:bounds];
    [self.fretsContainerView addSubview:self.guitarNeckView];
    
    [self.view layoutIfNeeded];
}

- (void)addControlsView{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"PlayerControlsView"
                                                      owner:self
                                                    options:nil];
    
    self.playerControlsView = [nibViews firstObject];
    CGRect bounds = self.controlsContainerView.bounds;
    [self.playerControlsView setFrame:bounds];
    [self.controlsContainerView addSubview:self.playerControlsView];
    
    self.playerControlsView.delegate = self;
    
    [self.view layoutIfNeeded];
}

- (void)addChordsTimeLineView{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ChordsTimeLineView"
                                                      owner:self
                                                    options:nil];
    
    self.timeLineView = [nibViews firstObject];
    CGRect bounds = self.timeLineContainerView.bounds;
    [self.timeLineView setFrame:bounds];
    [self.timeLineContainerView addSubview:self.timeLineView];

    [self.view layoutIfNeeded];
}

#pragma mark -

- (void)setupPlayerView{
    
    self.playerView.delegate = self;
    
//    [self.playerControlsView.
    
    NSDictionary* playerParams = @{
                                   @"controls"    : @0,
                                   @"autoplay"    : @1,
                                   @"fs"          : @0,
                                   @"showinfo"    : @0,
                                   @"playsinline" : @1};
    
    NSString* videoID = self.lesson.youtubeVideoId;
    [self.playerView loadWithVideoId:videoID playerVars:playerParams];//@"M7lc1UVf-VE"
}

#pragma mark - Timer

- (void)startChordsTimer{
    
    [self stopChordsTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onFiredChordsTimer:) userInfo:nil repeats:YES];
  
}

- (void)stopChordsTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onFiredChordsTimer:(NSTimer*)timer{
    
    float currentTime = self.playerView.currentTime * 1000;
    if (self.currentChord.timeMs <= 0 || self.currentChord.timeMs <= currentTime ) {
        Chord* nextChord = [self.lesson chordNextToChord:self.currentChord];
        if (nextChord)
            [self layoutChord:nextChord];
        
//        NSLog(@"didPlayTime = %f", currentTime);
    }
    
}

#pragma mark -  PlayerControlsViewDelegate

- (void)didTapPlayerButton{
    
    if (self.playerView.playerState == kYTPlayerStatePlaying) {
        [self pauseSongVideo];
    } else {
        [self resumeSongVideo];
    }
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    
    NSLog(@"playerViewDidBecomeReady");
    
    [self.timeLineView setupWithDuration:self.playerView.duration chords:self.lesson.punches];
    [self.playerControlsView setupWithDuration:playerView.duration*1000];
    [self playSongVideo];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didPlayTime:(float)playTime{
//    NSLog(@"didPlayTime");
//    NSLog(@"didPlayTime = %f", playTime);
    [self.playerControlsView setupCurrentTime:playTime*1000];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    if (state == kYTPlayerStatePlaying) {
        [self layoutStartPlayingVideoLesson];
    } else {
        [self layoutStopPlayingVideoLesson];
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

#pragma mark - Notifications

- (void)applicationWillResignActive:(NSNotification*)notification{
    
    [self stopSongVideo];
}

@end
