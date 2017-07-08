//
//  ViewController.m
//  Refresh
//
//  Created by tsc on 16/7/14.
//  Copyright © 2016年 DMS. All rights reserved.
//

#import "ViewController.h"
#import "RefreshScrollViewController.h"
#import "RefreshTableViewController.h"
#import "RefreshCollectionViewController.h"
#import "EnjoyTableViewController.h"
#import "SCRefreshNormalFooter.h"
#import "SCRefreshStateHeader.h"
#import "LoganRefreshFooter.h"

typedef NS_ENUM(NSInteger, ControlType) {
    ControlTypeScrollView = 0,
    ControlTypeTableView,
    ControlTypeCollectionView,
    ControlTypeEnjoy
};

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSArray *sectionTitles;
@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.sectionTitles = @[@"TableView", @"CollectionView", @"ScrollView"];
    
    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.size.height - 49 -64);
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.sectionHeaderHeight = 60;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.sc_header = [SCRefreshStateHeader headerWithTarget:self action:@selector(refresh)];
    
    self.tableView.sc_footer = [SCRefreshNormalFooter footerWithTarget:self action:@selector(loadMore)];
}

- (void)refresh {
    __weak typeof (self)weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        
        [weakSelf.tableView.sc_header endRefreshing];
        
    });
    
}

- (void)loadMore {
    __weak typeof (self)weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [weakSelf.tableView.sc_footer endNoMoreDataRefreshing];
  
    });
}

#pragma mark --UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.dataSource[section];
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray *array = self.dataSource[indexPath.section];
    
    cell.textLabel.text = array[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    cell.textLabel.textColor = [UIColor orangeColor];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
#pragma mark --UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 4) {
            EnjoyTableViewController *vc = [EnjoyTableViewController new];
            
            [self.navigationController pushViewController:vc animated:true];
            
            return;
        }
        
        RefreshTableViewController *vc = [RefreshTableViewController new];
        
        vc.tabBarController.hidesBottomBarWhenPushed = true;
        
        vc.type = indexPath.row;
        
        [self.navigationController pushViewController:vc animated:true];
        
    } else if (indexPath.section == 1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [self.navigationController pushViewController:[[RefreshCollectionViewController alloc] initWithCollectionViewLayout:layout] animated:true];
    } else if (indexPath.section == 2) {
        RefreshScrollViewController *vc = [RefreshScrollViewController new];
        
        [self.navigationController pushViewController:vc animated:true];
    }

}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        NSArray *tableViewSection = @[@"默认", @"自定义顶部文字", @"自定义底部文字", @"自定义底部", @"Enjoy刷新", @"顶部隐藏时间"];
        NSArray *collectionViewSection = @[@"默认"];
        NSArray *scrollViewSection = @[@"默认"];

        [_dataSource addObjectsFromArray:@[tableViewSection, collectionViewSection, scrollViewSection]];

    }
    
    return _dataSource;
}

- (void)dealloc {

}
@end
