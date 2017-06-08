//
//  SLVPostViewController.m
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVPostViewController.h"
#import "UIColor+SLVColor.h"
#import "SLVPostViewCells.h"
#import "SLVItem.h"
#import "SLVSearchResultsModel.h"

@interface SLVPostViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SLVItem *item;
@property (nonatomic, strong, readonly) SLVSearchResultsModel *model;

@end

@implementation SLVPostViewController

- (instancetype)initWithModel:(SLVSearchResultsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:[self configureNavigationBar]];
        [self.navigationItem setLeftBarButtonItem:bbi];
        [self.navigationItem setHidesBackButton:NO];
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor myGray];
    CGRect frame = self.view.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SLVImageCell class] forCellReuseIdentifier:@"imageCell"];
    [self.tableView registerClass:[SLVCommentsCell class] forCellReuseIdentifier:@"commentsCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.hidesBackButton = NO;

}

- (UIView *)configureNavigationBar {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 44, 44)];
    view.backgroundColor = [UIColor cyanColor];
    UIImageView *avatarView = [UIImageView new];
    avatarView.backgroundColor = [UIColor blueColor];
    avatarView.layer.cornerRadius = 16;
    avatarView.clipsToBounds = YES;
    [avatarView setAutoresizesSubviews:YES];
    [view addSubview:avatarView];
    
    UILabel *nameLabel = [UILabel new];
    [view addSubview:nameLabel];
    
    UIImageView *locationSign = [UIImageView new];
    locationSign.image = [UIImage imageNamed:@"location"];
    [view addSubview:locationSign];
    UILabel *locationLabel = [UILabel new];
    locationLabel.textColor = [UIColor grayColor];
    [view addSubview:locationLabel];
    
    nameLabel.text = @"rebb dif";
    locationLabel.text = @"gorod dorog";
    
    return view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) weakself = self;
    
    [self.model imageForItem:self.model.selectedItem withCompletionHandler:^(UIImage *image) {
        __strong typeof(self) strongself = weakself;
        if (strongself) {
            dispatch_async(dispatch_get_main_queue(), ^{
               SLVImageCell *cell = [strongself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.photoView.image = image;
            });
        }
    }];
}


#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
            break;
        }
        case 1: {
            return 3;
            break;
        }
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configureCellForTableView:tableView AtIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)configureCellForTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            SLVImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    ///////////////
            cell.descriptionText.text = @"description";
            return cell;
            break;
        }
        case 1: {
            SLVCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentsCell"];
            cell.nameLabel.text = @"rebbdif";
            cell.eventLabel.text = @"liked photo";
            return cell;
            break;
        }
        default:
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        SLVLikesFooter *footer = [SLVLikesFooter new];
        NSUInteger likes = 16; NSUInteger comments = 5;
        footer.likesLabel.text = [NSString stringWithFormat:@"%lu лайков", likes];
        footer.commentsLabel.text = [NSString stringWithFormat:@"%lu комментариев", comments];
        return footer;
    }
    return [UITableViewHeaderFooterView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 312;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0){
        return 60;
    } else {
        return 0;
    }
}

@end
