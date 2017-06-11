//
//  CollectionViewController.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewController.h"
@import Masonry;
#import "SLVCollectionViewDataProvider.h"
#import "SLVCollectionView.h"
#import "UIColor+SLVColor.h"
#import "SLVSettingsViewController.h"
#import "SLVSearchResultsModel.h"
#import "SLVCollectionViewCell.h"
#import "SLVPostViewController.h"

@interface SLVCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegate>

@property (strong, nonatomic) SLVCollectionView *collectionView;
@property (strong, nonatomic) SLVCollectionViewDataProvider *dataProvider;
@property (nonatomic, strong) SLVSearchResultsModel *model;

@end

@implementation SLVCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        _model = model;
        UIImage *image = [UIImage imageNamed:@"icFeed"];
        UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Лента" image:image tag:0];
        self.tabBarItem = tab;
        
        _dataProvider = [[SLVCollectionViewDataProvider alloc] initWithModel:model];
        
        CGRect frame = self.view.frame;
        UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[SLVCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];
        [_collectionView registerClass:[SLVCollectionViewCell class] forCellWithReuseIdentifier: reuseIdentifier];
        [self.view addSubview:_collectionView];

        self.navigationController.navigationBar.backgroundColor = [UIColor myGray];
        
        self.navigationItem.titleView = [self.collectionView createNavigationBarForSearchBar];
        [_collectionView.settingsButton addTarget:self action:@selector(gotoSettings:) forControlEvents:UIControlEventTouchUpInside];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = _dataProvider;
        
        self.collectionView.searchBar.delegate = self;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self resumeDownloads];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ////
    __weak typeof(self) weakself = self;
    [self.collectionView.searchBar endEditing:YES];
    self.model.searchRequest = @"house";
    [self.model getItemsForRequest:self.model.searchRequest withCompletionHandler:^{
        [weakself.collectionView reloadData];
    }];
    ///
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.model.searchRequest = searchBar.text;
    [searchBar endEditing:YES];
    if (self.model.searchRequest) {
        [self.model clearModel];
        __weak typeof(self) weakself = self;
        [self.model getItemsForRequest:self.model.searchRequest withCompletionHandler:^{
            [weakself.collectionView reloadData];
        }];
    }}

- (IBAction)gotoSettings:(id)sender {
    [self pauseDownloads];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    [self.navigationController pushViewController:[SLVSettingsViewController new] animated:YES];
}

#pragma mark - CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.model.selectedItem = self.model.items[indexPath.row];
    SLVPostViewController *postViewController = [[SLVPostViewController alloc] initWithModel:self.model];
    [self pauseDownloads];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)pauseDownloads {
    [self.model cancelOperations];
}

- (void)resumeDownloads {
    [self.model resumeOperations];
}

@end
