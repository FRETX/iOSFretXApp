//
//  ChordCollectionViewCell.h
//  FretX
//
//  Created by Developer on 7/4/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChordCollectionViewCell : UICollectionViewCell

- (void)setupWithChordName:(NSString*)chordName selected:(BOOL)isSelected;

- (void)setSelected:(BOOL)selected;

@end
