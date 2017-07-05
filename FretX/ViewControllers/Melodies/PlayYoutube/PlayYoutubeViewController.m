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

#import "AdditionalControlsView.h"
#import "VideoEditor.h"
#import "ChordsTimeLineView.h"
#import "PlayerControlsView.h"
#import "GuitarNeckView.h"
#import "RequestManager.h"
#import "YTPlayerView.h"
#import "Lesson.h"
#import "Chord.h"

@interface PlayYoutubeViewController () <YTPlayerViewDelegate, PlayerControlsViewDelegate, AdditionalControlsViewDelegate, VideoEditorDelegate>

//ui
@property (nonatomic, weak) IBOutlet UILabel* songFullNameLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
@property (nonatomic, weak) IBOutlet UIView* controlsContainerView;
@property (nonatomic, weak) PlayerControlsView* playerControlsView;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIView* timeLineContainerView;
@property (nonatomic, weak) ChordsTimeLineView* timeLineView;
@property (nonatomic, weak) IBOutlet UIView* additionalControlsContainerView;
@property (nonatomic, weak) AdditionalControlsView* additionalControlsView;

@property (weak) IBOutlet NSLayoutConstraint* additionalControlsBottomConstraint;

@property (nonatomic, weak) IBOutlet UILabel* testChordNameLabel;

//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong) Chord* currentChord;
@property (nonatomic, strong) NSTimer* timer;
@property (strong) VideoEditor* videoEditor;

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
    self.videoEditor = [VideoEditor initWithDelegate:self];
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

- (void)playFromTime:(float)time{
#warning TEST
    [self.playerView pauseVideo];
    [self.playerView seekToSeconds:time allowSeekAhead:YES];
    [self resumeSongVideo];
    
}

#pragma mark - Update all controls

- (void)layoutStartPlayingVideoLesson{
    
#warning TEST
    Chord* nextChord = [self.lesson chordClosestToTime:self.playerView.currentTime*1000];
    [self layoutChord:nextChord];
    

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
    [self addAdditionalControlsView];

    [self layoutLesson:self.lesson];
    
    [self setupPlayerView];
    
    [self hideAdditionalControlsAnimated:NO];
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

- (void)addAdditionalControlsView{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"AdditionalControlsView"
                                                      owner:self
                                                    options:nil];
    
    self.additionalControlsView = [nibViews firstObject];
    CGRect bounds = self.additionalControlsContainerView.bounds;
    [self.additionalControlsView setFrame:bounds];
    [self.additionalControlsContainerView addSubview:self.additionalControlsView];
    
    self.additionalControlsView.delegate = self;
    [self.additionalControlsView layoutLoop:self.videoEditor.loop];
    
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


- (void)showAdditionalControlsAnimated:(BOOL)animated{
    
    float duration = animated ? 0.25 : 0.f;
    self.additionalControlsBottomConstraint.constant = 0.f;
    [UIView animateWithDuration:duration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (void)hideAdditionalControlsAnimated:(BOOL)animated{
    
    float duration = animated ? 0.25 : 0.f;
    self.additionalControlsBottomConstraint.constant = -self.additionalControlsContainerView.frame.size.height + 27.f;
    [UIView animateWithDuration:duration animations:^{
        
        [self.view layoutIfNeeded];
    }];
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
        
        Chord* nextChord = [self.lesson chordClosestToTime:currentTime];
        [self layoutChord:nextChord];
//        NSLog(@"nextChord = %@",nextChord);
        
#warning TEST
//        Chord* nextChord = [self.lesson chordNextToChord:self.currentChord];
//        if (nextChord)
//            [self layoutChord:nextChord];
        
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

- (void)didSeekNewTimePosition:(float)newTime{
    
    [self playFromTime:newTime/1000];
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
    [self.videoEditor setCurrentPlayerTime:playTime*1000];
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

#pragma mark - VideoEditorDelegate

- (void)didCancelCutVideoEditor:(VideoEditor*)videoEditor{
    [self.additionalControlsView deselectTimePointsButtons];
}

- (void)didDetectInvalidCutVideoEditor:(VideoEditor*)videoEditor{
    [self.additionalControlsView deselectTimePointsButtons];
}

- (void)didReachedEndingTimePointVideoEditor:(VideoEditor*)videoEditor{
    
    float startTimePoint = videoEditor.pointA / 1000;
    [self playFromTime:startTimePoint];
    
}

#pragma mark - AdditionalControlsViewDelegate

- (void)didTapCollapseAdditionalControls:(AdditionalControlsView*)additionalControlsView{
    
    [self hideAdditionalControlsAnimated:YES];
}

- (void)didTapExpandAdditionalControls:(AdditionalControlsView*)additionalControlsView{
    
    [self showAdditionalControlsAnimated:YES];
}

- (void)didTapLoopAdditionalControls:(AdditionalControlsView*)additionalControlsView{
    
    BOOL loop = self.videoEditor.loop;
    [self.videoEditor setLoop:!loop];
}

- (void)additionalControls:(AdditionalControlsView*)additionalControlsView didTapCutPoint:(CutPoint)cutPoint{
    
    float miliseconds = self.playerView.currentTime*1000;
    if (cutPoint == CutPointA) {
        [self.videoEditor setupTimePointA:miliseconds];
    } else{
        [self.videoEditor setupTimePointB:miliseconds];
    }
}

- (void)additionalControls:(AdditionalControlsView*)additionalControlsView didTapTimeDelay:(TimeDelay)timeDelay{
    
    
}

#pragma mark - Notifications

- (void)applicationWillResignActive:(NSNotification*)notification{
    
    [self stopSongVideo];
}

@end
