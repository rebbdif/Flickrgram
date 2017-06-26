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

- (NSURL *)constructURL:(NSString *)fileName;

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
 
}

@end
