//
//  ItemsCollectionView.h
//  FretX
//
//  Created by Developer on 7/10/17.
//  Copyright © 2017 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsCollectionView;

@protocol ItemsCollectionViewDelegate <NSObject>

- (void)itemsCollectionView:(ItemsCollectionView*)collectionView didSelectTitle:(NSString*)title atIndex:(NSUInteger)selectedIndex;

@end

@interface ItemsCollectionView : UIView

@property (weak) id<ItemsCollectionViewDelegate> delegate;

- (void)setupWithContent:(NSArray<NSString*>*)content delegate:(id<ItemsCollectionViewDelegate>)delegate;

@end
