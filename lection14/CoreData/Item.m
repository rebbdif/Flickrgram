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
@dynamic downloadProgress;
@dynamic applyFilterSwitherValue;

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

+ (SLVItem *)itemWithDictionary:(NSDictionary *)dict {
    SLVItem *item=[SLVItem new];
    item.title = dict[@"title"];
    NSString *secret = dict[@"secret"];
    NSString *server = dict[@"server"];
    NSString *farm = dict[@"farm"];
    NSString *idd = dict[@"id"];
    
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_n.jpg", farm, server, idd, secret];
    NSString *hdURl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_z.jpg", farm, server, idd, secret];
    item.photoURL = [NSURL URLWithString:url];
    item.highQualityPhotoURL = [NSURL URLWithString:hdURl];
    
    item.text = dict[@"title"];
    item.applyFilterSwitherValue = NO;
    
    return item;
}


@end


