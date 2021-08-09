//
//  ItemsCollectionView.m
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import "ItemsCollectionView.h"

#import "ItemCollectionCell.h"

#define CellID @"ItemCollectionCell"

@interface ItemsCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

//ui
@property (weak) IBOutlet UICollectionView* collectionView;

//data
@property (strong) NSArray<NSString*>* content;
@property (assign) NSUInteger selectedIndex;

@end

@implementation ItemsCollectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionCell" bundle:nil] forCellWithReuseIdentifier:CellID];
}

- (void)drawRect:(CGRect)rect {

    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionCell" bundle:nil] forCellWithReuseIdentifier:CellID];
    self.selectedIndex = 0;
    
    [self.collectionView reloadData];
}

#pragma mark - Public

- (void)setupWithContent:(NSArray<NSString*>*)content delegate:(id<ItemsCollectionViewDelegate>)delegate{
    self.delegate = delegate;
    self.content = content;
    [self.collectionView reloadData];
}

#pragma mark - private

- (float)cellWidthForIndex:(NSUInteger)index{
    
    NSString* title = self.content[index];
    CGSize textSize = [title sizeWithAttributes:[ItemCollectionCell attributesForSelected:self.selectedIndex==index]];
    
    float width = textSize.width + [ItemCollectionCell cellTextInset]*2;
    return width;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.content.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellID = CellID;
    ItemCollectionCell* cell = (ItemCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [cell setupItemLabel:self.content[indexPath.row] selected:self.selectedIndex==indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = [self cellWidthForIndex:indexPath.row];
    return CGSizeMake(width, self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(itemsCollectionView:didSelectTitle:atIndex:)]) {
        NSString* selectedTitle = self.content[indexPath.row];
        [self.delegate itemsCollectionView:self didSelectTitle:selectedTitle atIndex:indexPath.row];
    }
}

@end
