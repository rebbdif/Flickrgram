//
//  Human.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "Human.h"

@implementation Human

@dynamic avatarURL;
@dynamic name;
@dynamic url;
@dynamic avatar;

+ (Human *)humanWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    Human *human = nil;
    human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:moc];
    human.avatarURL = dict[@"avatarURL"];
    human.name = dict[@"name"];
    human.url = dict[@"url"];
    human.avatar = dict[@"avatar"];
    
    return human;
}

@end
