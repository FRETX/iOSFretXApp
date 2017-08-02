//
//  MIDIPlayer.h
//  FretX
//
//  Created by Developer on 8/2/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDIPlayer : NSObject

- (void)setupWithArrayOfMIDINotes:(NSArray<NSNumber*>*)notes;

- (void)playMIDI;

- (void)playArrayOfMIDINotes:(NSArray<NSNumber*>*)notes;

#pragma mark - Wav

- (void)playChimeBell;

@end
