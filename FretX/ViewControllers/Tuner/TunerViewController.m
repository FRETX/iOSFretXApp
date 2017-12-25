//
//  TunerViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "TunerViewController.h"
#import "TunerBarView.h"
#import <FretXBLE/FretXBLE-Swift.h>
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
@import FirebaseAnalytics;

typedef enum {
    StringTypNone = 0,
    StringTypeA,
    StringTypeB,
    StringTypeD,
    StringTypeG,
    StringTypeELeft,
    StringTypeERight
}StringType;

@interface TunerViewController ()

@property (weak) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet TunerBarView *tunerBarView;

@property NSTimer* timer;
@end

@implementation TunerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupString:StringTypeELeft];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [FretxBLE.sharedInstance clear];
    [Audio.shared start];
    _timer = [NSTimer timerWithTimeInterval:0.01f target:self selector:@selector(updatePitch) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void) viewDidAppear:(BOOL)animated{
    printf("Tuner Tab\n");
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:@"Tuner",
                                     kFIRParameterItemName:@"Tuner",
                                     kFIRParameterContentType:@"TAB"
                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
//    [Audio.shared stop];
    [Audio.shared stopListening];
}

-(void) updatePitch{
//    NSLog(@"updating pitch");
    [_tunerBarView setPitch:[Audio.shared getPitch]];
//    [_tunerBarView setNeedsDisplay];
//    NSLog(@"pitch: %f",[Audio.shared getPitch]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 

- (UIImage*)imageForString:(StringType)stringType{
    
    NSString* imageName = @"EmptyGuitarHeadBG";
    UIImage* image = nil;
    switch (stringType) {
        case StringTypeA:
            imageName = @"A";
            break;
        case StringTypeB:
            imageName = @"B";
            break;
        case StringTypeD:
            imageName = @"D";
            break;
        case StringTypeG:
            imageName = @"G";
            break;
        case StringTypeELeft:
            imageName = @"Eleft";
            break;
        case StringTypeERight:
            imageName = @"Eright";
            break;
            
        default:
            break;
    }
    image = [UIImage imageNamed:imageName];
    return image;
}

- (void)setupString:(StringType)stringType{
    
    UIImage* image = [self imageForString:stringType];
    self.imageView.image = image;
    //Set the TunerBarView parameters
    //Fixed for Standard Tuning
    NSInteger tuningMidiNotes[] = {40,45,50,55,59,64};
    int tuningIndex = 0;
    switch (stringType) {
        case StringTypeELeft:
            tuningIndex = 0;
            break;
        case StringTypeA:
            tuningIndex = 1;
            break;
        case StringTypeD:
            tuningIndex = 2;
            break;
        case StringTypeG:
            tuningIndex = 3;
            break;
        case StringTypeB:
            tuningIndex = 4;
            break;
        case StringTypeERight:
            tuningIndex = 5;
            break;
        default:
            break;
    }
    float targetPitch = [MusicUtils midiNoteToHzWithNote:tuningMidiNotes[tuningIndex]];
    float HALF_PITCH_RANGE_IN_CENTS = 100;
    float leftPitch = [MusicUtils centToHzWithCent:([MusicUtils hzToCentWithHz:targetPitch] - HALF_PITCH_RANGE_IN_CENTS)];
    float rightPitch = [MusicUtils centToHzWithCent:([MusicUtils hzToCentWithHz:targetPitch] + HALF_PITCH_RANGE_IN_CENTS)];
    [_tunerBarView setTargetPitch:targetPitch leftPitch:leftPitch rightPitch:rightPitch];
}

#pragma mark - Actions

- (IBAction)onStringSetButton:(UIButton*)sender{
    
    StringType stringType = (StringType)sender.tag;
    [self setupString:stringType];
}

@end
