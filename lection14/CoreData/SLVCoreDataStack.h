//
//  CoreDataStack.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface SLVCoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *privateContext;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initStack NS_DESIGNATED_INITIALIZER;
+ (instancetype)stack;

@end