//
//  AppDelegate.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "AppDelegate.h"
#import "SLVCollectionViewController.h"
#import "SLVFavouritesViewController.h"
#import "SLVSearchResultsModel.h"
#import "CoreDataStack.h"
#import "SLVModelProtocol.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SLVSearchResultsModel *model = [SLVSearchResultsModel new];
    CoreDataStack *stack = [CoreDataStack stack];
    model.mainContext = stack.mainContext;
    model.privateContext = stack.privateContext;
    SLVCollectionViewController *collectionViewController=[[SLVCollectionViewController alloc] initWithModel:model];
    SLVFavouritesViewController *favouritesViewController=[[SLVFavouritesViewController alloc] initWithModel:model];
    
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
