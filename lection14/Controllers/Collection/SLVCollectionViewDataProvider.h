//
//  CollectionViewDataSource.h
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class SLVSearchResultsModel;

@interface SLVCollectionViewDataProvider : NSObject <UICollectionViewDataSource>

- (instancetype)initWithModel:(SLVSearchResultsModel *)model;

@end
