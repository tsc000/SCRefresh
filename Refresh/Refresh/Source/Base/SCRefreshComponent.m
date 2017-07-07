//
//  SCRefreshComponent.m
//  SCRefresh
//
//  Created by 童世超 on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

// 1 collectionView  刷新之后上滑不流畅
// 2 scrollView 控件摆放x位置不对,没有根据scrollview居中
// 3 下拉控件怎么实时显示到最底层
// 4 performSelector 警告
// 5 观察者被移除问题

#import "SCRefreshComponent.h"

@implementation SCRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 准备工作
        [self prepare];
        
        // 默认是普通状态
        self.state = RefreshStateNormal;
    }
    return self;
}

- (void)prepare {
}

- (void)placeSubviews {
}

- (void)layoutSubviews {
    
    [self placeSubviews];
    
    [super layoutSubviews];
}

#pragma mark- 从父类上移动或添加
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    //确保newSuperView是UIScrollView类型的
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        
        //移动先前观察者
        [self removeObserver];
        
        //scrollView属性保存谁在使用刷新
        self.scrollView = (UIScrollView *)newSuperview;
        
        self.scrollView.alwaysBounceVertical = true;

        //保存scrollView中的原始内边距
        _scrollViewOrginInsets = self.scrollView.contentInset;
        
        //为scrollView添加观察者
        [self addObserver];

    }
    
}

- (void)removeFromSuperview {
    
    [self removeObserver];
    
    [super removeFromSuperview];
    
}

#pragma mark- 处理观察者
/** 移除观察者 */
- (void)removeObserver {
    
    [self.superview removeObserver:self forKeyPath:SCContentOffset];
    
    [self.superview removeObserver:self forKeyPath:SCContentSize];
}

/** 添加观察者 */
- (void)addObserver {
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    
    [self.scrollView addObserver:self forKeyPath:SCContentOffset options:options context:nil];
    
    [self.scrollView addObserver:self forKeyPath:SCContentSize options:options context:nil];
}

#pragma mark- 处理监听事件
/** 监听属性 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:SCContentOffset]) {
        
        [self scrollViewContentOffsetChange:change];
        
    }
    else if ([keyPath isEqualToString:SCContentSize]) {
        
        [self scrollViewContentSizeChange:change];
        
    }

}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
}

/** 监听滚动事件 */
- (void)scrollViewContentOffsetChange:(NSDictionary *)change {
}

- (void)setTitle:(NSString *)title forState:(RefreshState)state {
}

#pragma mark- 刷新操作
/** 设置状态并操作 */
- (void)setState:(RefreshState)state {
    _state = state;
}

- (void)endRefreshing {
}

- (void)beginRefreshing {
}

- (BOOL)isRefreshing {
    return false;
}

@end

