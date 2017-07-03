//
//  Melody.m
//  FretX
//
//  Created by Developer on 6/28/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "Melody.h"

#import "SafeCategories.h"

@interface Melody ()
@property (strong) NSDateFormatter* dateFormatter;

@end

//Response example
/*
"youtube_id" = "0q1_AfQzcJM";
},
{
    artist = "Nick LeDuc";
    "created_at" = "2017-03-06T18:10:02.585Z";
    difficulty = "<null>";
    "fretx_id" = "0tsOIxDq-d8-132";
    genre = "<null>";
    id = 132;
    promotion = 0;
    published = 1;
    "song_title" = "New York City";
    title = "New York City";
    "updated_at" = "2017-03-06T20:35:12.630Z";
    "uploaded_by" = 49;
    "uploaded_on" = "2017-02-21T16:51:57.445Z";
    "youtube_id" = "0tsOIxDq-d8";
},
{
    artist = "Bob Dylan";
*/

@implementation Melody

- (id)init{
    self = [super init];
    if (self) {
        self.dateFormatter = [NSDateFormatter new];
        //"2017-03-06T18:10:02.585Z"
        self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    }
    return self;
}

- (void)setValuesWithInfo:(NSDictionary*)info{
    
    self.songName = [info safeStringObjectForKey:@"song_title"];
    self.artistName = [info safeStringObjectForKey:@"artist"];
    self.backendID = [info safeStringObjectForKey:@"id"];
    self.youtubeVideoId = [info safeStringObjectForKey:@"youtube_id"];
    self.fretxID = [info safeStringObjectForKey:@"fretx_id"];
    
    self.melodyTitle = [info safeStringObjectForKey:@"title"];
    
    NSString* creationDateString = [info safeStringObjectForKey:@"created_at"];
    self.creationDate = [self.dateFormatter dateFromString:creationDateString];
    
    NSNumber* published = [info safeNSNumberObjectForKey:@"published"];
    self.published = published.boolValue;
}

@end
