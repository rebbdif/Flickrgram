//
//  Human.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SLVStorageService.h"
#import "SLVNetworkProtocol.h"

@class UIImage;

@interface SLVHuman : NSManagedObject

@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *avatar;

+ (SLVHuman *)humanWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage;

- (void)getAvatarWithNetworkService:(id<SLVNetworkProtocol>)networkService storageService:(id<SLVStorageProtocol>)storageService completionHandler:(void (^)(UIImage *))completionHandler;

@end
