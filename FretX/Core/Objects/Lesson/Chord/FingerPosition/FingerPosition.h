//
//  FingerPosition.h
//  FretX
//
//  Created by Developer on 6/30/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FingerPosition : NSObject

@property (nonatomic, assign) int string;
@property (nonatomic, assign) int fret;

+ (instancetype)initWith:(NSNumber*)number;

@end
