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

+ (instancetype)itemWithDictionary:(NSDictionary *)dict facade:(id<SLVFacadeProtocol>)facade {
    NSString *base = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
                      dict[@"farm"], dict[@"server"], dict[@"id"], dict[@"secret"]];
    NSString *thumbnailUrl = [base stringByAppendingString:@"_s"]; //n
    NSString *imageUrl = [base stringByAppendingString:@"_n"]; //z
    NSString *identifier = thumbnailUrl;
    
    SLVItem *item = (SLVItem *)[facade fetchEntity:entityName forKey:identifier];
    if (!item) {
        item = [facade insertNewObjectForEntityForName:entityName];
        item.thumbnailURL = thumbnailUrl;
        item.largePhotoURL = imageUrl;
        item.text = dict[@"title"];
        item.identifier = item.thumbnailURL;
    }
    return item;
}


@end


