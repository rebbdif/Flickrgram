//
//  Item.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVItem.h"
#import "SLVStorageService.h"

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

+ (instancetype)itemWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSString *base = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
                      dict[@"farm"], dict[@"server"], dict[@"id"], dict[@"secret"]];
    NSString *thumbnailUrl = [base stringByAppendingString:@"_s"]; //n
    NSString *imageUrl = [base stringByAppendingString:@"_n"]; //z
    NSString *identifier = thumbnailUrl;
    
    SLVItem *item = (SLVItem *)[SLVStorageService fetchEntity:entityName forKey:identifier inManagedObjectContext:moc];
    if (!item) {
        item = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
        item.thumbnailURL = thumbnailUrl;
        item.largePhotoURL = imageUrl;
        item.text = dict[@"title"];
        item.identifier = item.thumbnailURL;
    }
    return item;
}


@end


