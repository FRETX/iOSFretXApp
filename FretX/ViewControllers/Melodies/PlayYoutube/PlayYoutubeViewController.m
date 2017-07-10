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
#import "CompletionPopupView.h"
#import "ChordsTimeLineView.h"
#import "PlayerControlsView.h"
#import "UIView+Activity.h"
#import "GuitarNeckView.h"
#import "ContentManager.h"
#import "YTPlayerView.h"
#import "VideoEditor.h"
#import "Lesson.h"
#import "SongPunch.h"
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
#import <FretXBLE/FretXBLE-Swift.h>

#import "UIImageView+AFNetworking.h"

@interface PlayYoutubeViewController () <YTPlayerViewDelegate, PlayerControlsViewDelegate,
AdditionalControlsViewDelegate, VideoEditorDelegate, CompletionPopupViewDelegate>

//ui
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* indicatorView;
@property (nonatomic, weak) IBOutlet UIView* videoContainerView;
@property (nonatomic, weak) IBOutlet UIImageView* thumbImageView;

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

@property (nonatomic, weak) CompletionPopupView* completionPopupView;

@property (weak) IBOutlet NSLayoutConstraint* additionalControlsBottomConstraint;

@property (nonatomic, weak) IBOutlet UILabel* testChordNameLabel;

//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong) SongPunch* currentChord;
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

    [self.playerView pauseVideo];
    [self.playerView seekToSeconds:time/1000 allowSeekAhead:YES];
    
#warning TEST
    SongPunch* nextChord = [self.lesson chordClosestToTime:time];
    NSLog(@"playFromTime nextChord = %@",nextChord);
    [self layoutChord:nextChord];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resumeSongVideo];
    });
}

- (float)currentTime{
    
    float delay = self.videoEditor.delay;
    float currentTime = self.playerView.currentTime*1000 + delay;
    return currentTime;
}

#pragma mark - Update all controls

- (void)layoutStartPlayingVideoLesson{
    
    float currentTime = [self currentTime];

    [self.timeLineView moveToTime:currentTime];
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
    [self addCompletionPopupView];

    [self layoutLesson:self.lesson];
    
    //layout video thumb
    NSString * youtubeID = self.lesson.youtubeVideoId;
    NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youtubeID]];
    [self.thumbImageView setImageWithURL:youtubeURL placeholderImage:[UIImage imageNamed:@"DefaultThumb"]];
    
    //setup player
    [self setupPlayerView];
    
    //initilly hide advance controls
    static BOOL additionalControlsAnimated = NO;
    [self hideAdditionalControlsAnimated:NO];
    additionalControlsAnimated = YES;
}

- (void)layoutLesson:(Lesson*)lesson{
    
    self.songFullNameLabel.text = lesson.melodyTitle;
//    if (lesson.punches.count > 0) {
//        
//        [self layoutChord:lesson.punches[0]];
//    }
}

- (void)layoutChord:(SongPunch*)chord{
    
    self.currentChord = chord;
    
#warning TEST
    self.testChordNameLabel.text = chord.chordName;
    
    [self.guitarNeckView layoutChord:self.currentChord];
    
    Chord *tmpChord = [[Chord alloc] initWithRoot:self.currentChord.root type:self.currentChord.quality];
    [FretxBLE.sharedInstance sendWithFretCodes:[MusicUtils getBluetoothArrayFromChordWithChordName:tmpChord.name]];
}

- (void)addFretBoard{
    
    if (self.guitarNeckView) {
        [self.guitarNeckView removeFromSuperview];
    }
    
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
    
    if (self.playerControlsView) {
        [self.playerControlsView removeFromSuperview];
    }
    
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
    
    if (self.timeLineView) {
        [self.timeLineView removeFromSuperview];
    }
    
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
    
    if (self.additionalControlsView) {
        [self.additionalControlsView removeFromSuperview];
    }
    
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

- (void)addCompletionPopupView{
    
    if (self.completionPopupView) {
        [self.completionPopupView removeFromSuperview];
    }
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CompletionPopupView"
                                                      owner:self
                                                    options:nil];
    
    self.completionPopupView = [nibViews firstObject];
    [self.completionPopupView hideCompletionPopupAnimated:NO];
    CGRect bounds = self.view.bounds;
    [self.completionPopupView setFrame:bounds];
    [self.view addSubview:self.completionPopupView];
    
    self.completionPopupView.delegate = self;
    
    [self.completionPopupView setupWithSongName:self.lesson.songName nextVideoLessonYoutubeID:self.lesson.nextLessonYoutubeID];
    
    [self.view layoutIfNeeded];
}

#pragma mark -

- (void)setupPlayerView{

    [self.indicatorView startAnimating];
    
    self.playerView.delegate = self;
    
    NSDictionary* playerParams = @{
                                   @"controls"    : @0,
                                   @"autoplay"    : @1,
                                   @"fs"          : @0,
                                   @"showinfo"    : @0,
                                   @"playsinline" : @1};
    
    NSString* videoID = self.lesson.youtubeVideoId;
    [self.playerView loadWithVideoId:videoID playerVars:playerParams];
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onFiredChordsTimer:) userInfo:nil repeats:YES];
}

- (void)stopChordsTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onFiredChordsTimer:(NSTimer*)timer{
    
    float currentTime = [self currentTime];
    
    SongPunch* nextChord = [self.lesson chordClosestToTime:currentTime];
    if (nextChord && (nextChord.index > self.currentChord.index || !self.currentChord))
        [self layoutChord:nextChord];
    
    return;
    
//    BOOL timeToFirstChord = !self.currentChord && currentTime >= self.lesson.punches.firstObject.timeMs;
//    BOOL timeToNextChord = self.currentChord && currentTime >= self.currentChord.timeMs;
//    BOOL needToStopTimer = self.playerView.playerState != kYTPlayerStatePlaying;
//    
//    BOOL layoutNextChord = timeToFirstChord || timeToNextChord;
//    if (layoutNextChord) {
//        
//        Chord* nextChord = [self.lesson chordClosestToTime:currentTime];
//        if (nextChord)
//            [self layoutChord:nextChord];
//
//    }
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
    
    if (newTime > (self.playerView.duration * 1000)*0.99 ) {
        [self playFromTime: (self.playerView.duration * 1000)*0.999];
    } else{
        [self playFromTime:newTime];
    }
}

#pragma mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView{
    
    [self.indicatorView stopAnimating];
#warning TEST
    self.playerView.hidden = NO;
    NSLog(@"playerViewDidBecomeReady");
    [self.timeLineView setupWithDuration:self.playerView.duration*1000 chords:self.lesson.punches];
    [self.playerControlsView setupWithDuration:playerView.duration*1000];
    [self playSongVideo];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didPlayTime:(float)playTime{

    [self.playerControlsView setupCurrentTime:playTime*1000];
    [self.videoEditor setCurrentPlayerTime:playTime*1000];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    
    if (state == kYTPlayerStatePlaying) {
        [self layoutStartPlayingVideoLesson];
    } else {
        [self layoutStopPlayingVideoLesson];
    }
    
    if (state == kYTPlayerStateEnded) {
#warning TEST
        [self layoutChord:nil];
        [self.completionPopupView showCompletionPopupAnimated:YES];
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
    
    float startTimePoint = videoEditor.pointA;
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
    
    float videoDelay = 0;
    switch (timeDelay) {
        case TimeDelayNone:
            videoDelay = 0;
            break;
        case TimeDelayQuarterSecond:
            videoDelay = 250;
            break;
        case TimeDelayHalfSecond:
            videoDelay = 500;
            break;
        case TimeDelayOneSecond:
            videoDelay = 1000;
            break;
        default:
            break;
    }
    self.videoEditor.delay = videoDelay;
    [self.timeLineView setupChordsAdvance:videoDelay];
}

#pragma mark - CompletionPopupViewDelegate

- (void)didTapReplayCompletionPopup:(CompletionPopupView*)completionPopupView{
    [self.completionPopupView hideCompletionPopupAnimated:YES];
    [self playFromTime:0];
}

- (void)didTapBackCompletionPopup:(CompletionPopupView*)completionPopupView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapPlayAnotherCompletionPopup:(CompletionPopupView*)completionPopupView{
    
    [self.completionPopupView hideCompletionPopupAnimated:YES];
    
    [self.view showActivity];
    __weak typeof(self) weakSelf = self;
    [[ContentManager defaultManager] nextLessonForLesson:self.lesson withBlock:^(Lesson *lesson, NSError *error) {
        [weakSelf.view hideActivity];
        
        if (lesson) {
            [weakSelf setupLesson:lesson];
            [weakSelf layout];
        }
    }];
}

#pragma mark - Notifications

- (void)applicationWillResignActive:(NSNotification*)notification{
    
    [self stopSongVideo];
}

@end
