//
//  SLVSettingsViewController.m
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVSettingsViewController.h"
#import "UIColor+SLVColor.h"
#import "SLVItem.h"

@interface SLVSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<SLVStorageProtocol> storage;

@end

@implementation SLVSettingsViewController

- (instancetype)initWithStorage:(id<SLVStorageProtocol>)storage {
    self = [super init];
    if (self) {
        _storage = storage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Настройки";
    self.tabBarController.tabBar.hidden = YES;
    
    CGRect frame = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.backgroundColor = [UIColor myGray];
    _tableView.opaque = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setContentOffset:CGPointMake(0, -200)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Custom" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"Темы";
            break;
        } case 1: {
            cell.textLabel.text = @"Очистить хранилище";
            break;
        } default:
            cell.textLabel.text = @"Дополнительные настройки";
            break;
    }
    if (indexPath.row != 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self clearEntirely];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)clearEntirely {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray<SLVItem *> *items = [self.storage fetchEntities:@"SLVItem" withPredicate:nil];
    
    for (SLVItem *item in items) {
        NSString *thumbnailFilePath = [NSHomeDirectory() stringByAppendingPathComponent:item.thumbnail];
        NSError *error = nil;
        if (item.thumbnail) {
            if (![fileManager removeItemAtPath:thumbnailFilePath error:&error]) {
                NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                NSLog(@"%@", error.userInfo);
            }
        }
        if (item.largePhoto) {
            NSString *photoFilePath = [NSHomeDirectory() stringByAppendingPathComponent:item.largePhoto];
            [fileManager removeItemAtPath:photoFilePath error:&error];
        }
    }
    
    [self.storage deleteEntities:@"SLVItem" withPredicate:nil];
}

@end
