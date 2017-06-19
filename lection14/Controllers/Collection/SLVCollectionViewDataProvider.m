//
//  CollectionViewDataSource.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewDataProvider.h"
#import "SLVCollectionViewCell.h"

static NSString * const reuseIdentifier = @"Cell";

@interface SLVCollectionViewDataProvider()

@property (nonatomic, weak, readonly) id<SLVCollectionModelProtocol> model;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation SLVCollectionViewDataProvider

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                                 model:(id<SLVCollectionModelProtocol>)model {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        _model = model;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item];
    UIImage *image = [self.model imageForIndex:indexPath.item];
    if (!image) {
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        if (!self.collectionView.dragging && !self.collectionView.decelerating) {
            [self loadImageForIndexPath:indexPath];
        }
    } else {
        cell.imageView.image = image;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.model numberOfItems];
}

- (void)loadImageForIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [self.model loadImageForIndex:indexPath.item withCompletionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            SLVCollectionViewCell *cell = ((SLVCollectionViewCell *)([self.collectionView cellForItemAtIndexPath:indexPath]));
            [cell.activityIndicator stopAnimating];
            cell.indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item];
            UIImage *image = [strongSelf.model imageForIndex:indexPath.item];
            if (!image) {
                NSLog(@"cellForItem couldn't download or save image");
            }
                  cell.imageView.image = image;
        });
    }];
}

@end
