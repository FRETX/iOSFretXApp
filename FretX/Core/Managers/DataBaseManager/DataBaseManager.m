//
//  DataBaseManager.m
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "DataBaseManager.h"

#import <Firebase/Firebase.h>

#import "User.h"

@interface DataBaseManager ()

@property (nonatomic, strong) User* user;
@property (nonatomic, strong) FIRDatabaseReference* databBaseRef;

@end

@implementation DataBaseManager

+ (instancetype)defaultManager{
    
    static DataBaseManager *dataBaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataBaseManager = [DataBaseManager new];
    });
    return dataBaseManager;
}

- (void)fetchUserWithBlock:(void(^)(BOOL status, User* user))block{
    
    NSString *currentUID = [[[FIRAuth auth] currentUser] uid];
    FIRDatabaseReference* dbRef = [[[[FIRDatabase database] reference] child: @"users"] child: currentUID];

    [dbRef observeSingleEventOfType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *userInfo = snapshot.value;
        
        if (!userInfo || [userInfo isEqual:[NSNull null]]) {
            if (block)
                block(NO,self.user);
            return;
        }
        
        if (!self.user) {
            User* user = [User new];
            self.user = user;
        }
        [self.user setValuesWithInfo:userInfo];

        if (block)
            block(YES,self.user);
    }];
}

- (void)saveUserScore:(NSString*)scoreValue forExerciseID:(NSString*)exerciseID{
    
    FIRDatabaseReference* dbRef = [self firebaseDBReference];
    FIRDatabaseReference* scoreRef = [dbRef child:@"score"];
    FIRDatabaseReference* exerciseRef = [scoreRef child:exerciseID];
    [exerciseRef setValue:scoreValue];
}

#pragma mark - Private

- (FIRDatabaseReference*)firebaseDBReference{
    
    if (!self.databBaseRef) {
        NSString *currentUID = [[[FIRAuth auth] currentUser] uid];
        FIRDatabaseReference* dbRef = [[[[FIRDatabase database] reference] child: @"users"] child: currentUID];
        self.databBaseRef = dbRef;
    }
    return self.databBaseRef;
}




@end
