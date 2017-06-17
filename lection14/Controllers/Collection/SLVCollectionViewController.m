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
#import "SLVCollectionViewLayout.h"

@interface SLVCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegate, SLVCollectionLayoutDelegate>

@property (nonatomic, strong) SLVCollectionView *collectionView;
@property (nonatomic, strong) SLVCollectionViewDataProvider *dataProvider;
@property (nonatomic, strong) SLVSearchResultsModel *model;
@property (nonatomic, strong) SLVCollectionViewLayout *layout;

@end

@implementation SLVCollectionViewController

NSString * const slvCollectionReuseIdentifier = @"Cell";

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        _model = model;
        _dataProvider = [[SLVCollectionViewDataProvider alloc] initWithModel:model];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self.collectionView reloadData];
    [self resumeDownloads];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"icFeed"];
    UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Лента" image:image tag:0];
    self.tabBarItem = tab;
    
    CGRect frame = self.view.frame;
    self.layout = [[SLVCollectionViewLayout alloc] initWithDelegate:self];
    self.layout.delegate = self;
    _collectionView = [[SLVCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:self.layout];
    [_collectionView registerClass:[SLVCollectionViewCell class] forCellWithReuseIdentifier: slvCollectionReuseIdentifier];
    [self.view addSubview:_collectionView];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor myGray];
    
    self.navigationItem.titleView = [self.collectionView createNavigationBarForSearchBar];
    [_collectionView.settingsButton addTarget:self action:@selector(gotoSettings:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = _dataProvider;
    
    self.collectionView.searchBar.delegate = self;
    
    __weak typeof(self) weakself = self;
    [self.collectionView.searchBar endEditing:YES];
    NSString *searchRequest = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchRequest"];
    self.collectionView.searchBar.text = searchRequest;
    self.model.searchRequest = searchRequest;
    [self.model getItemsForRequest:self.model.searchRequest withCompletionHandler:^{
        [weakself.collectionView reloadData];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.model.searchRequest = searchBar.text;
    [[NSUserDefaults standardUserDefaults] setObject:searchBar.text forKey:@"searchRequest"];
    [searchBar endEditing:YES];
    if (self.model.searchRequest) {
        [self.model clearModel:NO];
        __weak typeof(self) weakself = self;
        [self.model getItemsForRequest:self.model.searchRequest withCompletionHandler:^{
            [weakself.collectionView reloadData];
        }];
    }
}

- (IBAction)gotoSettings:(id)sender {
    [self pauseDownloads];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    SLVSettingsViewController *settingsViewController = [[SLVSettingsViewController alloc] initWithModel:self.model];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

#pragma mark - CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.model.selectedItem = self.model.items[indexPath.item];
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

#pragma mark - CollectionLayoutDelegate

- (NSUInteger)numberOfItems {
    return self.model.items.count;
}

@end
