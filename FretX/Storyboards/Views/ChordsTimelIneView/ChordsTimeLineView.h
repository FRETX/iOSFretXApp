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

/* start timeline movement */
- (void)move;

- (void)stop;

- (void)moveToChordAtIndex:(NSUInteger)index;

@end
