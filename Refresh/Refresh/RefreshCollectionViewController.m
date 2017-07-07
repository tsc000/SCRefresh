//
//  RefreshCollectionViewController.m
//  Refresh
//
//  Created by tsc on 16/7/14.
//  Copyright © 2016年 DMS. All rights reserved.
//

#import "RefreshCollectionViewController.h"
#import "SCRefreshStateHeader.h"
#import "SCRefreshNormalFooter.h"


#define LGRandomColor [UIColor colorWithRed:((arc4random()%255)/255.0) green:((arc4random()%255)/255.0) blue:((arc4random()%255)/255.0) alpha:1.0f]

@interface RefreshCollectionViewController ()
{
    NSInteger _count;
}
@end

@implementation RefreshCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    _count = 8;
    __weak typeof (self)weakSelf = self;
    
    self.collectionView.dataSource = self;
    
    self.collectionView.sc_header = [SCRefreshStateHeader headerWithRefreshingCallBack:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                _count += 32;
                [self.collectionView reloadData];
                [weakSelf.collectionView.sc_header endRefreshing];
            });
    }];
    

    self.collectionView.sc_footer = [SCRefreshNormalFooter footerWithRefreshingCallBack:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            _count += 32;
            [self.collectionView reloadData];
            [weakSelf.collectionView.sc_footer endRefreshing];
        });
    }];

    [self.collectionView.sc_header beginRefreshing];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = LGRandomColor;

    return cell;
}

@end
