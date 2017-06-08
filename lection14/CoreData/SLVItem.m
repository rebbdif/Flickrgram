//
//  Item.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVItem.h"

@implementation SLVItem

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


+ (SLVItem *)itemWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    SLVItem *item = nil;
    item = [NSEntityDescription insertNewObjectForEntityForName:@"SLVItem" inManagedObjectContext:moc];
    item.title = dict[@"title"];
    NSString *secret = dict[@"secret"];
    NSString *server = dict[@"server"];
    NSString *farm = dict[@"farm"];
    NSString *idd = dict[@"id"];
    
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_n.jpg", farm, server, idd, secret];
    NSString *hdUrl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_z.jpg", farm, server, idd, secret];
    item.photoURL = url;
    item.highQualityPhotoURL = hdUrl;
    
    item.text = dict[@"title"];
    
    item.identifier = item.photoURL;
    return item;
}


@end


