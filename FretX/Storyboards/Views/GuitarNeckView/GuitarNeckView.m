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


@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray<NSLayoutConstraint*> *dotsYCenterConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray<NSLayoutConstraint*> *dotsLeftConstraints;

@property (nonatomic, weak) IBOutlet UIImageView* fretImageView;
//@property (nonatomic, weak) IBOutlet UIImageView* dotImageView;//it's first dot

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

- (void)layoutChord:(SongPunch*)chord withLeftHanded:(BOOL)leftHanded{

    [self layoutChord:chord withPunchAnimation:YES withLeftHanded:(BOOL)leftHanded];
    
}

- (void)layoutChord:(SongPunch*)chord withPunchAnimation:(BOOL)enabled withLeftHanded:(BOOL)leftHanded{
    
    self.chord = chord;
    
    [self hideAllDots];
    
    if (!chord) {
        return;
    }
    
    
    //set horizontal positions
    [chord.fingering enumerateObjectsUsingBlock:^(FingerPosition * _Nonnull fingerPos, NSUInteger idx, BOOL * _Nonnull stop) {
        if(leftHanded){
            [self layoutDotImageForString:6-fingerPos.string fret:fingerPos.fret];
        } else {
            [self layoutDotImageForString:fingerPos.string fret:fingerPos.fret];
        }
        
    }];
    
    if (enabled)
        [self.fretsProgressView showAnimation];
    
    [self layoutIfNeeded];
    
}

#pragma mark - Private

- (void)layoutDotImageForString:(int)string fret:(int)fret{
    
    UIImageView* dot = [self dotImageViewForString:string fret:fret];
    dot.hidden = NO;
    dot.image = [self imageForFret:fret];
    
    //set left position
    NSLayoutConstraint* dotLeftConstraint = [self leftConstraintForString:string fret:fret];
    dotLeftConstraint.constant = [self leftSpacingForFret:fret];

    //adjust vertical
    NSLayoutConstraint* dotYCenterConstraint = [self centerYConstraintForString:string fret:fret];
    dotYCenterConstraint.constant = [self centerYPositionForString:string];
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

- (NSLayoutConstraint*)leftConstraintForString:(int)string fret:(int)fret{
    
    int wantedDotTag = [self dotTagForString:string fret:fret];
    
    __block NSLayoutConstraint* wantedCnstraint = nil;
    [self.dotsLeftConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (id item in @[constraint.firstItem, constraint.secondItem]) {
            if ([item isKindOfClass:[UIImageView class]]) {
                UIImageView* imageView = (UIImageView*)item;
                if (imageView.tag == wantedDotTag)
                    wantedCnstraint = constraint;
            }
        }
    }];

    return wantedCnstraint;
}

- (void)hideAllDots{
    [self.dotsImageViews enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull dotView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dotView.hidden = YES;
    }];
}

- (int)dotTagForString:(int)string fret:(int)fret{
    
    NSString* stringTag = [NSString stringWithFormat:@"%d%d",string,fret+1];
    return stringTag.intValue;
}

- (UIImageView*)dotImageViewForString:(int)string fret:(int)fret{
    
    UIImageView* result = nil;
    
    int wantedDotTag = [self dotTagForString:string fret:fret];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.tag == %d",wantedDotTag];
    NSArray* filteredArray = [self.dotsImageViews filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        result = filteredArray.firstObject;
    }
    return result;
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

- (NSLayoutConstraint*)centerYConstraintForString:(int)string fret:(int)fret{
  
    int wantedDotTag = [self dotTagForString:string fret:fret];
    
    __block NSLayoutConstraint* wantedCnstraint = nil;
    [self.dotsYCenterConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (id item in @[constraint.firstItem, constraint.secondItem]) {
            if ([item isKindOfClass:[UIImageView class]]) {
                UIImageView* imageView = (UIImageView*)item;
                if (imageView.tag == wantedDotTag)
                    wantedCnstraint = constraint;
            }
        }
    }];

    return wantedCnstraint;
}















@end
