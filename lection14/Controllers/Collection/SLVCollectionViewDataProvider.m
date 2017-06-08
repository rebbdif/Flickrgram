//
//  CollectionViewDataSource.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewDataProvider.h"
#import "SLVSearchResultsModel.h"
#import "SLVCollectionViewCell.h"

@interface SLVCollectionViewDataProvider()

@property (nonatomic, weak, readonly) SLVSearchResultsModel *model;

@end

@implementation SLVCollectionViewDataProvider

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithModel:(SLVSearchResultsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)showImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImage *image = [self.model imageForIndexPath:indexPath];
    if (image) {
        cell.imageView.image = image;
    } else {
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        [self.model loadImageForIndexPath:indexPath withCompletionHandler:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               SLVCollectionViewCell *cvc = ((SLVCollectionViewCell *)([collectionView cellForItemAtIndexPath:indexPath]));
               [cell.activityIndicator stopAnimating];
               cvc.imageView.image = [self.model imageForIndexPath:indexPath];
           });
        }];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.items.count;
}



@end
