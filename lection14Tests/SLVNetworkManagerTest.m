//
//  SLVNetworkManagerTest.m
//  flickrgram
//
//  Created by 1 on 23.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLVNetworkManager.h"

@interface SLVNetworkManager (TestPrivate)

- (NSString *)moveToDocumentsFromLocation:(NSURL *)location lastPathComponent:(NSString *)lastPathComponent;

@end

@interface SLVNetworkManagerTest : XCTestCase

@property (nonatomic, strong) SLVNetworkManager *networkManager;

@end

@implementation SLVNetworkManagerTest

- (void)setUp {
    [super setUp];
    self.networkManager = [SLVNetworkManager new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNormal {
    NSURL *url = [NSURL URLWithString:@"https://farm5.staticflickr.com/4206/35483162445_5d9a8bf547.jpg"];
    NSURL *location = [NSURL URLWithString:@"file:///Users/a1/Library/Developer/CoreSimulator/Devices/B6536DE5-BA0B-4D68-A797-9FE4B621BF1A/data/Containers/Data/Application/B436DF43-3F6E-4870-A81D-B3582CB4CF97/tmp/CFNetworkDownload_JErGZn.tmp"];
    NSString *newUrl = [_networkManager moveToDocumentsFromLocation:location lastPathComponent:[url lastPathComponent]];
    NSString *idealUrl = @"35483162445_5d9a8bf547.jpg";
    XCTAssert([newUrl isEqualToString:idealUrl]);
}

@end
