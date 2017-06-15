//
//  SLVCollectionViewLayout.h
//  lection14
//
//  Created by 1 on 30.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLVCollectionLayoutDelegate <NSObject>

- (CGSize)sizeForRowAtIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView;

@end

@interface SLVCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<SLVCollectionLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger numberOfColumns;

@end
