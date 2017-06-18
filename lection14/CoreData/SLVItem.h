//
//  Item.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SLVFacadeProtocol.h"
@class UIImage;

@interface SLVItem : NSManagedObject

@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) uint16_t numberOfLikes;
@property (nonatomic, assign) uint16_t numberOfComments;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, strong) NSString *largePhotoURL;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *largePhoto;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *searchRequest;

+ (instancetype)itemWithDictionary:(NSDictionary *)dict facade:(id<SLVFacadeProtocol>)facade;

@end
