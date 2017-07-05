//
//  ChordsTimeLineView.h
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chord;

@interface ChordsTimeLineView : UIView

- (void)setupWithDuration:(float)duration chords:(NSArray<Chord*>*)chords;

- (void)move;

- (void)stop;

@end
