//
//  FingerPosition.m
//  FretX
//
//  Created by Developer on 6/30/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "FingerPosition.h"

@implementation FingerPosition

+ (instancetype)initWith:(NSNumber*)number{
    
    FingerPosition* fingerPosition = [FingerPosition new];
    fingerPosition.string = [FingerPosition stringWithNumber:number];
    fingerPosition.fret = [FingerPosition fretWithNumber:number];
    
    return fingerPosition;
}

+ (int)stringWithNumber:(NSNumber*)number{
    
    if (number.stringValue.length > 1) {
        NSString* string = [number.stringValue substringFromIndex:1];
        return string.intValue;
    } else{
        return 0;
    }
}

+ (int)fretWithNumber:(NSNumber*)number{
    
    if (number.stringValue.length > 1) {
        NSString* string = [number.stringValue substringToIndex:1];
        return string.intValue;
    } else{
        return 0;
    }
}

@end
