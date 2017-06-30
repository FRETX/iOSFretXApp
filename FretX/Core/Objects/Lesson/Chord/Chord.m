//
//  Chord.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "Chord.h"

#import "SafeCategories.h"

@implementation Chord

- (void)setValues:(NSDictionary*)info{
    
//    {
//        chord =             {
//            fingering =                 (
//                                         36,
//                                         25,
//                                         4,
//                                         3,
//                                         2,
//                                         31
//                                         );
//            name = "G Maj";
//            quality = Maj;
//            root = G;
//            rootval = 8;
//        };
//        "time_ms" = 795;
//    },

    NSDictionary* chord = [info safeDictionaryObjectForKey:@"chord"];
    self.chordName = [chord safeStringObjectForKey:@"name"];
    self.quality = [chord safeStringObjectForKey:@"quality"];
    self.root = [chord safeStringObjectForKey:@"root"];
    
    NSNumber* rootval = [chord safeNSNumberObjectForKey:@"rootval"];
    self.rootval = rootval.intValue;
    
    NSArray* fingering = [chord safeArrayObjectForKey:@"fingering"];
    self.fingering = fingering;
    
    if (fingering.count <= 0 ) {
        self.isEmpty = NO;
    }
    //
    NSNumber* time_ms = [info safeNSNumberObjectForKey:@"time_ms"];
    self.timeMs = time_ms.unsignedLongValue;
}

@end
