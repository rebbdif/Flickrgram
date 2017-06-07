//
//  Item.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVItem.h"
#import "Item.h"

@implementation SLVItem

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
