//
//  searchResultsModel.h
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVModelProtocol.h"

@class SLVItem;
@class NSManagedObjectContext;

@interface SLVSearchResultsModel : NSObject <SLVModelProtocol>

@property (strong, nonatomic) NSString *searchRequest;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) SLVItem *selectedItem;

@end
