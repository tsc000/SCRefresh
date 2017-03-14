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
    
    
    self.tableView.dataSource = self;
    self.tableView.contentSize = CGSizeMake(375, 200);
    self.tableView.refresh.backgroundColor = [UIColor blueColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.refresh = [ Enjoy refreshWithTarget:self HeaderAction:@selector(refresh) FooterAction:@selector(loadMore)];
    
}

- (void)refresh {
    __weak typeof (self)weakSelf = self;
    [weakSelf.dataSource addObjectsFromArray:@[@"简单的下拉刷新测试"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.refresh endRefreshRefreshType:RefreshOptionHeader];
    });
    
}

- (void)loadMore {
    __weak typeof (self)weakSelf = self;
    
    [weakSelf.dataSource addObjectsFromArray:@[@"简单的下拉刷新测试"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.tableView.refresh endRefreshRefreshType:RefreshOptionFooter];
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
        for (NSInteger i=0; i<6; i++) {
            [_dataSource addObject:@"简单的下拉刷新测试"];
        }
    }
    
    return _dataSource;
}

@end
