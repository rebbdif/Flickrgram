//
//  Human.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>

@class UIImage;

@interface Human : NSManagedObject

@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *avatar;

+ (Human *)humanWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
