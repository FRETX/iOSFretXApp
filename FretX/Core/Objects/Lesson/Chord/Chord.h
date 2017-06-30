//
//  Chord.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FingerPosition;

@interface Chord : NSObject

//chord =             {
@property (strong) NSArray<FingerPosition*>* fingering;
@property (strong) NSString* chordName;
@property (strong) NSString* quality;
@property (strong) NSString* root;
@property (assign) int rootval;

@property (assign) unsigned long timeMs; //time_ms" = 0;

- (void)setValues:(NSDictionary*)info;

@property (assign) BOOL isEmpty;

@end
