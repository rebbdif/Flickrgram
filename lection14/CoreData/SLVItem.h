//
//  Item.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SLVStorageProtocol.h"

@class UIImage;
@class SLVComment;
@class SLVHuman;

@interface SLVItem : NSManagedObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *largePhoto;
@property (nonatomic, copy) NSString *largePhotoURL;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *numberOfComments;
@property (nonatomic, copy) NSString *numberOfLikes;
@property (nonatomic, copy) NSString *photoID;
@property (nonatomic, copy) NSString *photoSecret;
@property (nonatomic, copy) NSString *searchRequest;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, strong) SLVHuman *author;
@property (nonatomic, strong) NSSet<SLVComment *> *comments;

@property (nonatomic, copy) NSArray<SLVComment *> *commentsArray;

+ (NSString *)identifierForItemWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage forRequest:(NSString *)request;

- (void)addComments:(NSSet<SLVComment *> *)comments;

@end
