//
//  SCRefreshComponent.h
//  SCRefresh
//
//  Created by 童世超 on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SCExtension.h"
#import "SCCommon.h"
#import "objc/runtime.h"

@class SCRefreshComponent;

@protocol SCRefreshComponentDelegate <NSObject>

@optional
- (void)normal2pulled:(CGFloat)contentOffSide;
- (void)pulled2nomal:(CGFloat)contentOffSide;

@end

///下拉三种状态
///normal 是未超过设定下拉高度
typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNormal = 0,
    RefreshStatePulled,
    RefreshStateRefreshing
};

typedef void (^SCRefreshComponentRefreshingBlock)();

@interface SCRefreshComponent : UIView
{
    /** 内边距，用于恢复下拉刷新完成之后控件的显示样式 */
    UIEdgeInsets _scrollViewOrginInsets;
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>  属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

/** 保存的是哪种控件类型的上的刷新，scrollView,tableView,collectionView */
@property (nonatomic, weak) UIScrollView *scrollView;

/// 下拉状态
@property (nonatomic, assign) RefreshState state;

/// 代理
@property (nonatomic, weak) id delegate;

/// target
@property (weak, nonatomic) id target;

/// 事件
@property (assign, nonatomic) SEL action;

/// 刷新block
@property (nonatomic, copy) SCRefreshComponentRefreshingBlock refreshingBlock;

//>>>>>>>>>>>>>>>>>>>>>>>>  由子类来实现 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

/** 结束刷新 */
- (void)endRefreshing;

/** 开始刷新 */
- (void)beginRefreshing;

/** 判断刷新状态 */
- (BOOL)isRefreshing;

/** 准备工作 */
- (void)prepare;

/** 设置子控件frame */
- (void)placeSubviews;

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change;

/** 监听滚动事件 */
- (void)scrollViewContentOffsetChange:(NSDictionary *)change;

/** 为每种状态设定文字 */
- (void)setTitle:(NSString *)title forState:(RefreshState) state;

@end

