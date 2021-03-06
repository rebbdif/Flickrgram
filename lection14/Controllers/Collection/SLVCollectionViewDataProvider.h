//
//  CollectionViewDataSource.h
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "SLVCollectionModelProtocol.h"

@class SLVSearchResultsModel;

@interface SLVCollectionViewDataProvider : NSObject <UICollectionViewDataSource, UIScrollViewDelegate>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView model:(id<SLVCollectionModelProtocol>)model;

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath;

@end
