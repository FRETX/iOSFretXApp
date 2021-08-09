//
//  ItemCollectionCell.h
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionCell : UICollectionViewCell

- (void)setupItemLabel:(NSString*)itemName selected:(BOOL)selected;
+ (UIFont*)cellFont;
+ (float)cellTextInset;

+ (NSDictionary*)attributesForSelected:(BOOL)selected;
@end
