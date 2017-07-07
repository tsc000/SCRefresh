//
//  LoganRefreshFooter.m
//  Refresh
//
//  Created by tsc on 2017/7/6.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "LoganRefreshFooter.h"

@interface LoganRefreshFooter()

/** 底部菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *bottomFlower;

/** 底部按钮 */
@property (nonatomic, weak) UIButton *bottomButton;

//加载中底部按钮显示文字
@property (nonatomic, copy) NSString *loadingFootTitle;

//加载完成底部按钮显示文字
@property (nonatomic, copy) NSString *finishedFootTitle;

@property (nonatomic, weak) UIImageView *logo;

// 0 endrefreshing 1 nomoredata
@property (nonatomic, assign) BOOL type;
@end


@implementation LoganRefreshFooter

- (void)prepare {
    [super prepare];

    self.loadingFootTitle = SCBottomRefreshingTitle;
    
    self.finishedFootTitle = SCBottomNormalTitle;
 
    /** 上拉菊花 */
    self.bottomFlower = [self createActivityIndicatorView];//菊花
    
    [self createImageView];
    
    self.logo.hidden = true;
}

- (void)placeSubviews {
    [super placeSubviews];
 
    /** 设置底部内边距 */
    self.scrollView.contentInset = UIEdgeInsetsMake(_scrollViewOrginInsets.top, 0, self.bottomHeight, 0);
    
    _scrollViewOrginInsets = self.scrollView.contentInset;
    
    if (self.type) return;
    
    [self changeFrame];
    
}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
    
    [super scrollViewContentSizeChange:change];
    
    if (self.type == 0) {
        [self changeFrame];
    } else {
        self.logo.hidden = false;
        
        /////底部边距
        self.bottomHeight = 150;
        
        self.scrollView.contentInset = UIEdgeInsetsMake(_scrollViewOrginInsets.top, _scrollViewOrginInsets.top, self.bottomHeight, _scrollViewOrginInsets.top);
        
        self.logo.y = self.scrollView.contentSize.height + (self.bottomHeight - self.logo.height) / 2.0 - self.logo.height / 2.0;
        
        /////间距
        self.bottomButton.y = CGRectGetMaxY(self.logo.frame) + 10;
        
        self.bottomFlower.centerY = self.bottomButton.centerY;
        
        [self setNeedsLayout];
        
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height + self.bottomHeight - [UIScreen mainScreen].bounds.size.height + 64) animated:true];
        
        self.finishedFootTitle = @"没有更多了";
        
        [self revertState:false];

    }
    
    
    
}

- (void)endRefreshing {
    [super endRefreshing];
    
    self.type = 0;
    
    self.bottomHeight = SCBottomHeight;
    
    [self setNeedsLayout];
    
    self.logo.hidden = true;
    
    self.finishedFootTitle = _finishedFootTitle;
    
    [self revertState:false];
}

- (void)endNoMoreDataRefreshing {
    [super endNoMoreDataRefreshing];
    
    self.type = 1;
    
    self.logo.hidden = false;
    
    /////底部边距
    self.bottomHeight = 150;

    self.scrollView.contentInset = UIEdgeInsetsMake(_scrollViewOrginInsets.top, _scrollViewOrginInsets.top, self.bottomHeight, _scrollViewOrginInsets.top);

    self.logo.y = self.scrollView.contentSize.height + (self.bottomHeight - self.logo.height) / 2.0 - self.logo.height / 2.0;
    
    /////间距
    self.bottomButton.y = CGRectGetMaxY(self.logo.frame) + 10;

    self.bottomFlower.centerY = self.bottomButton.centerY;
    
    [self setNeedsLayout];

    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height + self.bottomHeight - [UIScreen mainScreen].bounds.size.height + 64) animated:true];
    
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
    } else {
        [self.bottomButton setTitle: self.finishedFootTitle forState:UIControlStateNormal];
    }
}


- (void)changeFrame {
    
    self.logo.y = self.scrollView.contentSize.height + 5;
    
    self.logo.centerX = self.scrollView.centerX - self.scrollView.x;
    
    self.bottomButton.centerX = self.scrollView.centerX - self.scrollView.x;
    
    self.bottomButton.y = self.scrollView.contentSize.height + (SCBottomHeight - self.bottomButton.height) / 2.0;
    
    self.bottomFlower.centerY = self.bottomButton.centerY;
    
    self.bottomFlower.x = self.scrollView.centerX - self.bottomButton.width / 2.0 - self.bottomFlower.width - 20;
    
    //    self.bottomButton.hidden = self.scrollView.contentSize.height == 0 ? true: false;
    
}

/** 创建箭头 */
- (void)createImageView {

    UIImage * arrowImage = [UIImage imageNamed:@"refresh"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
    
    imageView.size = CGSizeMake(54, 54);
    
    [self addSubview:imageView];
    
    self.logo = imageView;
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

@end
