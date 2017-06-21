//
//  SLVFavouritesViewController.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVFavouritesViewController.h"
#import "SLVFavoritesCell.h"
#import "UIColor+SLVColor.h"
#import "SLVItem.h"

@interface SLVFavouritesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) id<SLVPostModelProtocol> model;
@property (nonatomic, copy) NSArray *favorites;

@end

@implementation SLVFavouritesViewController

static NSString * const reuseID = @"favoritesCell";

- (instancetype)initWithModel:(id<SLVPostModelProtocol>)model {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"icLikes"];
        self.tabBarItem.title = @"Избранное";
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Избранное";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.backgroundColor = [UIColor myGray];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 312;
    [self.tableView registerClass:[SLVFavoritesCell class] forCellReuseIdentifier:reuseID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.favorites = [NSArray new];
    [self.model getFavoriteItemsWithCompletionHandler:^(NSArray *result) {
        self.favorites = result;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLVFavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    SLVItem *currentItem = self.favorites[indexPath.row];
    cell.photoView.image = currentItem.largePhoto;
    cell.descriptionText.text = currentItem.text;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

@end
