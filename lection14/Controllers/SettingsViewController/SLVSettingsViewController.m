//
//  SLVSettingsViewController.m
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVSettingsViewController.h"
#import "UIColor+SLVColor.h"
#import "SLVSearchResultsModel.h"

@interface SLVSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SLVSearchResultsModel *model;

@end

@implementation SLVSettingsViewController

- (instancetype)initWithModel:(SLVSearchResultsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
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
    
   // _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
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
        [self.model clearModel:YES];
    }
}

@end
