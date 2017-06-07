//
//  Item.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic favorited;
@dynamic liked;
@dynamic latitude;
@dynamic longitude;
@dynamic highQualityPhotoURL;
@dynamic photoURL;
@dynamic text;
@dynamic title;
@dynamic largePhoto;
@dynamic thumbnail;
@dynamic identifier;

+ (Item *)itemWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    Item *item = nil;
    item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc];
    item.liked = [dict[@"liked"] integerValue];
    item.favorited = [dict[@"favorited"] integerValue];
    item.photoURL = [dict[@"photoURL"] absoluteString];
    item.highQualityPhotoURL = [dict[@"highQualityPhotoURL"] absoluteString];
    item.thumbnail = dict[@"thumbnail"];
    item.largePhoto = dict[@"largePhoto"];
    
    item.identifier = item.photoURL;
    return item;
}

@end


