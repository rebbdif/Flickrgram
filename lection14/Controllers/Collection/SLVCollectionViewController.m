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

@interface SLVCollectionViewController () <UISearchBarDelegate>

@property (strong, nonatomic) SLVCollectionView *collectionView;
@property (strong, nonatomic) SLVCollectionViewDataProvider *dataProvider;
@property (nonatomic, strong) SLVSearchResultsModel *model;

@end

@implementation SLVCollectionViewController

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        _model = model;
        UIImage *image = [UIImage imageNamed:@"icFeed"];
        UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Лента" image:image tag:0];
        self.tabBarItem = tab;
        
        _dataProvider = [SLVCollectionViewDataProvider new];
        
        CGRect frame = self.view.frame;
        UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[SLVCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];

        self.navigationController.navigationBar.backgroundColor = [UIColor myGray];
        
        self.navigationItem.titleView = [self.collectionView createNavigationBarForSearchBar];
        [_collectionView.settingsButton addTarget:self action:@selector(gotoSettings:) forControlEvents:UIControlEventTouchUpInside];
        
        self.collectionView.delegate = _dataProvider;
        self.collectionView.dataSource = _dataProvider;
        
        self.collectionView.searchBar.delegate = self;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view = _collectionView;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = _dataProvider;
    self.collectionView.dataSource = _dataProvider;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
}

- (IBAction)gotoSettings:(id)sender {
    [self.navigationController pushViewController:[SLVSettingsViewController new] animated:YES];
}
@end
