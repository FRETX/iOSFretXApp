//
//  VideoEditor.h
//  FretX
//
//  Created by Developer on 7/5/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoEditor;

@protocol VideoEditorDelegate <NSObject>

- (void)didCancelCutVideoEditor:(VideoEditor*)videoEditor;
- (void)didDetectInvalidCutVideoEditor:(VideoEditor*)videoEditor;
- (void)didReachedEndingTimePointVideoEditor:(VideoEditor*)videoEditor;

@end

@interface VideoEditor : NSObject

@property (weak) id<VideoEditorDelegate> delegate;

@property (assign,readonly) BOOL loop;
@property (assign,readonly) float pointA;

+ (instancetype)initWithDelegate:(nullable id<VideoEditorDelegate>)delegate;

- (void)setCurrentPlayerTime:(float)currentPlayerTime;
- (void)setupTimePointA:(float)timePointA;
- (void)setupTimePointB:(float)timePointB;
- (void)setLoop:(BOOL)looped;


@end
