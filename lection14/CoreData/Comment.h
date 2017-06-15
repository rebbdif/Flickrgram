//
//  Comment.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Human;

@interface Comment : NSManagedObject

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) Human *author;

+ (Comment *)commentWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
