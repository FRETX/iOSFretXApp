//
//  ChordCollectionViewCell.m
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ChordCollectionViewCell.h"

@interface ChordCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIView* roundedView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@end

@implementation ChordCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.roundedView.layer.cornerRadius = self.roundedView.frame.size.width/2;
    self.roundedView.layer.borderWidth = 5.f;
    self.roundedView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setupWithChordName:(NSString*)chordName selected:(BOOL)isSelected{
    
    self.nameLabel.text = chordName;
    
    [self setSelected:isSelected];
}

- (void)setSelected:(BOOL)selected{
    
    UIColor *color = selected ? [UIColor colorWithRed:27/255.f green:167/255.f blue:162/255.f alpha:1.0f] : [UIColor colorWithRed:240/255.f green:183/255.f blue:28/255.f alpha:1.0f];
    self.roundedView.backgroundColor = color;
}

@end
