//
//  StorageService.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface SLVStorageService : NSObject

+ (id)fetchEntity:(NSString *)entity forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *)moc;

+ (void)fetchEntities:(NSString *)entity withPredicate:(NSString *)predicate inManagedObjectContext:(NSManagedObjectContext *)moc withCompletionBlock:(void (^)(NSArray *result))completion;

+ (void)saveInContext:(NSManagedObjectContext *)moc;

+ (void)clearCoreData:(BOOL)entirely inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
