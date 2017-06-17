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
#import "SLVCollectionModel.h"
#import "SLVPostView.h"
#import "UIColor+SLVColor.h"
@import Masonry;

@interface SLVPostController () <UITableViewDelegate, SLVCellsDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<SLVPostModelProtocol> model;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIScrollView *zoomedImageView;
@property (nonatomic, weak) SLVImageCell *imageCell;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SLVPostDataProvider *provider;

@end

@implementation SLVPostController

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
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:[SLVPostView configureNavigationBar]];
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
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self.provider;
}


- (IBAction)addToFavorites:(id)sender {
    [self.model makeFavorite:YES];
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


@end
