//
//  SLVPostViewCells.m
//  lection14
//
//  Created by 1 on 07.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVPostViewCells.h"
#import "UIFont+SLVFonts.h"
#import "UIColor+SLVColor.h"
@import Masonry;


#pragma mark - SLVImageCell

@implementation SLVImageCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor myGray];
        
        _photoView = [UIImageView new];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        [_photoView setAutoresizingMask:YES];
        _photoView.clipsToBounds = YES;
        [self.contentView addSubview:_photoView];
        
        _descriptionText = [UILabel new];
        _descriptionText.font = [UIFont sanFranciscoDisplayMedium14];
        _descriptionText.numberOfLines = 0;
        [self.contentView addSubview:_descriptionText];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.hidesWhenStopped = YES;
        [self.contentView addSubview:_spinner];
        
        [self addGestures];
    }
    return self;
}

- (void)addGestures {
    self.contentView.userInteractionEnabled = YES;
    _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.contentView addGestureRecognizer:_pinch];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    _tap.numberOfTapsRequired = 2;
    [self.contentView addGestureRecognizer:_tap];
}

- (void)removeGestures {
    [self.contentView removeGestureRecognizer:self.pinch];
    [self.contentView removeGestureRecognizer:self.tap];
}

- (IBAction)pinch:(UIGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded) {
        [self.delegate showImageForCell:self];
        [self removeGestures];
    }
}

- (void)updateConstraints {
    UIView *contentView = self.contentView;
    [_photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left).with.offset(1);
        make.right.equalTo(contentView.mas_right).with.offset(-1);
        make.height.equalTo(@248);
    }];
    [_descriptionText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoView.mas_bottom).with.offset(12);
        make.left.equalTo(contentView.mas_left).with.offset(16);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-12);
        make.right.equalTo(contentView.mas_right).with.offset(-16);
    }];
    [_spinner mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_photoView.mas_centerX);
        make.centerY.equalTo(_photoView.mas_centerY);
    }];
    [super updateConstraints];
}

- (void)prepareForReuse {
    self.photoView.image = nil;
    self.descriptionText.text = nil;
}

@end


#pragma mark - SLVLikesCell

@implementation SLVLikesCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor myGray];
        _likesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
        [self.contentView addSubview:_likesImageView];
        _likesLabel = [UILabel new];
        _likesLabel.font = [UIFont sanFranciscoDisplayMedium14];
        [self.contentView addSubview:_likesLabel];
        
        _commentsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
        [self.contentView addSubview:_commentsImageView];
        _commentsLabel = [UILabel new];
        [_commentsLabel setFont:[UIFont sanFranciscoDisplayMedium14]];
        [self.contentView addSubview:_commentsLabel];
    }
    return self;
}

- (void)updateConstraints {
    UIView *contentView = self.contentView;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55.5);
    }];
    [_likesImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(16);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    [_likesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_likesImageView.mas_right).with.offset(7.1);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    [_commentsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(122.3);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    [_commentsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentsImageView.mas_right).with.offset(6);
        make.centerY.equalTo(contentView.mas_centerY);
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
        self.backgroundColor = [UIColor myGray];
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor blueColor];
        [_avatarImageView setAutoresizingMask:YES];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 38 / 2;
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont sanFranciscoDisplayMedium14];
        [self.contentView addSubview:_nameLabel];
        
        _eventLabel = [UILabel new];
        _eventLabel.textColor = [UIColor grayColor];
        _eventLabel.font = [UIFont sanFranciscoDisplayMedium13];
        _eventLabel.adjustsFontSizeToFitWidth = NO;
        _eventLabel.numberOfLines = 0;
        [self.contentView addSubview:_eventLabel];
    }
    return self;
}

- (void)updateConstraints {
    UIView *contentView = self.contentView;
    [_avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).with.offset(11);
        make.size.equalTo(@38);
        make.left.equalTo(contentView.mas_left).with.offset(16);
        make.bottom.lessThanOrEqualTo(contentView.mas_bottom).with.offset(-11);
    }];
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
        make.top.equalTo(contentView.mas_top).with.offset(14);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.equalTo(@16);
    }];
    [_eventLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
        make.top.equalTo(contentView.mas_top).with.offset(30);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-14);
    }];
    [super updateConstraints];
}

- (void)prepareForReuse {
    self.avatarImageView.image = nil;
    self.nameLabel.text = nil;
    self.eventLabel.text = nil;
}

@end
