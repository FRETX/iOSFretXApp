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
 artist = "Taylor Swift";
 "created_at" = "2017-03-06T18:03:57.092Z";
 difficulty = "<null>";
 "fretx_id" = "zIOVMHMNfJ4-51";
 genre = "<null>";
 id = 51;
 promotion = 0;
 published = 1;
 "song_title" = "Shake It Off";
 title = "Shake It Off (With Lyrics) - Taylor Swift";
 "updated_at" = "2017-03-06T18:03:57.092Z";
 "uploaded_by" = 15;
 "uploaded_on" = "2016-11-16T10:39:42.837Z";
 "youtube_id" = zIOVMHMNfJ4;
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
    
    self.songTitle = [info safeStringObjectForKey:@"title"];
    
    NSString* creationDateString = [info safeStringObjectForKey:@"created_at"];
    self.creationDate = [self.dateFormatter dateFromString:creationDateString];
    
    NSNumber* published = [info safeNSNumberObjectForKey:@"published"];
    self.published = published.boolValue;
}

- (NSString*)description{
    
    NSString* description = [NSString stringWithFormat:@"%@. song=%@ published=%@ creationDate=%@",[super description], self.songName, self.published?@"YES":@"NO", self.creationDate];
    return description;
}

@end
