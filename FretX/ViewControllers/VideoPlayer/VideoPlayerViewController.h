//
//  VideoPlayerViewController.h
//  FretX
//
//  Created by Developer on 8/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoPlayerViewController : BaseViewController

- (void)playOnTargetController:(UIViewController*)controller
                youtubeVideoID:(NSString*)youtubeVideoID
                    completion:(void(^)(void))completion;

@end
