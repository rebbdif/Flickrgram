//
//  Comment.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVComment.h"
#import "SLVHuman.h"
#import "UIColor+SLVColor.h"
#import "NSString+SLVString.h"

@implementation SLVComment

@synthesize commentType;
@dynamic text;
@dynamic author;
@dynamic item;

+ (SLVComment *)commentWithDictionary:(NSDictionary *)dict type:(SLVCommentType)type storage:(id<SLVStorageProtocol>)storage {
    SLVComment *comment = nil;
    comment = [storage insertNewObjectForEntity:NSStringFromClass([self class])];
    switch (type) {
        case SLVCommentTypeComment: {
            comment.text = [NSString stringWithEscapedEmojis:dict[@"_content"]];
            break;
        } case SLVCommentTypeLike: {
            comment.text = [NSString stringWithEscapedEmojis:@"оценил ваше фото."];
        }
    }
    
    SLVHuman *author = [SLVHuman humanWithDictionary:dict storage:storage];
    comment.author = author;
    return comment;
}

- (SLVCommentType)getCommentType {
    switch ([self.commentType integerValue]) {
        case 0: {
            return SLVCommentTypeComment;
            break;
        } case 1: {
            return SLVCommentTypeLike;
            break;
        }
    }
    return SLVCommentTypeComment;
}

@end
