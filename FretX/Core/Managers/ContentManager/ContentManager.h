//
//  ContentManager.h
//  FretX
//
//  Created by Developer on 7/7/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Lesson,Melody;

@interface ContentManager : NSObject

+ (instancetype)defaultManager;

//@property (copy) void(^tapNextVideoForSelectedBlock)(Lesson* currentLesson);

- (void)getAllSongsWithBlock:(void(^)(NSArray<Melody*>* result, NSError *error))block;

- (void)getLessonForSong:(Melody*)song withBlock:(void(^)(Lesson* lesson, NSError *error))block;

- (void)nextLessonForLesson:(Lesson*)currentLesson withBlock:(void(^)(Lesson* lesson, NSError *error))block;

- (void)searchSongsForTitle:(NSString*)title withBlock:(void(^)(NSArray<Melody*>* result, NSError *error))block;

@end
