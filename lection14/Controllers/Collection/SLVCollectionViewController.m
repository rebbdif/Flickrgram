//
//  CollectionViewController.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewController.h"
#import "SLVCollectionViewDataProvider.h"
#import "SLVCollectionView.h"
#import "SLVCollectionViewCell.h"
#import "SLVCollectionViewLayout.h"

#import "UIColor+SLVColor.h"
#import "SLVSettingsViewController.h"
#import "SLVPostController.h"
#import "SLVPostModel.h"

NSString * const slvCollectionReuseIdentifier = @"Cell";

@interface SLVCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegate, SLVCollectionLayoutDelegate>

@property (nonatomic, strong) SLVCollectionView *collectionView;
@property (nonatomic, strong) SLVCollectionViewDataProvider *dataProvider;
@property (nonatomic, strong, readonly) id<SLVCollectionModelProtocol> model;
@property (nonatomic, strong) SLVCollectionViewLayout *layout;

@end

@implementation SLVCollectionViewController

#pragma mark - Lifecycle

- (instancetype)initWithModel:(id<SLVCollectionModelProtocol>)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
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
    self.dataProvider = [[SLVCollectionViewDataProvider alloc] initWithCollectionView:self.collectionView model:self.model];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor myGray];
    self.navigationItem.titleView = [self.collectionView createNavigationBarForSearchBar];
    [_collectionView.settingsButton addTarget:self action:@selector(gotoSettings:) forControlEvents:UIControlEventTouchUpInside];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self.dataProvider;
    self.collectionView.searchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self firstStart];
}

- (void)firstStart {
    NSString *searchRequest = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchRequest"];
    self.collectionView.searchBar.text = searchRequest;
    self.model 
}

#pragma mark - Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchRequest"];
    [self.model clearModel];
    [self.collectionView reloadData];
    [self performSearch:searchBar];
}

- (void)performSearch:(UISearchBar *)searchBar {
    NSString *searchRequest = searchBar.text;
    [[NSUserDefaults standardUserDefaults] setObject:searchRequest forKey:@"searchRequest"];
    [searchBar endEditing:YES];
    if (searchRequest) {
        __weak typeof(self) weakself = self;
        [self.model getItemsForRequest:searchRequest withCompletionHandler:^{
            [weakself.collectionView reloadData];
        }];
    }
}

#pragma mark - CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SLVPostModel *postModel = [[SLVPostModel alloc] initWithFacade:[self.model returnFacade]];
    SLVItem *selectedItem = [self.model itemForIndex:indexPath.row];
    [postModel passSelectedItem:selectedItem];
    SLVPostController *postViewController = [[SLVPostController alloc] initWithModel:postModel];
    [self pauseDownloads];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item + 5 == [self.model numberOfItems]) {
        __weak typeof(self) weakself = self;
        [self.model getItemsForRequest:nil withCompletionHandler:^{
            [weakself.collectionView reloadData];
        }];
    }
}

#pragma mark - CollectionLayoutDelegate

- (NSUInteger)numberOfItems {
    return [self.model numberOfItems];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImageForVisibleCells];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImageForVisibleCells];
    }
}

- (void)loadImageForVisibleCells {
    NSArray *visibleCellsIndexPath = self.collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *indexPath in visibleCellsIndexPath) {
        [self.dataProvider loadImageForIndexPath:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseDownloads];
}

#pragma mark - other

- (void)pauseDownloads {
    [self.model cancelOperations];
}

- (void)resumeDownloads {
    [self.model resumeOperations];
}

- (IBAction)gotoSettings:(id)sender {
    [self pauseDownloads];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    SLVSettingsViewController *settingsViewController = [[SLVSettingsViewController alloc] initWithModel:self.model];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
