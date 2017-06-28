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
    SLVCommentTypeComment,
    SLVCommentTypeLike,
};

@interface SLVComment : NSManagedObject

@property (nonatomic, assign) SLVCommentType *commentType;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) SLVHuman *author;

+ (SLVComment *)commentWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage;

@end
