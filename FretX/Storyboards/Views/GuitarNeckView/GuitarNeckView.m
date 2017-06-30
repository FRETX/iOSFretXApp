//
//  GuitarNeckView.m
//  FretX
//
//  Created by Developer on 6/29/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "GuitarNeckView.h"

#define VisibleFretsNumber 4

@interface GuitarNeckView ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot1LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot2LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot3LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot4LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot5LeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* dot6LeftConstraint;

@property (nonatomic, weak) IBOutlet UIImageView* fretImageView;
@property (nonatomic, weak) IBOutlet UIImageView* dotImageView;
@end

@implementation GuitarNeckView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -

- (void)layoutDotImageForString:(int)string fret:(int)fret{
    
    UIImageView* dot = [self viewWithTag:string];
    dot.image = [self imageForFret:fret];
    //set position
    NSLayoutConstraint* dotLeftConstraint = [self constraintForString:string];
    dotLeftConstraint.constant = [self leftSpacingForFret:fret];
    [self layoutIfNeeded];
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

#pragma mark - Actions



@end
