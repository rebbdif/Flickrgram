//
//  StorageService.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class UIImage;

@interface SLVStorageService : NSObject

+ (id)fetchEntity:(NSString *)entity forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *)moc;

+ (UIImage *)imageForKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc;

+ (UIImage *)thumbnailForKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc;

+ (void)saveImage:(UIImage *)image forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc;

+ (void)saveThumbnail:(UIImage *)image forKey:(NSString *)key inManagedObjectContext:(NSManagedObjectContext *) moc;

+ (void)saveInContext:(NSManagedObjectContext *)moc;

+ (void)clearCoreData;

@end
