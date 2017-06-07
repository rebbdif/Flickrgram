//
//  Item.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>
@class UIImage;

@interface Item : NSManagedObject

@property (nonatomic, assign) uint16_t favorited;
@property (nonatomic, assign) uint16_t liked;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, strong) NSString *highQualityPhotoURL;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *largePhoto;
@property (nonatomic, strong) UIImage *thumbnail;


@end
