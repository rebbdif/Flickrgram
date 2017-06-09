//
//  SLVPostViewController.m
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVPostViewController.h"
#import "UIColor+SLVColor.h"
#import "SLVPostViewCells.h"
#import "SLVItem.h"
#import "SLVSearchResultsModel.h"
#import "UIFont+SLVFonts.h"
@import Masonry;

@interface SLVPostViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SLVItem *item;
@property (nonatomic, strong, readonly) SLVSearchResultsModel *model;

@end

@implementation SLVPostViewController

- (instancetype)initWithModel:(SLVSearchResultsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:[self configureNavigationBar]];
    [self.navigationItem setLeftBarButtonItem:bbi];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorites:)];
    
    CGRect frame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    self.tableView.backgroundColor = [UIColor myGray];
    self.tableView.separatorColor = [UIColor separatorColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SLVImageCell class] forCellReuseIdentifier:@"imageCell"];
    [self.tableView registerClass:[SLVCommentsCell class] forCellReuseIdentifier:@"commentsCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (UIView *)configureNavigationBar {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    UIImageView *avatarView = [UIImageView new];
    avatarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:170/255.0 alpha:0.5];
    avatarView.layer.cornerRadius = 16;
    avatarView.clipsToBounds = YES;
    [avatarView setAutoresizesSubviews:YES];
    [view addSubview:avatarView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont sanFranciscoDisplayMedium14];
    [view addSubview:nameLabel];
    
    UIImageView *locationSign = [UIImageView new];
    locationSign.image = [UIImage imageNamed:@"location"];
    [view addSubview:locationSign];
    UILabel *locationLabel = [UILabel new];
    locationLabel.font = [UIFont sanFranciscoDisplayMedium13];
    locationLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    [view addSubview:locationLabel];
    
    nameLabel.text = @"rebbdifserebr";
    locationLabel.text = @"Kauaii, Hawai";
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.centerY.equalTo(view.mas_centerY);
        make.size.equalTo(@32);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(16);
        make.top.equalTo(avatarView.mas_top).with.offset(1);
        make.height.equalTo(@16);
    }];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(28);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(3);
        make.height.equalTo(@15);
    }];
    [locationSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(6);
        make.width.equalTo(@8);
        make.height.equalTo(@10);
    }];
    return view;
}

- (IBAction)addToFavorites:(id)sender {
    [self.model makeFavorite:YES];
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
        }
        case 1: {
            return 3;
            break;
        }
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configureCellForTableView:tableView AtIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)configureCellForTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            SLVImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            cell.spinner.hidden = NO;
            [cell.spinner startAnimating];
            cell.photoView.image = self.model.selectedItem.thumbnail;
            __weak typeof(self) weakself = self;
            [self.model loadImageForItem:self.model.selectedItem withCompletionHandler:^(UIImage *image) {
                __strong typeof(self) strongself = weakself;
                if (strongself) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SLVImageCell *cell = [strongself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.photoView.image = image;
                        [cell.spinner stopAnimating];
                    });
                }
            }];
            cell.descriptionText.text = @"description";
            return cell;
            break;
        }
        case 1: {
            SLVCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
            cell.nameLabel.text = @"rebbdif";
            cell.eventLabel.text = @"liked photo";
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
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

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
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
    if (section == 0){
        return 60;
    } else {
        return 0;
    }
}

@end
