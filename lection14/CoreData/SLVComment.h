//
//  Comment.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SLVStorageService.h"

@class SLVHuman;

typedef NS_ENUM(NSUInteger, SLVCommentType) {
    SLVCommentTypeComment = 0,
    SLVCommentTypeLike = 1,
};

@interface SLVComment : NSManagedObject

@property (nonatomic, strong) NSNumber *commentType;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) SLVHuman *author;

+ (SLVComment *)commentWithDictionary:(NSDictionary *)dict type:(SLVCommentType)type storage:(id<SLVStorageProtocol>)storage;

@end
