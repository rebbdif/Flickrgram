//
//  SLVLayoutTest.m
//  flickrgram
//
//  Created by 1 on 23.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SLVCollectionViewLayout.h"

@interface SLVCollectionViewLayout (TestPrivate)

@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGFloat defaultCellWidth;
@property (nonatomic, assign) bool **places;
@property (nonatomic, copy) NSDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *cellAtributes;

#pragma mark - layout methods
- (void)prepareLayout;
- (CGSize)collectionViewContentSize;
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
#pragma mark - helper methods
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath;
- (CGRect)calculateFrame:(NSUInteger)side;
- (bool **)createPlacesRows:(NSUInteger)numberOfRows columns:(NSUInteger)numberOfColumns;

@end

@interface SLVLayoutTest : XCTestCase

@property (nonatomic, strong) SLVCollectionViewLayout *layout;
@property (nonatomic, strong) id collectionLayoutDelegateMock;

@end

@implementation SLVLayoutTest

- (void)setUp {
    [super setUp];
    self.collectionLayoutDelegateMock = OCMProtocolMock(@protocol(SLVCollectionLayoutDelegate));
    self.layout = [[SLVCollectionViewLayout alloc] initWithDelegate:self.collectionLayoutDelegateMock];
    OCMStub([self.collectionLayoutDelegateMock numberOfItems]).andReturn(30);
    self.layout.numberOfColumns = 3;
    self.layout.defaultCellWidth = 125;
}

- (void)tearDown {
    [super tearDown];
    self.layout = nil;
    self.collectionLayoutDelegateMock = nil;
}

- (void)test30Items {
    NSUInteger numberOfItems = 30;
    NSUInteger extraCells = 3 - (numberOfItems % 3);
    numberOfItems += extraCells;
    self.layout.numberOfRows = (numberOfItems + 1) / 2;
    self.layout.places = [self.layout createPlacesRows:self.layout.numberOfRows columns:self.layout.numberOfColumns];
    
    for (NSUInteger i = 0; i < numberOfItems; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGRect frame = [self.layout frameForIndexPath:indexPath];
        CGFloat width = CGRectGetWidth(frame);
        XCTAssert(width != 0);
    }
}


- (void)testItemsIterative {
    for (NSUInteger numberOfItems = 0; numberOfItems < 100; ++numberOfItems) {
        NSUInteger newNumberOfItems = numberOfItems;
        NSUInteger extraCells = 3 - (newNumberOfItems % 3);
        newNumberOfItems += extraCells;
        self.layout.numberOfRows = (newNumberOfItems + 1) / 2;
        self.layout.places = [self.layout createPlacesRows:self.layout.numberOfRows columns:self.layout.numberOfColumns];
        
        for (NSUInteger i = 0; i < newNumberOfItems; ++i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            CGRect frame = [self.layout frameForIndexPath:indexPath];
            CGFloat width = CGRectGetWidth(frame);
            XCTAssertTrue(width != 0, @"%ld items, %ld rows, i = %ld", numberOfItems, self.layout.numberOfRows, i);
        }
    }
}

@end
