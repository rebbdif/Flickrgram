//
//  SLVPostViewCells.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVPostViewCells.h"
@import Masonry;


#pragma mark - SLVImageCell

@implementation SLVImageCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor grayColor];
        _photoView = [UIImageView new];
        [_photoView setAutoresizingMask:YES];
        _photoView.clipsToBounds = YES;
        _photoView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_photoView];
        
        _descriptionText = [UITextView new];
        [self.contentView addSubview:_descriptionText];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.hidesWhenStopped = YES;
        [self.contentView addSubview:_spinner];
    }
    return self;
}

- (void)updateConstraints {
    UIView *contentView = self.contentView;
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left).with.offset(1);
        make.right.equalTo(contentView.mas_right).with.offset(-1);
        make.height.equalTo(@248);
    }];
    [_descriptionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoView.mas_bottom).with.offset(12);
        make.left.equalTo(contentView.mas_left).with.offset(16);
        make.right.equalTo(contentView.mas_right).with.offset(-16);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-12);
    }];
    [super updateConstraints];
}

- (void)prepareForReuse {
    self.photoView.image = nil;
    self.descriptionText.text = nil;
}

@end


#pragma mark - SLVLikesFooter

@implementation SLVLikesFooter

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _likesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
        [self addSubview:_likesImageView];
        _likesLabel = [UILabel new];
        [self addSubview:_likesLabel];
        
        _commentsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
        [self addSubview:_commentsImageView];
        _commentsLabel = [UILabel new];
        [self addSubview:_commentsLabel];
    }
    return self;
}

- (void)updateConstraints {
    [_likesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(16);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_likesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_likesImageView.mas_right).with.offset(7.1);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_commentsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(122.3);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(6);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [super updateConstraints];
}

@end


# pragma mark - SLVCommentsCell

@implementation SLVCommentsCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor greenColor];
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor blueColor];
        [_avatarImageView setAutoresizingMask:YES];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 38 / 2;
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        
        _eventLabel = [UILabel new];
        [self.contentView addSubview:_eventLabel];
    }
    return self;
}

- (void)updateConstraints {
    UIView *contentView = self.contentView;
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView.mas_centerY);
        make.size.equalTo(@38);
        make.left.equalTo(contentView.mas_left).with.offset(16);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
        make.top.equalTo(contentView.mas_top).with.offset(14);
        make.right.equalTo(contentView.mas_right).with.offset(8);
    }];
    [_eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
        make.top.equalTo(_nameLabel.mas_top).with.offset(1);
        make.right.equalTo(contentView.mas_right).with.offset(8);
    }];
    
    [super updateConstraints];
}

- (void)prepareForReuse {
    
}

@end
