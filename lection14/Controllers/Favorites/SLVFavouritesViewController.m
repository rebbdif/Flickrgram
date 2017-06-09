//
//  SLVFavouritesViewController.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVFavouritesViewController.h"
#import "SLVSearchResultsModel.h"
#import "SLVFavoritesCell.h"

@interface SLVFavouritesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) SLVSearchResultsModel *model;

@end

@implementation SLVFavouritesViewController

static NSString * const reuseID = @"favoritesCell";

- (instancetype)initWithModel:(id)model {
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
    [self.tableView registerClass:[SLVFavoritesCell class] forCellReuseIdentifier:reuseID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.model getFavoriteItemsWithCompletionHandler:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLVFavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

@end
