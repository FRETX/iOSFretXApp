//
//  SongPunch+AudioProcessing.h
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "SongPunch.h"

@class Chord,Scale;

@interface SongPunch (AudioProcessing)

+ (instancetype)initScaleWithRoot:(NSString*)root type:(NSString*)type;

//+ (instancetype)initWithAudioChord:(Chord*)chord root:(NSString*)root type:(NSString*)type;

+ (instancetype)initChordWithRoot:(NSString*)root type:(NSString*)type;

- (NSArray<NSNumber*>*)getMIDINotes;

@end
