//
//  SLVFacade.m
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVFacade.h"
#import "SLVStorageService.h"
#import "SLVNetworkManager.h"

@interface SLVFacade ()

@property (nonatomic, strong) SLVNetworkManager *networkManager;
@property (nonatomic, strong) SLVStorageService *storageService;

@end

@implementation SLVFacade

#pragma mark - initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createNetworkManager];
        [self createStorageService];
    }
    return self;
}

- (void)createNetworkManager {
    _networkManager = [SLVNetworkManager new];
}

- (void)createStorageService {
    _storageService = [SLVStorageService new];
}

#pragma mark - Network

- (NSURLSessionTask *)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    NSURLSessionTask *task = [self.networkManager downloadImageFromURL:url withCompletionHandler:completionHandler];
    return task;
}

- (void)getModelFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *))completionHandler {
    [self.networkManager getModelFromURL:url withCompletionHandler:completionHandler];
}

#pragma mark - Storage

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key {
    return [self.storageService fetchEntity:entity forKey:key];
}

- (void)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate withCompletionBlock:(void (^)(NSArray *result))completion {
    [self.storageService fetchEntities:entity withPredicate:predicate withCompletionBlock:completion];
}

- (void)save {
    [self.storageService save];
}

- (void)deleteAllEntities:(NSString *)entity withPredicate:(NSString *)predicate {
    [self.storageService deleteEntitiesFromCoreData:entity withPredicate:predicate];
}

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key {
    [self.storageService saveObject:object forEntity:entity forAttribute:attribute forKey:key];
}

@end
