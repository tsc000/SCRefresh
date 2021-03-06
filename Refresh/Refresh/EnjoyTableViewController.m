//
//  RefreshTableViewController.m
//  Refresh
//
//  Created by tsc on 16/7/14.
//  Copyright © 2016年 DMS. All rights reserved.
//

#import "EnjoyTableViewController.h"
#import "Enjoy.h"

#define LGRandomColor [UIColor colorWithRed:((arc4random()%255)/255.0) green:((arc4random()%255)/255.0) blue:((arc4random()%255)/255.0) alpha:1.0f]

@interface EnjoyTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation EnjoyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)initial {
    
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.navigationController.navigationBar.translucent = YES ;
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.dataSource = self;
    self.tableView.contentSize = CGSizeMake(375, 200);
//    self.tableView.refresh.backgroundColor = [UIColor blueColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    __weak typeof (self)weakSelf = self;
    
    self.tableView.sc_header = [Enjoy headerWithRefreshingCallBack:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            [weakSelf.tableView reloadData];
    
            [weakSelf.tableView.sc_header endRefreshing];
        });
    
    }];

    [self.tableView.sc_header beginRefreshing];


    UIButton *release = [UIButton buttonWithType:UIButtonTypeCustom];

    [release setTitle:@"刷新" forState:UIControlStateNormal];
    [release setTitle:@"刷新" forState:UIControlStateSelected];

    [release setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [release sizeToFit];

    [release addTarget:self action:@selector(shoppingCartButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:release];

    self.navigationItem.rightBarButtonItems = @[right];

    [self.tableView.sc_header beginRefreshing];
}

- (void)shoppingCartButtonDidClick {

    [self.tableView.sc_header beginRefreshing];
}




#pragma mark --UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.textColor = LGRandomColor;
    
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行",indexPath.row];
    
    return cell;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSInteger i=0; i<6; i++) {
            [_dataSource addObject:@"简单的下拉刷新测试"];
        }
    }
    
    return _dataSource;
}

@end
