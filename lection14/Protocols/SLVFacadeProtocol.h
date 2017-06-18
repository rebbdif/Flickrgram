//
//  SLVFacadeProtocol.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLVFacadeProtocol <NSObject>

#pragma mark - Network

- (void)getModelFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *json))completionHandler;

- (NSURLSessionTask *)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler;

#pragma mark - Storage

- (id)fetchEntity:(NSString *)entity forKey:(NSString *)key;

- (void)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate withCompletionBlock:(void (^)(NSArray *result))completion;

- (void)save;

- (void)deleteAllEntities:(NSString *)entity withPredicate:(NSString *)predicate;

- (void)saveObject:(id)object forEntity:(NSString *)entity forAttribute:(NSString *)attribute forKey:(NSString *)key;

- (id)insertNewObjectForEntityForName:(NSString *)name;

- (void)clearModel;

@end
