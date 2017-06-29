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

- (void)testRussian {
    NSString *emojiString = @"балалайка";
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    NSString *unescapedEmoji = [NSString stringWithUnescapedEmojis:escapedEmoji];
    
    XCTAssert([emojiString isEqualToString:unescapedEmoji]);
}

- (void)testEmojiEasy {
    NSString *emojiString = @"👻😀👍🏻hello";
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    NSString *unescapedEmoji = [NSString stringWithUnescapedEmojis:escapedEmoji];
    
    XCTAssert([emojiString isEqualToString:unescapedEmoji]);
}

- (void)testEmojiHard {
    NSString *emojiString = @"👻😀👍🏻🤜🏻 привет";
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    NSString *unescapedEmoji = [NSString stringWithUnescapedEmojis:escapedEmoji];
    
    XCTAssert([emojiString isEqualToString:unescapedEmoji]);
}

- (void)testEmojiJapaneese {
    NSString *emojiString = @"ウィキペディア👻😀👍🏻🤜🏻 привет";
    NSString *escapedEmoji = [NSString stringWithEscapedEmojis:emojiString];
    NSString *unescapedEmoji = [NSString stringWithUnescapedEmojis:escapedEmoji];
    
    XCTAssert([emojiString isEqualToString:unescapedEmoji]);
}

@end
