//
//  SCRefreshBase.h
//  SCRefresh
//
//  Created by tsc on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SCExtension.h"
#import "SCCommon.h"
#import "objc/runtime.h"

@class SCRefreshBase;


@protocol SCRefreshBaseDelegate <NSObject>

- (void)normalStatus;
- (void)refreshStatus;
- (void)pulledStatus;

@optional
- (void)normal2pulled:(CGFloat)contentOffSide;
- (void)pulled2nomal:(CGFloat)contentOffSide;
@end

typedef void (^RefreshBlock)();

@interface SCRefreshBase : UIView

/** 保存的是哪种控件类型的上的刷新，scrollView,tableView,collectionView */
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) id delegate;

/** 上拉下拉 */
@property (nonatomic, assign) RefreshOptions option;

//加载中底部按钮显示文字
@property (nonatomic, copy) NSString *loadingFootTitle;

//加载完成底部按钮显示文字
@property (nonatomic, copy) NSString *finishedFootTitle;

/** 以Block方式创建刷新任务 */
+ (instancetype)refreshWithHeader:(RefreshBlock)header Footer:(RefreshBlock)footer;

/** 以Action方式创建刷新任务 */
+ (instancetype)refreshWithTarget:(id)target HeaderAction:(SEL)headerAction FooterAction:(SEL)footerAction;

/** 结束刷新 */
- (void)endRefreshRefreshType:(RefreshOptions)type;

/** 开始刷新 */
- (void)beginRefreshRefreshType:(RefreshOptions)type;

/** 判断刷新状态 */
- (BOOL)isRefreshWithRefreshType:(RefreshOptions)type;

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change;

/** 监听滚动事件 */
- (void)scrollViewContentOffsetChange:(NSDictionary *)change;

/** 为下拉刷新控件添加子控件 */
- (void)setupHeaderWithSuperview:(UIView *)newSuperview;

/** 为上拉加载更多控件添加子控件 */
- (void)setupFooterWithSuperview:(UIView *)newSuperview;

/** 获取最后一次更新时间 */
- (NSString *)getLastRefreshTime:(NSString *)key;

/** 设置当前更新时间 */
- (void)setRefreshTime:(NSDate *)date;

@end

@interface UIScrollView (ScrollViewRefresh)

/** 在分类中给UIScrollView添加一个属性，这个属性可以用runtime添加一个set get方法 */
@property (nonatomic, weak) SCRefreshBase *refresh;

@end

