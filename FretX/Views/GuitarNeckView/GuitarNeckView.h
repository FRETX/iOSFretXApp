//
//  GuitarNeckView.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongPunch;

@interface GuitarNeckView : UIView

- (void)layoutChord:(SongPunch*)chord;
- (void)layoutChord:(SongPunch*)chord withPunchAnimation:(BOOL)enabled;

- (void)layoutDotImageForString:(int)string fret:(int)fret;

//left hand position
//self.labelShowdata.transform = CGAffineTransformMakeScale(-1., 1);
//- (void)setPunchAnimationEnabled:(BOOL)enabled;
@end
