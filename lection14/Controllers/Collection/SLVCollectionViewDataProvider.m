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

@property (nonatomic, weak, readonly) id<SLVModelProtocol> model;

@end

@implementation SLVCollectionViewDataProvider

- (instancetype)initWithModel:(id<SLVModelProtocol>)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexLabel.text = [NSString stringWithFormat:@"%lu", indexPath.item];
    UIImage *image = [self.model thumbnailForIndexPath:indexPath];
    if (image) {
        cell.imageView.image = image;
    } else {
        cell.activityIndicator.hidden = NO;
        cell.imageView.image = [UIImage imageNamed:@"noImage"];
        [cell.activityIndicator startAnimating];
        [self.model loadThumbnailForIndexPath:indexPath withCompletionHandler:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               SLVCollectionViewCell *cvc = ((SLVCollectionViewCell *)([collectionView cellForItemAtIndexPath:indexPath]));
               [cell.activityIndicator stopAnimating];
               UIImage *image = [self.model thumbnailForIndexPath:indexPath];
               cvc.imageView.image = image;
           });
        }];
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
