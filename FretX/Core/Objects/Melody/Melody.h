//
//  Melody.h
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Melody : NSObject

@property (nonatomic, strong) NSString* songTitle;
@property (nonatomic, strong) NSString* songName;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSString* backendID;
@property (nonatomic, strong) NSString* youtubeVideoId;
@property (nonatomic, strong) NSString* fretxID;
@property (nonatomic, strong) NSDate* creationDate;
@property (nonatomic, assign) BOOL published;

- (void)setValuesWithInfo:(NSDictionary*)info;
    
@end
