//
//  SLVCollectionViewLayout.m
//  lection14
//
//  Created by 1 on 30.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewLayout.h"

@interface SLVCollectionViewLayout()

@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) bool **places;

@end

@implementation SLVCollectionViewLayout

- (instancetype)initWithDelegate:(id<SLVCollectionLayoutDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (CGSize)collectionViewContentSize {
    self.numberOfItems = [self.delegate numberOfItems];
    self.numberOfColumns = 3;
    self.numberOfRows = self.numberOfItems / 2;
    _places = [self createPlacesRows:self.numberOfRows columns:self.numberOfColumns];
    CGRect frame = self.collectionView.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = width / 3 * self.numberOfRows;
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray new];
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes =
        [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    return layoutAttributes;
}

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect {
    NSMutableArray *indexpaths = [NSMutableArray new];
    for (NSUInteger i = 0; i < self.numberOfItems; ++i) {
        [indexpaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    return [indexpaths copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    CGRect frame = [self frameForIndexPath:indexPath];
    NSLog(@"item:%ld frame%f %f %f %f", (long)indexPath.item, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = UIEdgeInsetsInsetRect(frame, insets);
    return attributes;
}

- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath {
    CGRect frame;
    if (indexPath.item % 12 == 0 || indexPath.item - 7 % 12 == 0) {
        NSUInteger size = 2;
        frame = [self calculateFrame:size];
    } else {
        NSUInteger size = 1;
        frame = [self calculateFrame:size];
    }
    return frame;
}

- (CGRect)calculateFrame:(NSUInteger)side {
    CGFloat cellSide = CGRectGetWidth(self.collectionView.frame) / 3;
    CGRect result = CGRectMake(0, 0, cellSide, cellSide);
    for (NSUInteger i = 0; i < self.numberOfRows; ++i) {
        for (NSUInteger j = 0; j < self.numberOfColumns; ++j) {
            if (self.places[i][j] == true) {
                if (side == 1) {
                    self.places[i][j] = false;
                    result = CGRectMake(j * cellSide, i * cellSide, cellSide * side, cellSide * side);
                    return result;
                } else {
                    if (j < self.numberOfColumns - 1 && i < self.numberOfRows - 1) {
                        self.places[i][j] = false;
                        self.places[i][j+1] = false;
                        self.places[i+1][j] = false;
                        self.places[i+1][j+1] = false;
                        result = CGRectMake(j * cellSide, i * cellSide, cellSide * side, cellSide * side);
                        return result;
                    }
                }
            }
        }
    }
    return result;
}

- (bool **)createPlacesRows:(NSUInteger)numberOfRows columns:(NSUInteger)numberOfColumns {
    bool **places;
    places = (bool **)malloc(numberOfRows * sizeof(bool *));
    for (int i = 0; i < numberOfRows; ++i) {
        places[i] = (bool *)malloc(numberOfColumns * sizeof(bool));
    }
    for (int i = 0; i < numberOfRows; ++i) {
        for (int j = 0; j < numberOfColumns; ++j) {
            places[i][j] = true;
        }
    }
    return places;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

@end
