//
//  SLVModelProtocol.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@protocol SLVFacadeProtocol <NSObject>

- (id)fetchEntity:(NSString *)entityName forKey:(NSString *)key;

- (NSArray *)fetchEntities:(NSString *)entityName withPredicate:(NSString *)predicate withCompletionBlock:(void (^)(NSArray *))completion;

- (void)loadImageForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler;

- (void)cancelOperations;

- (void)resumeOperations;

- (void)deleteEntities:(NSString *)entityName entirely:(BOOL)entirely;

- (void)destroyEverything;

- (void)clearModel;

@end
