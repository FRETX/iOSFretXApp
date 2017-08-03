//
//  User.h
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HandTypeRight,
    HandTypeLeft
}HandType;

typedef enum{
    GuitarTypeClassical,
    GuitarTypeElectric,
    GuitarTypeAcoustic
}GuitarType;

typedef enum{
    SkillTypeBegginer,
    SkillTypePlayer
}SkillType;

@interface User : NSObject

@property (nonatomic, assign) HandType handType;
@property (nonatomic, assign) GuitarType guitarType;
@property (nonatomic, assign) SkillType skillType;

@property (nonatomic, strong) NSDictionary* scores;
@property (nonatomic, assign) NSUInteger exercisesPassed;

- (void)setValuesWithInfo:(NSDictionary*)values;

@end
