//
//  Item.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVItem.h"

@implementation SLVItem

@dynamic isFavorite;
@dynamic likes;
@dynamic comments;
@dynamic latitude;
@dynamic longitude;
@dynamic largePhotoURL;
@dynamic thumbnailURL;
@dynamic text;
@dynamic title;
@dynamic largePhoto;
@dynamic thumbnail;
@dynamic identifier;


+ (SLVItem *)itemWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    SLVItem *item = nil;
    item = [NSEntityDescription insertNewObjectForEntityForName:@"SLVItem" inManagedObjectContext:moc];
    item.title = dict[@"title"];
    NSString *secret = dict[@"secret"];
    NSString *server = dict[@"server"];
    NSString *farm = dict[@"farm"];
    NSString *idd = dict[@"id"];
    
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_s.jpg", farm, server, idd, secret]; //n
    NSString *hdUrl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_n.jpg", farm, server, idd, secret]; //z
    item.thumbnailURL = url;
    item.largePhotoURL = hdUrl;
    
    item.text = dict[@"title"];
    
    item.identifier = item.thumbnailURL;
    return item;
}


@end


