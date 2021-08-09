//
//  ItemCollectionCell.m
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ItemCollectionCell.h"

#define CellFont [UIFont systemFontOfSize:22.f]

@interface ItemCollectionCell ()

@property (weak) IBOutlet UILabel* itemLabel;

@end

@implementation ItemCollectionCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.itemLabel.font = CellFont;
}

- (void)setupItemLabel:(NSString*)itemName selected:(BOOL)selected{
    
    self.itemLabel.attributedText = [self attributedText:itemName forState:selected];
    
}

+ (UIFont*)cellFont{
    return CellFont;
}

+ (float)cellTextInset{
    return 15.f;
}

+ (NSDictionary*)attributesForSelected:(BOOL)selected{
    NSDictionary* result = nil;
    if (selected) {
        result = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                   NSForegroundColorAttributeName: [UIColor whiteColor],
                   NSFontAttributeName : [ItemCollectionCell cellFont]};
    } else{
        result = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                   NSFontAttributeName: [ItemCollectionCell cellFont]};
    }
    return result;
}

#pragma mark - Private

- (NSAttributedString*)attributedText:(NSString*)title forState:(BOOL)selected{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:[ItemCollectionCell attributesForSelected:selected]];
    
    return attributedString;
}

@end
