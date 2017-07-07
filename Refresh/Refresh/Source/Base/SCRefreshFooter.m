//
//  SCRefreshFooter.m
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshFooter.h"

@interface SCRefreshFooter()

/** 上拉状态 */
@property (nonatomic, assign) BOOL bottomRefreshState;

@end

@implementation SCRefreshFooter

#pragma mark - 类方法
+ (instancetype)footerWithRefreshingCallBack: (SCRefreshComponentRefreshingBlock)callBack {
    SCRefreshFooter *footer = [[self alloc] init];
    footer.refreshingBlock = callBack;
    return footer;
}

+ (instancetype)footerWithTarget:(id)target action:(SEL)action {
    SCRefreshFooter *footer = [[self alloc] init];
    footer.target = target;
    footer.action = action;
    return footer;
}

#pragma mark - 准备工作
- (void)prepare {
    [super prepare];
    
    self.bottomHeight = SCBottomHeight;
}

- (void)placeSubviews {
    [super placeSubviews];
}

#pragma mark - 刷新
- (void)endRefreshing {
    [super endRefreshing];
    
    _bottomRefreshState = false;
}

/** 没有更多数据 */
- (void)endNoMoreDataRefreshing {
    _bottomRefreshState = false;
}

- (BOOL)isRefreshing {
    return _bottomRefreshState;
}

- (void)bottomRefresh {
    
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
    
    if ([self.target respondsToSelector:self.action]) {
        SuppressPerformSelectorLeakWarning([self.target performSelector:self.action]);
    }
}

#pragma mark - 监听ContentOffset
- (void)scrollViewContentOffsetChange:(NSDictionary *)change {
    [super scrollViewContentOffsetChange:change];

    if ([self isRefreshing]) return;

    //暂定height< 0 ,不显示底部刷新
    if (self.scrollView.contentSize.height <= 0) { return; }

    //上拉加载更多
    if (self.scrollView.frame.size.height > self.scrollView.contentSize.height) {

        if (self.scrollView.contentOffset.y > self.bottomHeight) {

            _bottomRefreshState = true;
            
            [self bottomRefresh];
        }

    }
    else {
        
        if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height - self.scrollView.contentSize.height > self.bottomHeight && self.scrollView.isDragging && [change[@"new"] CGPointValue].y > [change[@"old"] CGPointValue].y) {

            _bottomRefreshState = true;
            
            [self bottomRefresh];
            
        }
    }
  
}

@end

@implementation UIScrollView (RefreshFooter)

/** 利用分类 和 runtime 添加 refresh 属性的set方法 */
-(void)setSc_footer:(SCRefreshFooter *)sc_footer {
    
    if (sc_footer != self.sc_footer) {
        
        [self.sc_footer removeFromSuperview];
        
        //这里会触发willMoveToSuperview方法，所有对refresh做的操作都在这个方法里
        [self addSubview:sc_footer];
        
        [self willChangeValueForKey:RefreshFooter];
        objc_setAssociatedObject(self, &RefreshFooterKey, sc_footer,OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:RefreshFooter];
    }
    
}

/** 利用分类 和 runtime 添加 refresh 属性的get方法 */
-(SCRefreshFooter *)sc_footer{
    return objc_getAssociatedObject(self, &RefreshFooterKey);
}

@end
