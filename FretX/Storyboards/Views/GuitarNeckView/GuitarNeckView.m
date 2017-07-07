//
//  GuitarNeckView.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "GuitarNeckView.h"

#import "SongPunch.h"
#import "FingerPosition.h"
#import "FretsProgressView.h"

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

@property (nonatomic, weak) IBOutlet UIView* progressContainerView;
@property (nonatomic, strong) FretsProgressView* fretsProgressView;

//Data
@property (strong) SongPunch* chord;

@end

@implementation GuitarNeckView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self layoutIfNeeded];
    [self addFretsProgressView];
    
    if (!self.chord)
        [self hideAllDots];
}

- (void)addFretsProgressView{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"FretsProgressView"
                                                      owner:self
                                                    options:nil];
    
    self.fretsProgressView = [nibViews firstObject];
    
    CGRect bounds = [self boundsFromContainer];//self.progressContainerView.bounds;
    [self.fretsProgressView setFrame:bounds];
    [self.progressContainerView addSubview:self.fretsProgressView];
    [self.fretsProgressView setupStyle:ProgressViewStyleVertical];
    
    [self rotateProgressView];
    
    [self layoutIfNeeded];
    
}

- (CGRect)boundsFromContainer{

    CGRect bounds = CGRectMake(-self.progressContainerView.bounds.size.height/2 + self.progressContainerView.bounds.size.width/2,
                               self.progressContainerView.bounds.size.height/2 - self.progressContainerView.bounds.size.width/2,
                               self.progressContainerView.bounds.size.height,
                               self.progressContainerView.bounds.size.width);

    return bounds;
}

- (void)rotateProgressView{
    
    self.fretsProgressView.transform = CGAffineTransformMakeRotation(M_PI / 2);

}

#pragma mark - Public

- (void)layoutChord:(SongPunch*)chord{

    self.chord = chord;

    [self hideAllDots];
    
    if (!chord) {
        return;
    }

    //set horizontal positions
    [chord.fingering enumerateObjectsUsingBlock:^(FingerPosition * _Nonnull fingerPos, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self layoutDotImageForString:fingerPos.string fret:fingerPos.fret];
    }];

    
    //adjust vertical
    for (int i = 1; i <= StringsCount; i++) {
        
        NSLayoutConstraint* dotYCenterConstraint = [self centerYConstrintForDot:i];
        dotYCenterConstraint.constant = [self centerYPositionForString:i];
    }
    
    [self.fretsProgressView showAnimation];
    
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
        float fretWidth = (self.fretImageView.frame.size.width )/ VisibleFretsNumber;
        leftSpaing = fret * fretWidth;
        leftSpaing = leftSpaing - fretWidth/2;//- self.dotImageView.frame.size.width/2;
        leftSpaing = leftSpaing - self.fretImageView.frame.origin.x;
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

- (void)hideAllDots{
    [self.dotsImageViews enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull dotView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dotView.hidden = YES;
    }];
}

#pragma mark - Vertical Position

//- (void)setFrame:(CGRect)frame{
//    [super setFrame:frame];
//
//}

- (float)centerYPositionForString:(int)string{
    
    float height = self.fretImageView.frame.size.height * 0.957;
    float stringIntervalHeight = height / StringsCount;
    float centerYPosition = 0;

    centerYPosition = string * stringIntervalHeight;
//    centerYPosition = centerYPosition - stringIntervalHeight/2 - self.dotImageView.frame.size.width/2;
//    centerYPosition = centerYPosition + self.fretImageView.frame.origin.y;
    
    if (string > (StringsCount/2)) {
        centerYPosition = (string - 4) * stringIntervalHeight + stringIntervalHeight/2;
//        centerYPosition = centerYPosition - self.dotImageView.frame.size.height/16;
        
//        centerYPosition = centerYPosition - abs((string - 1) * 3);
    } else {
        centerYPosition = (string - 3) * stringIntervalHeight - stringIntervalHeight/2;
//        centerYPosition = centerYPosition + self.dotImageView.frame.size.height/16;
        
        centerYPosition = centerYPosition + abs(((string - 3)) * 3);
    }
    
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
