//
//  SLVEntityCreationTest.m
//  flickrgram
//
//  Created by 1 on 29.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SLVHuman.h"
#import "SLVItem.h"
#import "SLVComment.h"
#import "SLVStorageProtocol.h"
#import "NSString+SLVString.h"

@interface SLVEntityCreationTest : XCTestCase

@property (nonatomic, strong) id<SLVStorageProtocol> storageService;

@end

@implementation SLVEntityCreationTest

- (void)setUp {
    [super setUp];
    self.storageService = [SLVStorageService new];
}

- (void)testHumanFromLikesNormal {
    NSDictionary *dict = @{
                           @"iconfarm": @9,
                           @"iconserver" : @8169,
                           @"nsid" : @"30777021@N03",
                           @"username" : @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン"
                           };
    SLVHuman *human = [SLVHuman humanWithDictionary:dict storage:self.storageService];
    
    NSString *unicodeName = [NSString stringWithUnescapedEmojis:human.name];
    NSString *desiredURL = @"https://farm9.staticflickr.com/8169/buddyicons/30777021@N03.jpg";
    NSString *username = @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン";
    XCTAssert([human.avatarURL isEqualToString:desiredURL]);
    XCTAssert([unicodeName isEqualToString:username]);
    
    [self.storageService save];
    XCTAssertNoThrow(@"exception");
}

- (void)testHumanFromCommentsAndInfoNormal {
    NSDictionary *dict = @{
                           @"iconfarm": @9,
                           @"iconserver" : @8169,
                           @"author" : @"30777021@N03",
                           @"authorname" : @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン"
                           };
    SLVHuman *human = [SLVHuman humanWithDictionary:dict storage:self.storageService];
    
    NSString *unicodeName = [NSString stringWithUnescapedEmojis:human.name];
    NSString *desiredURL = @"https://farm9.staticflickr.com/8169/buddyicons/30777021@N03.jpg";
    NSString *username = @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン";
    XCTAssert([human.avatarURL isEqualToString:desiredURL]);
    XCTAssert([unicodeName isEqualToString:username]);
    
    [self.storageService save];
    XCTAssertNoThrow(@"exception");
}

- (void)testCommentTypeCommentNormal {
    NSDictionary *dict = @{
        @"author": @"30777021@N03",
        @"authorname": @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン",
        @"iconserver": @"8169",
        @"iconfarm": @9,
        @"datecreate": @"1498543529",
        @"_content": @" Admin [Guru] Award:\n<a href=\"https://www.flickr.com/groups/2564428@N24/\">\n<img src=\"https://c1.staticflickr.com/4/3810/32787760621_6b97641265_m.jpg\" /></a>\n\n<b>You're a Monochrome Guru 👻😀👍🏻🤜🏻 привет!</b>"
        };
    SLVComment *comment = [SLVComment commentWithDictionary:dict type:SLVCommentTypeComment storage:self.storageService];
    
    [self.storageService save];
    XCTAssertNoThrow(@"exception");
    
    NSString *unicodeText = [NSString stringWithUnescapedEmojis:comment.text];
    NSString *desiredText = @" Admin [Guru] Award:\n<a href=\"https://www.flickr.com/groups/2564428@N24/\">\n<img src=\"https://c1.staticflickr.com/4/3810/32787760621_6b97641265_m.jpg\" /></a>\n\n<b>You're a Monochrome Guru 👻😀👍🏻🤜🏻 привет!</b>";
    XCTAssert([unicodeText isEqualToString:desiredText]);
    
    SLVHuman *human = comment.author;
    NSString *unicodeName = [NSString stringWithUnescapedEmojis:human.name];
    NSString *desiredURL = @"https://farm9.staticflickr.com/8169/buddyicons/30777021@N03.jpg";
    NSString *username = @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン";
    XCTAssert([human.avatarURL isEqualToString:desiredURL]);
    XCTAssert([unicodeName isEqualToString:username]);
}

- (void)testCommentTypeLikeNormal {
    NSDictionary *dict = @{
                           @"nsid" : @"30777021@N03",
                           @"authorname": @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン",
                           @"iconserver": @"8169",
                           @"iconfarm": @9,
                           @"datecreate": @"1498543529",
                           @"_content": @" Admin [Guru] Award:\n<a href=\"https://www.flickr.com/groups/2564428@N24/\">\n<img src=\"https://c1.staticflickr.com/4/3810/32787760621_6b97641265_m.jpg\" /></a>\n\n<b>You're a Monochrome Guru 👻😀👍🏻🤜🏻 привет!</b>"
                           };
    SLVComment *comment = [SLVComment commentWithDictionary:dict type:SLVCommentTypeComment storage:self.storageService];
    
    [self.storageService save];
    XCTAssertNoThrow(@"exception");
    
    NSString *unicodeText = [NSString stringWithUnescapedEmojis:comment.text];
    NSString *desiredText = @" Admin [Guru] Award:\n<a href=\"https://www.flickr.com/groups/2564428@N24/\">\n<img src=\"https://c1.staticflickr.com/4/3810/32787760621_6b97641265_m.jpg\" /></a>\n\n<b>You're a Monochrome Guru 👻😀👍🏻🤜🏻 привет!</b>";
    XCTAssert([unicodeText isEqualToString:desiredText]);
    
    SLVHuman *human = comment.author;
    NSString *unicodeName = [NSString stringWithUnescapedEmojis:human.name];
    NSString *desiredURL = @"https://farm9.staticflickr.com/8169/buddyicons/30777021@N03.jpg";
    NSString *username = @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン";
    XCTAssert([human.avatarURL isEqualToString:desiredURL]);
    XCTAssert([unicodeName isEqualToString:username]);
}

- (void)testItemMultipleAddingComments {
    SLVItem *item = [self.storageService insertNewObjectForEntity:NSStringFromClass([SLVItem class])];
    NSDictionary *dict1 = @{
                           @"author": @"30777021@N03",
                           @"authorname": @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン",
                           @"iconserver": @"8169",
                           @"iconfarm": @9,
                           @"datecreate": @"1498543529",
                           @"_content": @"👻😀👍🏻🤜🏻 привет!"
                           };
    NSMutableSet<SLVComment *> *comments1 = [NSMutableSet new];
    [comments1 addObject:[SLVComment commentWithDictionary:dict1 type:SLVCommentTypeComment storage:self.storageService]];
    [item addComments:[comments1 copy]];
    
    NSDictionary *dict2 = @{
                           @"nsid" : @"30777021@N03",
                           @"authorname": @"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン",
                           @"iconserver": @"8169",
                           @"iconfarm": @9,
                           @"datecreate": @"1498543529",
                           @"_content": @"ru 👻😀👍🏻 привет!"
                           };
    NSMutableSet<SLVComment *> *comments2 = [NSMutableSet new];
    [comments2 addObject:[SLVComment commentWithDictionary:dict2 type:SLVCommentTypeLike storage:self.storageService]];
    [item addComments:[comments2 copy]];
    
    [self.storageService save];

    XCTAssert(item.comments.count == 2);
    XCTAssert(item.commentsArray.count == 2);
    XCTAssertNoThrow(@"notrhow");
    NSString *name = item.commentsArray[1].author.name;
    NSString *emojiName = [NSString stringWithUnescapedEmojis:name];
    XCTAssert([emojiName isEqualToString:@"Юрий Гагарин 🚀🚀🚀 ユーリイ・ガガーリン"]);
}

@end
