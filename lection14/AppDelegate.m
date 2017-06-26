//
//  AppDelegate.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "AppDelegate.h"
#import "SLVCollectionViewController.h"
#import "SLVCollectionModel.h"
#import "SLVFavouritesViewController.h"
#import "SLVFavoritesModel.h"
#import "SLVFacade.h"
#import "SLVStorageService.h"
#import "SLVNetworkManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SLVFacade *facade = [[SLVFacade alloc] initWithNetworkManager:[SLVNetworkManager new] storageService:[SLVStorageService new]];
    SLVCollectionModel *collectionModel = [[SLVCollectionModel alloc] initWithFacade:facade];
    SLVCollectionViewController *collectionViewController = [[SLVCollectionViewController alloc] initWithModel:collectionModel];
    SLVFavoritesModel *favoritesModel = [[SLVFavoritesModel alloc] initWithFacade:facade];
    SLVFavouritesViewController *favouritesViewController = [[SLVFavouritesViewController alloc] initWithModel:favoritesModel];
    
    UINavigationController *ncCollection = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    UINavigationController *ncFavourites = [[UINavigationController alloc] initWithRootViewController:favouritesViewController];
    
    UITabBarController *tabbarController = [UITabBarController new];
    tabbarController.viewControllers = @[ncCollection, ncFavourites];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
