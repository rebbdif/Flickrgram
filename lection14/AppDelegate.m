//
//  AppDelegate.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "SLVCollectionViewController.h"
#import "SLVCollectionModel.h"
#import "SLVFavouritesViewController.h"
#import "SLVPostModel.h"
#import "SLVCollectionModelProtocol.h"
#import "SLVPostModelProtocol.h"
#import "SLVFacade.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SLVFacade *facade = [SLVFacade new];
    SLVCollectionModel *collectionModel = [[SLVCollectionModel alloc] initWithFacade:facade];
    SLVCollectionViewController *collectionViewController = [[SLVCollectionViewController alloc] initWithModel:collectionModel];
    SLVPostModel *postModel = [[SLVPostModel alloc] initWithFacade:facade];
    SLVFavouritesViewController *favouritesViewController = [[SLVFavouritesViewController alloc] initWithModel:postModel];
    
    UINavigationController *ncCollection = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    UINavigationController *ncFavourites = [[UINavigationController alloc] initWithRootViewController:favouritesViewController];
    
    UITabBarController *tabbarController = [UITabBarController new];
    [tabbarController setViewControllers: @[ncCollection, ncFavourites]];
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController= tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
