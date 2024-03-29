//
//  BaseViewController.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

//Melody
#define kOpenPlayYoutubeSegueID @"OpenPlayYoutubeSegue"
#define kMelodyLessonSegue @"MelodyLessonSegue"

//Learn
#define kScaleExercisesSegue  @"ScaleExercisesSegue"
#define kChordsSegue          @"ChordsSegue"
#define kCustomChordSegue     @"CustomChordSegue"
#define kChordExercisesSegue  @"ChordExercisesSegue"

#define kPickedExerciseSegue  @"PickedExerciseSegue"

//onboarding

#define kOpenFretxKitSegue  @"OpenFretxKitSegue"
#define kOpenVideoScreensSegue  @"OpenVideoScreensSegue"
#define kBLEConnectionSegue @"BLEConnectionSegue"
#define kLightsIndicatorsSegue @"LightsIndicatorsSegue"

@interface BaseViewController : UIViewController

//
//implement below methods in appropriate subclasses
/*
- (void)onSearchButton:(UIBarButtonItem*)sender;
 
- (void)onBackButton:(UIBarButtonItem*)sender;
*/

- (void)popViewController;

@end
