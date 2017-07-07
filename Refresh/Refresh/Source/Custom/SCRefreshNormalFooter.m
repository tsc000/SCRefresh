//
//  SCRefreshNormalFooter.m
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshNormalFooter.h"

@interface SCRefreshNormalFooter()

/** 底部菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *bottomFlower;

/** 底部按钮 */
@property (nonatomic, weak) UIButton *bottomButton;

/////
@property (nonatomic, strong) NSMutableDictionary *stateTitles;

@end

@implementation SCRefreshNormalFooter

- (void)prepare {
    [super prepare];
 
    self.loadingFootTitle = SCBottomRefreshingTitle;
    
    self.finishedFootTitle = SCBottomNormalTitle;

    /** 上拉菊花 */
    self.bottomFlower = [self createActivityIndicatorView];//菊花
}

- (void)placeSubviews {
    
    /** 设置底部内边距 */ //之前top 用_scrollViewOrginInsets.top设置,有bug
    self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, self.bottomHeight, 0);
    
    _scrollViewOrginInsets = self.scrollView.contentInset;
    
    [super placeSubviews];
    
    [self changeFrame];
    
}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
    
    [super scrollViewContentSizeChange:change];
    
    [self changeFrame];
}

- (void)scrollViewContentOffsetChange:(NSDictionary *)change {
    
    [super scrollViewContentOffsetChange:change];
}

- (void)endRefreshing {
    [super endRefreshing];
    
    self.finishedFootTitle = _finishedFootTitle;
    
    [self revertState:false];
}

- (void)endNoMoreDataRefreshing {
    [super endNoMoreDataRefreshing];
    
    self.finishedFootTitle = @"没有更多了";
    
    [self revertState:false];
}

- (void)bottomRefresh {
    [super bottomRefresh];
    
    [self revertState:true];
}

- (void)revertState:(BOOL)state {
    self.bottomFlower.hidden = !state;
    
    state ? [self.bottomFlower startAnimating] : [self.bottomFlower stopAnimating];
    
    //刷新状态
    if (state) {
        [self.bottomButton setTitle: self.loadingFootTitle forState:UIControlStateNormal];
        
        [self.bottomButton sizeToFit];
    } else {
        [self.bottomButton setTitle: self.finishedFootTitle forState:UIControlStateNormal];
        
        [self.bottomButton sizeToFit];
    }
    
    [self changeFrame];
}

/////
- (void)setTitle:(NSString *)title forState:(RefreshState) state {
    
    if (!title) { return; }
    
    self.stateTitles[@(state)] = title;
    
    [self.bottomButton setTitle: self.stateTitles[@(state)] forState:UIControlStateNormal];

}

- (void)changeFrame {

    self.bottomButton.centerX = self.scrollView.centerX - self.scrollView.x;
    
    self.bottomButton.y = self.scrollView.contentSize.height + (SCBottomHeight - self.bottomButton.height) / 2.0;
    
    self.bottomFlower.centerY = self.bottomButton.centerY;
    
    self.bottomFlower.x = self.scrollView.centerX - self.bottomButton.width / 2.0 - self.bottomFlower.width - 20;

}

//以懒加载形式，bottomButton要加到scrollView上，但是scrollview在willMoveToSuperview才会捕获到
- (UIButton *)bottomButton {
    
    if (!_bottomButton) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:SCBottomNormalTitle forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(bottomRefresh) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        button.width = 160;
        
        button.height = 40;
        
//        //无内容时不让上拉显示，tableView正常，但collectionView必须要这里隐藏
//        if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
//            button.hidden = true;
//        }
        
        [self.scrollView addSubview:button];
        
        _bottomButton = button;
    }
    
    return _bottomButton;
}


/** 创建菊花 */
- (UIActivityIndicatorView *)createActivityIndicatorView{
    
    UIActivityIndicatorView *flower = [[UIActivityIndicatorView alloc] init];
    
    [flower sizeToFit];
    
    flower.hidden = true;

    [flower setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self addSubview:flower];
    
    return flower;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

@end
