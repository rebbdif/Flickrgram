//
//  SLVStringTest.m
//  flickrgram
//
//  Created by 1 on 29.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+SLVString.h"

@interface SLVStringTest : XCTestCase

@end

@implementation SLVStringTest

- (void)testNormal {
    NSString *emojiString = @"hello";
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    NSString *unescapedEmoji = [NSString stringWithUnescapedEmojis:escapedEmoji];
    
    XCTAssert([emojiString isEqualToString:unescapedEmoji]);
}

- (void)testHard {
    NSString *emojiString = @"ウィキペディア👻😀👍🏻🤜🏻 привет";
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    NSString *unescapedEmoji = [NSString stringWithUnescapedEmojis:escapedEmoji];
    
    XCTAssert([emojiString isEqualToString:unescapedEmoji]);
}

- (void)testNil {
    NSString *emojiString = nil;
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    XCTAssertNoThrow(@"nocrash");
    XCTAssert([escapedEmoji isEqualToString:@""]);
}

- (void)testRealLengthNormal {
    NSString *string = @"hello";
    NSUInteger realLength = [NSString realLength:string];
    XCTAssertEqual(realLength, 5);
}

- (void)testRealLengthEmoji {
    NSString *string = @"🌍";
    NSUInteger realLength = [NSString realLength:string];
    XCTAssertEqual(realLength, 1);}

- (void)testRealLengthCharSequence {
    NSString *string = @"e\u0301";
    NSUInteger realLength = [NSString realLength:string];
    XCTAssertEqual(realLength, 1);
}

- (void)testRealLengthLineFeed {
    NSString *string = @"abc\n";
    NSUInteger realLength = [NSString realLength:string];
    XCTAssertEqual(realLength, 4);
}

- (void)testRealLengthFormatters {
    NSString *string = @"abc%lu";
    NSUInteger realLength = [NSString realLength:string];
    XCTAssertEqual(realLength, 6);
}

@end
