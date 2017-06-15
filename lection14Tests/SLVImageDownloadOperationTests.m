//
//  SLVImageDownloadOperationTests.m
//  lection14
//
//  Created by 1 on 26.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "SLVItem.h"
#import "SLVSearchResultsModel.h"
#import "CoreDataStack.h"

@interface SLVSearchResultsModel (TestPrivate)

- (NSArray *)parseData:(NSDictionary *)json;

@end

@interface SLVImageDownloadOperationTests : XCTestCase

@end

@implementation SLVImageDownloadOperationTests

- (void)setUp {
    [super setUp];
    id itemMock = OCMClassMock([SLVItem class]);
    OCMStub([itemMock itemWithDictionary:[OCMArg any] inManagedObjectContext:[OCMArg any]]).andReturn(@"mock");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNormal {
    SLVSearchResultsModel *model = [SLVSearchResultsModel new];
    NSDictionary *json = @{@"photos":
                               @{@"photo": @[
                                         @{@"photo1":@"photo1"},
                                         @{@"photo2":@"photo2"},
                                         @{@"photo3":@"photo3"}]
                                 }
                           };
    NSArray *result = [model parseData:json];
    XCTAssertNotNil(result);
    XCTAssertEqual(result.count, 3);
}

- (void)testNil {
    SLVSearchResultsModel *model = [SLVSearchResultsModel new];
    NSDictionary *json = nil;
    NSArray *result = [model parseData:json];
    XCTAssertNil(result);
}

- (void)testIncorrectInput {
    SLVSearchResultsModel *model = [SLVSearchResultsModel new];
    NSDictionary *json = @{@"phontomas":
                               @{@"photo": @[
                                         @{@"photo1":@"photo1"},
                                         @{@"photo2":@"photo2"},
                                         @{@"photo3":@"photo3"}]
                                 }
                           };
    NSArray *result = [model parseData:json];
    //XCTAssertNil(result);
    XCTAssertTrue([result count]==0);
}

- (void)testPerformanceExample {
    SLVSearchResultsModel *model = [SLVSearchResultsModel new];
    NSDictionary *json = @{@"photos":
                               @{@"photo": @[
                                         @{@"photo1":@"photo1"},
                                         @{@"photo2":@"photo2"},
                                         @{@"photo3":@"photo3"}]
                                 }
                           };
    
    
    // This is an example of a performance test case.
    [self measureBlock:^{
        NSArray *result = [model parseData:json];
    }];
}

@end
