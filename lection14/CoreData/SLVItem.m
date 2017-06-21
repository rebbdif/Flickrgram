//
//  Item.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVItem.h"
#import "SLVFacade.h"

static NSString *const entityName = @"SLVItem";

@implementation SLVItem

@dynamic isFavorite;
@dynamic numberOfLikes;
@dynamic numberOfComments;
@dynamic latitude;
@dynamic longitude;
@dynamic largePhotoURL;
@dynamic thumbnailURL;
@dynamic text;
@dynamic largePhoto;
@dynamic thumbnail;
@dynamic identifier;
@dynamic searchRequest;

+ (NSString *)identifierForItemWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage forRequest:(NSString *)request {
    NSString *base = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
                      dict[@"farm"], dict[@"server"], dict[@"id"], dict[@"secret"]];
    NSString *thumbnailUrl = [base stringByAppendingString:@""]; //_s//_n
    NSString *imageUrl = [base stringByAppendingString:@""]; //z
    NSString *identifier = thumbnailUrl;
    
    SLVItem *item = (SLVItem *)[storage fetchEntity:entityName forKey:identifier];
    
    if (!item) {
        [storage insertNewObjectForEntityForName:entityName withDictionary:@{
                                                                            @"thumbnailURL":thumbnailUrl,
                                                                            @"largePhotoURL":imageUrl,
                                                                            @"text":dict[@"title"],
                                                                            @"identifier":thumbnailUrl,
                                                                            @"searchRequest":request
                                                                            }];
    }
    return identifier;
}


@end


