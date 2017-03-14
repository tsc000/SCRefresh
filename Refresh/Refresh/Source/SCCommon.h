//
//  SCCommon.h
//  Refresh
//
//  Created by tsc on 17/2/17.
//  Copyright © 2017年 DMS. All rights reserved.
//

#ifndef SCCommon_h
#define SCCommon_h

#define SCContentOffset @"contentOffset"
#define SCContentSize @"contentSize"

#define SCLastRefreshTime (@"LastRefreshTime")
#define SCRefreshResourceName(file) [@"SCRefresh.bundle" stringByAppendingPathComponent:file]

//下拉刷新
#define SCStaticTopTitle (@"下拉可以刷新")
#define SCScrollTopTitle (@"松开立即刷新")
#define SCRefreshingTopTitle (@"正在刷新数据中...")

//下拉加载
#define SCStaticBottomTitle (@"点击或上拉加载更多")
#define SCRefreshingBottomTitle (@"正在加载更多的数据...")

#define SCDisappearTime (0.3) ///从刷新停留到上面到刷新消失在导航栏之后的时间
#define SCRemainTime (0.8)    ///刷新控件紧挨着导航栏停留的时间
#define SCFinshRemainTime (2.0)    ///有finishedFootTitle的显示时间

///颜色
#define SCRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//控件高度
#define SCRefreshHeight (54)
#define SCBottomHeight (64)

///根据位操作判断下拉和上拉是否添加
typedef NS_OPTIONS(NSUInteger, RefreshOptions) {
    RefreshOptionHeader = 0x01,
    RefreshOptionFooter = 0x02
};

///下拉三种状态
///normal 是未超过设定下拉高度
typedef NS_ENUM(NSInteger, RefreshStatus) {
    RefreshStateNormal = 0,
    RefreshStatePulled,
    RefreshStateRefresh
};


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

static NSString *Refresh = @"refresh";

static const char RefreshKey = '\0';

#endif /* SCCommon_h */
