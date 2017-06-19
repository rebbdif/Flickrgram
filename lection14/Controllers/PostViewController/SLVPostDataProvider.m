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
            return 1;
            break;
        } case 1: {
            return 3;
            break;
        } default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configureCellForTableView:tableView atIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return [self imageCellForTableView:tableView atIndexPath:indexPath];
            break;
        } case 1: {
            SLVCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
            cell.nameLabel.text = @"rebbdif";
            cell.eventLabel.text = @"liked photo";
            return cell;
            break;
        } default:
            break;
    }
    return nil;
}

- (SLVImageCell *)imageCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SLVImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    cell.delegate = self.controller;
    SLVItem *selectedItem = [self.model getSelectedItem];
    UIImage *image = selectedItem.largePhoto;
    if (!image) {
        cell.spinner.hidden = NO;
        [cell.spinner startAnimating];
        __weak typeof(self) weakSelf = self;
        [self.model loadImageForItem:selectedItem withCompletionHandler:^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SLVImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    SLVItem *selectedItem = [strongSelf.model getSelectedItem];
                    cell.photoView.image = selectedItem.largePhoto;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        SLVLikesFooter *footer = [SLVLikesFooter new];
        NSUInteger likes = 16; NSUInteger comments = 5;
        footer.likesLabel.text = [NSString stringWithFormat:@"%lu лайков", likes];
        footer.commentsLabel.text = [NSString stringWithFormat:@"%lu комментариев", comments];
        return footer;
    }
    return [UITableViewHeaderFooterView new];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor myGray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 312;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    } else {
        return 0;
    }
}

@end
