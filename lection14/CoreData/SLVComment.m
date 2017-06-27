//
//  Comment.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVComment.h"
#import "SLVHuman.h"

@implementation SLVComment

@dynamic comment;
@dynamic url;
@dynamic author;

+ (SLVComment *)commentWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage {
    SLVComment *comment = nil;
//    comment = [NSEntityDescription insertNewObjectForEntityForName:@"SLVComment" inManagedObjectContext:moc];
//    comment.author = dict[@"author"];
//    comment.url = dict[@"url"];
//    comment.comment = dict[@"comment"];
    
    return comment;
}

@end
