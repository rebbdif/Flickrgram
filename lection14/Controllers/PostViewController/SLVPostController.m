//
//  SLVPostViewController.m
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVPostController.h"
#import "SLVPostDataProvider.h"
#import "SLVPostViewCells.h"
#import "SLVItem.h"
#import "SLVHuman.h"
#import "SLVComment.h"
#import "SLVCollectionModel.h"
#import "SLVPostNavigationBarView.h"
#import "UIColor+SLVColor.h"
#import "NSString+SLVString.h"
@import Masonry;

@interface SLVPostController () <UITableViewDelegate, SLVCellsDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) id<SLVPostModelProtocol> model;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIScrollView *zoomedImageView;
@property (nonatomic, weak) SLVImageCell *imageCell;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SLVPostDataProvider *provider;
@property (nonatomic, strong) SLVPostNavigationBarView *postNavigationBarView;

@end

@implementation SLVPostController

#pragma mark - Lifecycle

- (instancetype)initWithModel:(id<SLVPostModelProtocol>)model {
    self = [super init];
    if (self) {
        _model = model;
        _provider = [[SLVPostDataProvider alloc] initWithModel:model andController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self configureTableView];
    [self configureLeftBarButtonItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorites:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SLVItem *selectedItem = [self.model getSelectedItem];
    if (!selectedItem.author) {
        __weak typeof(self)weakSelf = self;
        [self.model getMetadataForSelectedItemWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf configureLeftBarButtonItem];
                [weakSelf.tableView reloadData];
            });
        }];
    }
}

- (void)configureLeftBarButtonItem {
    self.postNavigationBarView = [SLVPostNavigationBarView new];
    SLVItem *selectedItem = [self.model getSelectedItem];
    SLVHuman *author = selectedItem.author;
    UIImage *avatar = author.avatar;
    if (!avatar) {
        __weak typeof(self)weakSelf = self;
        [author getAvatarWithNetworkService:self.model.networkManager storageService:self.model.storageService completionHandler:^(UIImage *avatar) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf configureLeftBarButtonItem];
            });
        }];
    } else {
        self.postNavigationBarView.avatarView.image = avatar;
    }
    self.postNavigationBarView.nameLabel.text = [NSString stringWithUnescapedEmojis:selectedItem.author.name];
    if (selectedItem.location) self.postNavigationBarView.locationLabel.text = [NSString stringWithUnescapedEmojis:selectedItem.location];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.postNavigationBarView];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)configureTableView {
    CGRect frame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    self.tableView.backgroundColor = [UIColor myGray];
    self.tableView.separatorColor = [UIColor separatorColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SLVImageCell class] forCellReuseIdentifier:NSStringFromClass([SLVImageCell class])];
    [self.tableView registerClass:[SLVCommentsCell class] forCellReuseIdentifier:NSStringFromClass([SLVCommentsCell class])];
    [self.tableView registerClass:[SLVLikesCell class] forCellReuseIdentifier:NSStringFromClass([SLVLikesCell class])];
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self.provider;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 313;
        } else return 57.5;
    } else return 76;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor separatorColor];
        view.layer.borderWidth = 0;
        view.layer.borderColor = [UIColor separatorColor].CGColor;
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) return 0.5;
    else return 0;
}

#pragma mark - SLVCellsDelegate

- (void)showImageForCell:(SLVImageCell *)cell {
    self.imageCell = cell;
    self.imageView = [[UIImageView alloc] initWithImage:cell.photoView.image];
    self.zoomedImageView = [[UIScrollView alloc] initWithFrame:self.tableView.frame];
    self.zoomedImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.zoomedImageView addSubview:self.imageView];
    self.imageView.center = self.zoomedImageView.center;
    [self.view addSubview:self.zoomedImageView];
    self.zoomedImageView.scrollEnabled = YES;
    self.zoomedImageView.userInteractionEnabled = YES;
    self.zoomedImageView.delegate = self;
    self.zoomedImageView.maximumZoomScale = 4;
    self.zoomedImageView.minimumZoomScale = 0.5;
    [self.zoomedImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (IBAction)zoomIn:(id)sender {
    self.zoomedImageView.zoomScale = 2;
}

- (IBAction)hideImage:(id)sender {
    self.zoomedImageView.layer.opacity = 0;
    self.zoomedImageView.hidden = YES;
    [self.imageCell addGestures];
}

#pragma mark - other

- (IBAction)addToFavorites:(id)sender {
    [self.model makeFavorite:YES];
}

@end
