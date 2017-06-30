//
//  MelodyChordsViewController.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "MelodyChordsViewController.h"

//#import "Melody.h"
#import "GuitarNeckView.h"
#import "RequestManager.h"
#import "Lesson.h"
#import "Chord.h"

@interface MelodyChordsViewController ()

//UI
@property (nonatomic, weak) IBOutlet UILabel* melodyFullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentChordLabel;
@property (nonatomic, weak) IBOutlet UILabel* nextChordLabel;
@property (nonatomic, weak) IBOutlet UIView* fretsContainerView;
@property (nonatomic, weak) GuitarNeckView* guitarNeckView;
//Data
@property (strong, nonatomic) Lesson* lesson;
@property (strong) Chord* currentChord;
@end

@implementation MelodyChordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layout];
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

- (void)layout{
    
    [self.view layoutIfNeeded];
    [self layoutLesson:self.lesson];
    [self addFretBoard];
}

#pragma mark - Public

- (void)setupLesson:(Lesson*)lesson{
    
    self.lesson = lesson;
}

- (void)layoutLesson:(Lesson*)lesson{
    
    self.melodyFullNameLabel.text = lesson.melodyTitle;
    self.currentChordLabel.text =  lesson.punches[0].chordName;// self.currentChord.chordName;
    self.nextChordLabel.text = lesson.punches[1].chordName;
}

//- (void)layoutChordForLesson:(Lesson*)lesson{
//    
//    self.currentChord = lesson.punches[0];
//}

#pragma mark - Private

- (void)addFretBoard{
  
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"GuitarNeckView"
                                                      owner:self
                                                    options:nil];
    
    self.guitarNeckView = [nibViews firstObject];
    CGRect frame = self.fretsContainerView.frame;
    frame.origin.y = 0;
    [self.guitarNeckView setFrame:frame];
    [self.fretsContainerView addSubview:self.guitarNeckView];
    
}









@end
