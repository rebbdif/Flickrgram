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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    SLVSearchResultsModel *model = [SLVSearchResultsModel new];
    CoreDataStack *stack = [CoreDataStack stack];
    model.context = stack.coreDataContext;
    SLVCollectionViewController *collectionViewController=[[SLVCollectionViewController alloc] initWithModel:model];
    SLVFavouritesViewController *favouritesViewController=[SLVFavouritesViewController new];
    
    UINavigationController *ncCollection = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    UINavigationController *ncFavourites = [[UINavigationController alloc] initWithRootViewController:favouritesViewController];
    
    UITabBarController *tabbarController = [UITabBarController new];
    [tabbarController setViewControllers: @[ncCollection, ncFavourites]];
    
    self.window.rootViewController= tabbarController;
    [self.window makeKeyAndVisible];
    return YES;

}
@end
