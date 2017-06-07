//
//  Comment.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "Comment.h"
#import "Human.h"

@implementation Comment

@dynamic comment;
@dynamic url;
@dynamic author;

+ (Comment *)commentWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    Comment *comment = nil;
    comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:moc];
    comment.author = dict[@"author"];
    comment.url = dict[@"url"];
    comment.comment = dict[@"comment"];
    
    return comment;
}

@end
