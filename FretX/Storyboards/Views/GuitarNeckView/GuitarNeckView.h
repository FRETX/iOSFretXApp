//
//  GuitarNeckView.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chord;

@interface GuitarNeckView : UIView

- (void)layoutChord:(Chord*)chord;

- (void)layoutDotImageForString:(int)string fret:(int)fret;

//left hand position
//self.labelShowdata.transform = CGAffineTransformMakeScale(-1., 1);

@end
