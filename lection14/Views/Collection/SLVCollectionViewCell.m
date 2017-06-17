//
//  SLVCollectionViewCell.m
//  lection14
//
//  Created by 1 on 06.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewCell.h"

@implementation SLVCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = self.contentView.frame;
        _imageView = [[UIImageView alloc] initWithFrame:frame];

        [self.contentView addSubview:_imageView];
        self.backgroundColor = [UIColor lightGrayColor];
        [_imageView setAutoresizingMask:YES];

        _activityIndicator = [UIActivityIndicatorView new];
        [self.contentView addSubview:_activityIndicator];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.center = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
    }
    return self;
}

- (void)prepareForReuse {
    self.imageView.image = nil;
    self.activityIndicator.hidden = YES;
}


@end
