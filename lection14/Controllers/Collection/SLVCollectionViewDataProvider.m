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

@end

@implementation SLVCollectionViewDataProvider

- (instancetype)initWithModel:(id<SLVCollectionModelProtocol>)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImage *image = [self.model imageForIndex:indexPath.item];
    if (!image) {
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        __weak typeof(self) weakSelf = self;
        [self.model loadImageForIndex:indexPath.item withCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                SLVCollectionViewCell *cell = ((SLVCollectionViewCell *)([collectionView cellForItemAtIndexPath:indexPath]));
                [cell.activityIndicator stopAnimating];
                UIImage *image = [weakSelf.model imageForIndex:indexPath.item];
                if (!image) {
                    NSLog(@"cellForItem couldn't download or save image");
                }
                cell.imageView.image = image;
            });
        }];
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



@end
