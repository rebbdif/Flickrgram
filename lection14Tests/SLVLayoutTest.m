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

- (void)prepareLayout;
- (CGSize)collectionViewContentSize;
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath;
- (CGRect)calculateFrame:(NSUInteger)side;
- (bool **)createPlacesRows:(NSUInteger)numberOfRows columns:(NSUInteger)numberOfColumns;

@end

@interface SLVLayoutTest : XCTestCase

@end

@implementation SLVLayoutTest

- (void)setUp {
    [super setUp];
  //  SLVCollectionViewLayout *layout = [[SLVCollectionViewLayout alloc] initWithDelegate:<#(id<SLVCollectionLayoutDelegate>)#>];
  //  [self prepareLayout];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
