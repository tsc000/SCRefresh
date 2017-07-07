//
//  SCRefreshFooter.h
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshComponent.h"

@interface SCRefreshFooter : SCRefreshComponent

@property (nonatomic, assign) CGFloat bottomHeight;

+ (instancetype)footerWithRefreshingCallBack: (SCRefreshComponentRefreshingBlock)callBack;

+ (instancetype)footerWithTarget:(id)target action:(SEL)action;

- (void)bottomRefresh;

/** 没有更多数据 */
- (void)endNoMoreDataRefreshing;

@end

@interface UIScrollView (RefreshFooter)

/** 在分类中给UIScrollView添加一个属性，这个属性可以用runtime添加一个set get方法 */
@property (nonatomic, weak) SCRefreshFooter *sc_footer;

@end
