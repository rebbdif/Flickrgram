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

@interface SLVItem : NSManagedObject

@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) uint16_t numberOfLikes;
@property (nonatomic, assign) uint16_t numberOfComments;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, copy) NSString *largePhotoURL;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *largePhoto;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *searchRequest;

+ (NSString *)identifierForItemWithDictionary:(NSDictionary *)dict storage:(id<SLVStorageProtocol>)storage forRequest:(NSString *)request;

@end
