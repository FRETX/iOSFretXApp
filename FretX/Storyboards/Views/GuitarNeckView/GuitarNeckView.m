//
//  GuitarNeckView.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "GuitarNeckView.h"

#import "Chord.h"
#import "FingerPosition.h"

#define StringsCount 6
#define VisibleFretsNumber 4

@interface GuitarNeckView ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot1YCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot2YCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot3YCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot4YCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot5YCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot6YCenterConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot1LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot2LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot3LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot4LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot5LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot6LeftConstraint;

@property (nonatomic, weak) IBOutlet UIImageView* fretImageView;
@property (nonatomic, weak) IBOutlet UIImageView* dotImageView;//it's first dot

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *dotsImageViews;

//@property (nonatomic, weak) IBOutletCollection(UIImageView) *dotsImageViews;
@end

@implementation GuitarNeckView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public

- (void)layoutChord:(Chord*)chord{
    
    [self.dotsImageViews enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull dotView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dotView.hidden = YES;
    }];
    
    
    [chord.fingering enumerateObjectsUsingBlock:^(FingerPosition * _Nonnull fingerPos, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        [self layoutDotImageForString:fingerPos.string fret:fingerPos.fret];
    }];
    [self layoutIfNeeded];
}

#pragma mark -

- (void)layoutDotImageForString:(int)string fret:(int)fret{
    
    UIImageView* dot = [self viewWithTag:string];
    dot.hidden = NO;
    dot.image = [self imageForFret:fret];
    //set position
    NSLayoutConstraint* dotLeftConstraint = [self constraintForString:string];
    dotLeftConstraint.constant = [self leftSpacingForFret:fret];
//    [self layoutIfNeeded];
}

- (UIImage*)imageForFret:(int)fret{
    UIImage* image;
    if (fret > 0) {
        image = [UIImage imageNamed:@"RedDotIcon"];
    } else{
        image = [UIImage imageNamed:@"BlueDotIcon"];
    }
    return image;
}

- (float)leftSpacingForFret:(int)fret{
    
    float leftSpaing = 0;
    if (fret > 0) {
        float fretWidth = self.fretImageView.frame.size.width / VisibleFretsNumber;
        leftSpaing = fret * fretWidth;
        leftSpaing = leftSpaing - leftSpaing/2 - self.dotImageView.frame.size.width/2;
        leftSpaing = leftSpaing + self.fretImageView.frame.origin.x;
    }
    return leftSpaing;
}

- (NSLayoutConstraint*)constraintForString:(int)string{
    
    switch (string) {
        case 1:
            return self.dot1LeftConstraint;
            break;
        case 2:
            return self.dot2LeftConstraint;
            break;
        case 3:
            return self.dot3LeftConstraint;
            break;
        case 4:
            return self.dot4LeftConstraint;
            break;
        case 5:
            return self.dot5LeftConstraint;
            break;
        case 6:
            return self.dot6LeftConstraint;
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - Vertical Position

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    for (int i = 1; i <= StringsCount; i++) {
        
        NSLayoutConstraint* dotYCenterConstraint = [self constraintForString:i];
        dotYCenterConstraint.constant = [self centerYPositionForString:i];
    }
}

- (float)centerYPositionForString:(int)string{
    
    float height = self.bounds.size.height;
    float stringIntervalHeight = height / StringsCount;
    float centerYPosition = 0;

    centerYPosition = string * stringIntervalHeight;
    centerYPosition = centerYPosition - centerYPosition/2 - self.dotImageView.frame.size.width/2;
    centerYPosition = centerYPosition + self.fretImageView.frame.origin.y;
    
    return centerYPosition;
}

- (NSLayoutConstraint*)centerYConstrintForDot:(int)dotIndex{
    
//    dot1YCenterConstraint
//    dot2YCenterConstraint
//    dot3YCenterConstraint
//    dot4YCenterConstraint
//    dot5YCenterConstraint
//    dot6YCenterConstraint
    switch (dotIndex) {
        case 1:
            return self.dot1YCenterConstraint;
            break;
        case 2:
            return self.dot2YCenterConstraint;
            break;
        case 3:
            return self.dot3YCenterConstraint;
            break;
        case 4:
            return self.dot4YCenterConstraint;
            break;
        case 5:
            return self.dot5YCenterConstraint;
            break;
        case 6:
            return self.dot6YCenterConstraint;
            break;
            
        default:
            break;
    }
    return nil;
}















@end
