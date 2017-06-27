//
//  Human.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVHuman.h"

@implementation SLVHuman

@dynamic avatarURL;
@dynamic name;
@dynamic url;
@dynamic avatar;

+ (SLVHuman *)humanWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage {
    NSString *iconFarm = dict[@"iconfarm"];
    NSString *iconServer = dict[@"iconserver"];
    NSString *nsid = dict[@"nsid"];
    NSString *avatarURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", iconFarm, iconServer, nsid];
    
    SLVHuman *human = nil;
    human = [storage insertNewObjectForEntity:NSStringFromClass([self class])];
    human.name = dict[@"username"];
    human.avatarURL = avatarURL;
    
    [storage save];
    return human;
}

@end
