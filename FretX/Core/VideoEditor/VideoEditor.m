//
//  VideoEditor.m
//  FretX
//
//  Created by Developer on 7/5/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "VideoEditor.h"

@interface VideoEditor ()

@property (assign) float currentTime;
@property (strong) NSNumber* timePointA;
@property (strong) NSNumber* timePointB;
@property (assign) BOOL looped;
@end

@implementation VideoEditor

#pragma mark - Lifecycle

+ (instancetype)initWithDelegate:(nullable id<VideoEditorDelegate>)delegate{
    
    VideoEditor* videoEditor = [VideoEditor new];
    if (videoEditor){
        videoEditor.delegate = delegate;
        videoEditor.delay = 0.f;
    }
    return videoEditor;
}

#pragma mark - Public

- (void)setCurrentPlayerTime:(float)currentPlayerTime{
    
    self.currentTime = currentPlayerTime;
    if (self.looped && self.timePointA && self.timePointB) {
        
        if (currentPlayerTime >= self.timePointB.floatValue) {
            [self notifyAboutEndOfTimeSnippet];
        }
    }
}

- (void)setupTimePointA:(float)timePointA{
    
    NSNumber* pointA = @(timePointA);
    if (self.timePointB && self.timePointB.floatValue <= timePointA) {
        [self notifyAboutInvalidCutting];
    } else{
        
        if (self.timePointA && self.timePointB)
            [self notifyAboutCutCancel];
        else
            self.timePointA = pointA;
    }
    
}

- (void)setupTimePointB:(float)timePointB{
    
    NSNumber* pointB = @(timePointB);
    if (self.timePointA && self.timePointA.floatValue >= timePointB) {
        [self notifyAboutInvalidCutting];
    } else{
        
        if (self.timePointA && self.timePointB)
            [self notifyAboutCutCancel];
        else
            self.timePointB = pointB;
    }
}

- (void)setLoop:(BOOL)looped{
    self.looped = looped;
    
    if (self.looped && self.timePointB && self.timePointB.floatValue <= self.currentTime ) {
        [self notifyAboutEndOfTimeSnippet];
    }
}

//- (void)setDelay:(float)delay{
//    
//    self.delay = delay;
//}

#pragma mark - Getters

- (BOOL)loop{
    
    return self.looped;
}

- (float)pointA{
    if (self.looped) {
        return self.timePointA.floatValue;
    } else{
        return 0;
    }
}

//- (float)pointB{
//    if (self.looped) {
//        return self.timePointB.floatValue;
//    } else{
//        return 0;
//    }
//}

#pragma mark - Notify delegate

//- (void)didCancelCutVideoEditor:(VideoEditor*)videoEditor;
//- (void)didDetectInvalidCutVideoEditor:(VideoEditor*)videoEditor;
//- (void)didReachedEndingTimePointVideoEditor:(VideoEditor*)videoEditor;


- (void)notifyAboutInvalidCutting{
    self.timePointA = nil;
    self.timePointB = nil;
    
    if ([self.delegate respondsToSelector:@selector(didDetectInvalidCutVideoEditor:)]) {
        [self.delegate didDetectInvalidCutVideoEditor:self];
    }
}

- (void)notifyAboutCutCancel{
    self.timePointA = nil;
    self.timePointB = nil;
    
    if ([self.delegate respondsToSelector:@selector(didCancelCutVideoEditor:)]) {
        [self.delegate didCancelCutVideoEditor:self];
    }
}

- (void)notifyAboutEndOfTimeSnippet{
    
    if ([self.delegate respondsToSelector:@selector(didReachedEndingTimePointVideoEditor:)]) {
        [self.delegate didReachedEndingTimePointVideoEditor:self];
    }
}

@end
