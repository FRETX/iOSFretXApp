//
//  RequestManager.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "RequestManager.h"

#import "SafeCategories.h"
#import "AFNetworking.h"
#import "Melody.h"
#import "Lesson.h"

#define ApiCall(urlFormat, arg) [NSString stringWithFormat: urlFormat, arg]

#define kBaseUrl @"http://player.fretx.rocks/api/v1/"

#define kAPI_AllSongs              @"songs/index.json" // http://player.fretx.rocks/api/v1/
#define kAPI_MelodyLesson(fertxID) ApiCall(@"songs/%@.json", fertxID)  //http://player.fretx.rocks/api/v1/  //  @"songs/<fretx_id>.json"

@interface RequestManager ()

@property (nonatomic, strong) AFHTTPSessionManager* manager;

@end

@implementation RequestManager

#pragma mark -

+ (instancetype)defaultManager{
    
    static RequestManager *requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        requestManager = [RequestManager new];
    });
    return requestManager;
}
- (id)init{
    
    self = [super init];
    if (self) {
//        self.manager = [AFHTTPSessionManager alloc];
    }
    return self;
}


- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
    
#warning TEST
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *accessToken = [userDefaults stringForKey:@"access_token"];
//    if (accessToken.length)
//        [_manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"token"];
//    else
//        [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    
    return _manager;
}

#pragma mark - Melodies

- (void)loadAllMelodiesWithBlock:(APIResultBlock)block{
    
    [self.manager GET:kAPI_AllSongs parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray<Melody*>* mutableResult = [@[] mutableCopy];
        NSArray<NSDictionary*>* melodiesInfos = [NSArray safeArrayWithArray:responseObject];
        [melodiesInfos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull melodyInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Melody* melody = [Melody new];
            [melody setValuesWithInfo:melodyInfo];
            if (melody.published)
                [mutableResult addObject:melody];
        }];
        
        NSArray<Melody*>* result = [NSArray arrayWithArray:mutableResult];
        if(block){
            block(result,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(block){
            block(nil,error);
        }
    }];
}


- (void)getLessonForMelody:(Melody*)melody withBlock:(APIResultBlock)block{
    
    if (melody.fretxID.length <= 0) {
        if(block)
            block(nil,nil);
        return;
    }

    [self.manager GET:kAPI_MelodyLesson(melody.fretxID) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* lessonInfo = [NSDictionary safeDictionaryWithDictionary:responseObject];
        Lesson* lesson = [Lesson new];
        [lesson setValuesWithInfo:lessonInfo];
        if(block){
            block(lesson,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(block){
            block(nil,error);
        }
    }];
}

@end
