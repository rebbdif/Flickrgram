//
//  SLVCollectionView.h
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLVCollectionView : UICollectionView

@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UISearchBar *searchBar;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
- (UIView *)createNavigationBarForSearchBar;

@end
