//
//  FretsProgressView.h
//  FretX
//
//  Created by Developer on 7/3/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ProgressViewStyleDefault,
    ProgressViewStyleWide
}ProgressViewStyle;

@interface FretsProgressView : UIView

- (void)setupProgress:(float)progressValue;

- (void)setupStyle:(ProgressViewStyle)progressViewStyle;

- (void)showAnimation;

@end
