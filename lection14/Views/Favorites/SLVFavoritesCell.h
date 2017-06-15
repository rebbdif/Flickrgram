//
//  FavoritesCell.h
//  lection14
//
//  Created by 1 on 09.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLVFavoritesCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *descriptionText;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end
