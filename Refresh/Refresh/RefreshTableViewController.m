//
//  RefreshTableViewController.m
//  Refresh
//
//  Created by tsc on 16/7/14.
//  Copyright © 2016年 DMS. All rights reserved.
//

#import "RefreshTableViewController.h"

#import "SCRefreshStateHeader.h"
#import "SCRefreshNormalFooter.h"
#import "LoganRefreshFooter.h"
#import "SCRefreshNormalHeader.h"

#import "Enjoy.h"
#define LGRandomColor [UIColor colorWithRed:((arc4random()%255)/255.0) green:((arc4random()%255)/255.0) blue:((arc4random()%255)/255.0) alpha:1.0f]
@interface RefreshTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger count;

@end

@implementation RefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = false;
    [self initial];
}

- (void)initial {

//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = YES ;
//    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    
    self.tableView.dataSource = self;
    self.tableView.contentSize = CGSizeMake(375, 200);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    switch (self.type) {
        case 0:  //默认
            self.tableView.sc_header = [SCRefreshStateHeader headerWithTarget:self action:@selector(refresh)];
            
            self.tableView.sc_footer = [SCRefreshNormalFooter footerWithTarget:self action:@selector(loadMore)];
            break;
        case 1:
            
            self.tableView.sc_header = [SCRefreshStateHeader headerWithTarget:self action:@selector(refresh)];
            
            [self.tableView.sc_header setTitle:@"往下拉可以刷新哦" forState:RefreshStateNormal];
            
            [self.tableView.sc_header setTitle:@"放开我立即刷新" forState:RefreshStatePulled];
            
            [self.tableView.sc_header setTitle:@"正在帮您请求数据..." forState:RefreshStateRefreshing];
            
            self.tableView.sc_footer = [SCRefreshNormalFooter footerWithTarget:self action:@selector(loadMore)];
            
            break;
        case 2: {
            self.tableView.sc_header = [SCRefreshStateHeader headerWithTarget:self action:@selector(refresh)];
            
            SCRefreshNormalFooter *footer = [SCRefreshNormalFooter footerWithRefreshingCallBack:^{
                __weak typeof (self)weakSelf = self;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [weakSelf.tableView.sc_footer endRefreshing];
                    
                    [weakSelf.tableView reloadData];
                    
                });
            }];
            
            footer.loadingFootTitle = @"老铁,别急，俺正在帮你刷新";
            
            footer.finishedFootTitle = @"老铁,刷新完了";
            
            self.tableView.sc_footer = footer;
            
            break;
        }
    
        case 3: {
            self.tableView.sc_header = [SCRefreshStateHeader headerWithTarget:self action:@selector(refresh)];
            
            self.tableView.sc_footer = [LoganRefreshFooter footerWithRefreshingCallBack:^{
                __weak typeof (self)weakSelf = self;

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
 
                    [weakSelf.tableView.sc_footer endNoMoreDataRefreshing];
                    
                    [weakSelf.tableView reloadData];
                    
                    
                });
            }];
            break;
        }
  
        case 4:

            break;
        case 5:
            
            self.tableView.sc_header = [SCRefreshNormalHeader headerWithTarget:self action:@selector(refresh)];
            break;
            
        default:
            break;
    }
    

    UIButton *release = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [release setTitle:@"刷新" forState:UIControlStateNormal];
    [release setTitle:@"刷新" forState:UIControlStateSelected];
    
    [release setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [release sizeToFit];
    
    [release addTarget:self action:@selector(shoppingCartButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:release];
    
    self.navigationItem.rightBarButtonItems = @[right];
    
    if (self.type == 2 || self.type == 3) {
        return;
    }
    [self.tableView.sc_header beginRefreshing];
}

- (void)shoppingCartButtonDidClick {
    
    if ([self.tableView.sc_footer isRefreshing]) {
        return;
    }
    
    [self.tableView.sc_header beginRefreshing];
}

- (void)refresh {
    __weak typeof (self)weakSelf = self;
    [weakSelf.dataSource addObjectsFromArray:@[@"简单的下拉刷新测试"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.sc_header endRefreshing];
        
        [weakSelf.tableView.sc_footer endRefreshing];
        
    });
    
}

- (void)loadMore {
    __weak typeof (self)weakSelf = self;
    [weakSelf.dataSource addObjectsFromArray:@[@"简单的下拉刷新测试"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.count ++;
        
        [weakSelf.tableView.sc_footer endRefreshing];
        [weakSelf.tableView reloadData];
        
        
    });
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
        for (NSInteger i=0; i<25; i++) {
            [_dataSource addObject:@"简单的下拉刷新测试"];
        }
    }
    
    return _dataSource;
}

@end
