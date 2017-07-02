//
//  CollectionViewController.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVCollectionViewController.h"
#import "SLVCollectionViewDataProvider.h"
#import "SLVCollectionNavigationBar.h"
#import "SLVCollectionViewCell.h"
#import "SLVCollectionViewLayout.h"

#import "UIColor+SLVColor.h"
#import "SLVSettingsViewController.h"
#import "SLVPostController.h"
#import "SLVPostModel.h"

@interface SLVCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegate, SLVCollectionLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SLVCollectionViewDataProvider *dataProvider;
@property (nonatomic, strong, readonly) id<SLVCollectionModelProtocol> model;
@property (nonatomic, strong) SLVCollectionViewLayout *layout;
@property (nonatomic, strong) SLVCollectionNavigationBar *navBar;

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
    
    [self createCollectionView];
    self.dataProvider = [[SLVCollectionViewDataProvider alloc] initWithCollectionView:self.collectionView model:self.model];
    self.collectionView.dataSource = self.dataProvider;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor myGray];
    self.navBar = [[SLVCollectionNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    self.navigationItem.titleView = self.navBar;
    self.navBar.searchBar.delegate = self;
    [self.navBar.settingsButton addTarget:self action:@selector(gotoSettings:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self firstStart];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.model pauseDownloads];
}

- (void)createCollectionView {
    self.layout = [[SLVCollectionViewLayout alloc] initWithDelegate:self];
    self.layout.delegate = self;
    CGRect frame = self.view.frame;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor myGray];
    [self.collectionView registerClass:[SLVCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SLVCollectionViewCell class])];
    [self.view addSubview:_collectionView];
    self.collectionView.delegate = self;
}

- (void)firstStart {
    NSString *searchRequest = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchRequest"];
    if (searchRequest) {
        self.navBar.searchBar.text = searchRequest;
        __weak typeof(self)weakself = self;
        [self.model firstStart:searchRequest withCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakself.model numberOfItems] > 0) {
                    [weakself.collectionView reloadData];
                } else {
                    [weakself.navBar.searchBar becomeFirstResponder];
                }
            });
        }];
    } else {
        [self.navBar.searchBar becomeFirstResponder];
    }
}

#pragma mark - Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.model clearModel];
    [self performSearch:searchBar];
}

- (void)performSearch:(UISearchBar *)searchBar {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchRequest"];
    NSString *searchRequest = searchBar.text;
    [[NSUserDefaults standardUserDefaults] setObject:searchRequest forKey:@"searchRequest"];
    [searchBar endEditing:YES];
    if (searchRequest) {
        __weak typeof(self) weakself = self;
        [self.model getItemsForRequest:searchRequest withCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakself.model numberOfItems] > 0) {
                    [weakself.collectionView reloadData];
                } else {
                    [weakself.navBar.searchBar becomeFirstResponder];
                }
            });
        }];
    }
}

#pragma mark - CollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SLVPostModel *postModel = [[SLVPostModel alloc] initWithNetworkManager:self.model.networkManager storageService:self.model.storageService];
    SLVItem *selectedItem = [self.model itemForIndex:indexPath.row];
    [postModel passSelectedItem:selectedItem];
    SLVPostController *postViewController = [[SLVPostController alloc] initWithModel:postModel];
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
    [self.model pauseDownloads];
}

#pragma mark - other

- (IBAction)gotoSettings:(id)sender {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:newBackButton];
    SLVSettingsViewController *settingsViewController = [[SLVSettingsViewController alloc] initWithStorage:self.model.storageService];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
