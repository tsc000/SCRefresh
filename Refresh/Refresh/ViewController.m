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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark --UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    cell.textLabel.textColor = [UIColor orangeColor];
    
    cell.imageView.image = [UIImage imageNamed:@"timg"];
    
    return cell;
}

#pragma mark --UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case ControlTypeScrollView:
            [self.navigationController pushViewController:[[RefreshScrollViewController alloc] init] animated:true];
            break;
        case ControlTypeTableView:

            [self.navigationController pushViewController:[[RefreshTableViewController alloc] init] animated:true];
            break;

        case ControlTypeCollectionView:
        {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            [self.navigationController pushViewController:[[RefreshCollectionViewController alloc] initWithCollectionViewLayout:layout] animated:true];
        }
            
        break;
            
        case ControlTypeEnjoy:
            [self.navigationController pushViewController:[[EnjoyTableViewController alloc] init] animated:true];
        break;
        default:
            break;
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"scrollView测试"];
        [_dataSource addObject:@"tableView测试"];
        [_dataSource addObject:@"collectionView测试"];
        [_dataSource addObject:@"Enjoy刷新"];
    }
    
    return _dataSource;
}

- (void)dealloc {

}
@end
