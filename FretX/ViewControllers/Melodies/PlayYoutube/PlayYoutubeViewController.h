//
//  PlayYoutubeViewController.h
//  FretX
//
//  Created by Developer on 7/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@class Lesson;

@interface PlayYoutubeViewController : BaseViewController

- (void)setupLesson:(Lesson*)lesson;

@end
