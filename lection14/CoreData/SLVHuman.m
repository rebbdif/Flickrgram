//
//  Human.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVHuman.h"
@import UIKit;

@implementation SLVHuman

@dynamic avatarURL;
@dynamic name;
@dynamic url;
@dynamic avatar;

+ (SLVHuman *)humanWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage {
    NSString *iconFarm = dict[@"iconfarm"];
    NSString *iconServer = dict[@"iconserver"];
    NSString *nsid;
    if (dict[@"nsid"]) {
        nsid = dict[@"nsid"];
    } else if (dict[@"author"]) {
        nsid = dict[@"author"];
    }
    NSString *avatarURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", iconFarm, iconServer, nsid];
    
    SLVHuman *human = nil;
    human = [storage insertNewObjectForEntity:NSStringFromClass([self class])];
    NSString *name;
    if (dict[@"username"]) {
        name = dict[@"username"];
    } else if (dict[@"authorname"]) {
        name = dict[@"authorname"];
    }
    human.name = name;
    human.avatarURL = avatarURL;
    
    return human;
}

- (void)getAvatarWithNetworkService:(id<SLVNetworkProtocol>)networkService storageService:(id<SLVStorageProtocol>)storageService completionHandler:(void (^)(UIImage *))completionHandler {
    NSURL *url = [NSURL URLWithString:self.avatarURL];
    __weak typeof(self)weakSelf = self;
    [networkService getDataFromURL:url withCompletionHandler:^(NSData *data) {
        __strong typeof(self)strongSelf = weakSelf;
        UIImage *avatar = [UIImage imageWithData:data];
        strongSelf.avatar = avatar;
        [storageService save];
        completionHandler(avatar);
    }];
}


@end
