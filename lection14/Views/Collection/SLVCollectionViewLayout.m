//
//  SLVCollectionViewLayout.m
//  lection14
//
//  Created by 1 on 30.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewLayout.h"

@interface SLVCollectionViewLayout()

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;

@end

@implementation SLVCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _numberOfColumns = 2;
        _contentWidth = self.collectionView.frame.size.width/3;
    }
    return self;
}


- (NSArray*)layoutAttributesForElementsInRect:(CGRect)bounds {
    return nil;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    CGRect frame = [self frameForIndexPath:indexPath];
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = UIEdgeInsetsInsetRect(frame, insets);
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath {
    CGRect frame;
    if (indexPath.item == 0) {
        CGFloat side = self.contentWidth * 2;
        frame = CGRectMake(0, 0, side, side);
    } else {
        CGFloat side = self.contentWidth;
        frame = CGRectMake(0, 0, side, side);
    }
    return frame;
}

- (void)invalidateLayout {
    [super invalidateLayout];
}

@end
