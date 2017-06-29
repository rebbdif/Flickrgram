//
//  SLVPostDataProvider.m
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVPostDataProvider.h"
#import "SLVPostViewCells.h"
#import "UIColor+SLVColor.h"
#import "SLVItem.h"
#import "SLVComment.h"
#import "SLVHuman.h"

@interface SLVPostDataProvider()

@property (nonatomic, weak, readonly) id<SLVPostModelProtocol> model;
@property (nonatomic, weak, readonly) id<UITableViewDelegate,SLVCellsDelegate> controller;

@end

@implementation SLVPostDataProvider

- (instancetype)initWithModel:(id<SLVPostModelProtocol>)model andController:(id<UITableViewDelegate,SLVCellsDelegate>)controller {
    self = [super init];
    if (self) {
        _model = model;
        _controller = controller;
    }
    return self;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 2;
            break;
        } case 1: {
            SLVItem *selectedItem = [self.model getSelectedItem];
            return selectedItem.comments.count;
            break;
        } default:
            return 1;
            break;
    }
}

# pragma mark - cellForRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configureCellForTableView:tableView atIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) return [self imageCellForTableView:tableView atIndexPath:indexPath];
            if (indexPath.row == 1) return [self likesCellForTableView:tableView atIndexPath:indexPath];
            break;
        } case 1: {
            return [self commentsCellForTableView:tableView atIndexPath:indexPath];
            break;
        } default:
            break;
    }
    return nil;
}

- (SLVImageCell *)imageCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SLVImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SLVImageCell class])];
    cell.delegate = self.controller;
    SLVItem *selectedItem = [self.model getSelectedItem];
    NSString *destinationPath = [NSHomeDirectory() stringByAppendingPathComponent:selectedItem.largePhoto];
    UIImage *image = [UIImage imageWithContentsOfFile:destinationPath];
    if (!image) {
        cell.spinner.hidden = NO;
        [cell.spinner startAnimating];
        __weak typeof(self) weakSelf = self;
        [self.model loadImageForItem:selectedItem withCompletionHandler:^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SLVImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    NSString *destinationPath = [NSHomeDirectory() stringByAppendingPathComponent:selectedItem.largePhoto];
                    cell.photoView.image = [UIImage imageWithContentsOfFile:destinationPath];
                    [cell.spinner stopAnimating];
                });
            }
        }];
    } else {
        cell.photoView.image = image;
    }
    cell.descriptionText.text = selectedItem.text;
    return cell;
}

- (SLVLikesCell *)likesCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SLVLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SLVLikesCell class])];
    SLVItem *selectedItem = [self.model getSelectedItem];
    NSString *numberOfLikes = selectedItem.numberOfLikes;
    if (!numberOfLikes) numberOfLikes = @" ";
    cell.likesLabel.text = [NSString stringWithFormat:@"%@ лайков", numberOfLikes];
    NSString *numberOfComments = selectedItem.numberOfComments;
    if (!numberOfComments) numberOfComments = @" ";
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@ комментариев", numberOfComments];
    return cell;
}

- (SLVCommentsCell *)commentsCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SLVCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SLVCommentsCell class])];
    SLVItem *item = [self.model getSelectedItem];
    SLVComment *currentComment = item.commentsArray[indexPath.row];
    SLVHuman *author = currentComment.author;
    cell.nameLabel.text = author.name;
    NSString *text = (currentComment.text ? currentComment.text : @" ");
    switch ([currentComment.commentType integerValue]) {
        case SLVCommentTypeComment: {
            NSString *textWithIntroduction = [@"прокоментировал фото: \n"stringByAppendingString:text];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textWithIntroduction];
           // [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:40.0f / 255.0f green:171.0f / 255.0f blue:236.0f / 255.0f alpha:1.0f] range:NSMakeRange(22, 17)];
            cell.eventLabel.attributedText = attributedString;
            break;
        } case SLVCommentTypeLike: {
            [tableView setRowHeight:60];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f / 255.0f green:38.0f / 255.0f blue:70.0f / 255.0f alpha:1.0f] range:NSMakeRange(0, 6)];
            cell.eventLabel.attributedText = attributedString;
            break;
        }
    }
    UIImage *avatar = author.avatar;
    if (!avatar) {
        [author getAvatarWithNetworkService:self.model.networkManager storageService:self.model.storageService completionHandler:^(UIImage *avatar) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SLVCommentsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.avatarImageView.image = avatar;
            });
        }];
    } else {
        cell.avatarImageView.image = avatar;
    }
    return cell;
}

@end
