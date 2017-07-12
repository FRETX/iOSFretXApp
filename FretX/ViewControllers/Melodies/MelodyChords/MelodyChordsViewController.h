//
//  MelodyChordsViewController.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>
@class Lesson;

@interface MelodyChordsViewController : BaseViewController


- (void)setupLesson:(Lesson*)lesson;

@end
