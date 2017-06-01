//
//  SLVFavouritesViewController.m
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVFavouritesViewController.h"

@interface SLVFavouritesViewController ()

@end

@implementation SLVFavouritesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"icLikes"];
        self.tabBarItem.title = @"Избранное";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}

@end
