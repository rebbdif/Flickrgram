//
//  SLVCollectionViewLayout.h
//  lection14
//
//  Created by 1 on 30.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLVCollectionLayoutDelegate <NSObject>

- (NSUInteger)numberOfItems;

@end


@interface SLVCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<SLVCollectionLayoutDelegate> delegate;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<SLVCollectionLayoutDelegate>)delegate;

@end
