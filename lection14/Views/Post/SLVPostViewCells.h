//
//  SLVPostViewCells.h
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLVImageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UITextView *descriptionText;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end


@interface SLVLikesFooter : UIView

@property (nonatomic,strong) UIImageView *likesImageView;
@property (nonatomic,strong) UIImageView *commentsImageView;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic, strong) UILabel *commentsLabel;

@end


@interface SLVCommentsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *eventLabel;

@end

