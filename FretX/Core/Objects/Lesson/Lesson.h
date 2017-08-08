//
//  Lesson.h
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FretXAudioProcessing/FretXAudioProcessing-Swift.h>


@class SongPunch,Chord;

@interface Lesson : NSObject


@property (nonatomic, strong) NSString* melodyTitle;
@property (nonatomic, strong) NSString* songName;
@property (nonatomic, strong) NSString* backendID;
@property (nonatomic, strong) NSString* youtubeVideoId;
@property (nonatomic, strong) NSString* fretxID;
@property (strong) NSString* artistName;
@property(strong) NSArray<SongPunch*>* punches;

@property (strong) NSString* nextLessonYoutubeID;

- (void)setValuesWithInfo:(NSDictionary*)info;

- (SongPunch*)chordNextToChord:(SongPunch*)chord allowEmpty:(BOOL)allowEmpty;
- (SongPunch*)chordClosestToTime:(float)time;
- (NSArray<Chord *>*)getUniqueChords;
@end
