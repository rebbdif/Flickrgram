//
//  Item.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVItem.h"
#import "SLVFacade.h"

@implementation SLVItem

@dynamic numberOfLikes;
@dynamic numberOfComments;
@dynamic location;
@dynamic photoID;
@dynamic photoSecret;
@dynamic isFavorite;
@dynamic largePhotoURL;
@dynamic thumbnailURL;
@dynamic text;
@dynamic largePhoto;
@dynamic thumbnail;
@dynamic identifier;
@dynamic searchRequest;

@dynamic author;
@dynamic comments;

@synthesize commentsArray;

+ (NSString *)identifierForItemWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage forRequest:(NSString *)request {
    NSString *base = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
                      dict[@"farm"], dict[@"server"], dict[@"id"], dict[@"secret"]];
    NSString *thumbnailUrl = [base stringByAppendingString:@""]; //_n
    NSString *imageUrl = [base stringByAppendingString:@""]; //_z
    NSString *identifier = thumbnailUrl;
    
    SLVItem *item = (SLVItem *)[storage fetchEntity:NSStringFromClass([self class]) forKey:identifier];
    
    if (!item) {
        [storage insertNewObjectForEntityForName:NSStringFromClass([self class]) withDictionary:@{
                                                                            @"thumbnailURL":thumbnailUrl,
                                                                            @"largePhotoURL":imageUrl,
                                                                            @"text":dict[@"title"],
                                                                            @"identifier":thumbnailUrl,
                                                                            @"searchRequest":request,
                                                                            @"photoID":dict[@"id"],
                                                                            @"photoSecret":dict[@"secret"]
                                                                            }];
    }
    return identifier;
}

- (void)addComments:(NSSet<SLVComment *> *)comments {
    __weak typeof(self)weakSelf = self;
    dispatch_barrier_sync(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        __strong typeof(self)strongSelf = weakSelf;
        strongSelf.comments = [strongSelf.comments setByAddingObjectsFromSet:comments];
        self.commentsArray = strongSelf.comments.allObjects;
    });
}

- (NSArray<SLVComment *> *)getCommentsArray {
    if (!self.commentsArray) {
        return self.comments.allObjects;
    } else {
        return self.commentsArray;
    }
}

@end


