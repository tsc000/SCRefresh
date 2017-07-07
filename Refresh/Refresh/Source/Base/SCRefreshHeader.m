//
//  SCRefreshHeader.m
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshHeader.h"

@implementation SCRefreshHeader

#pragma mark - 类方法
+ (instancetype)headerWithRefreshingCallBack:(SCRefreshComponentRefreshingBlock)callBack {
    SCRefreshHeader *header = [[self alloc] init];
    header.refreshingBlock = callBack;
    return header;
}

+ (instancetype)headerWithTarget:(id)target action:(SEL)action {
    SCRefreshHeader *header = [[self alloc] init];
    header.target = target;
    header.action = action;
    return header;
}

#pragma mark - 准备工作
- (void)prepare {
    [super prepare];
    
    [self setTitle:SCTopNormalTitle forState:RefreshStateNormal];
    
    [self setTitle:SCTopPulledTitle forState:RefreshStatePulled];
    
    [self setTitle:SCTopRefreshingTitle forState:RefreshStateRefreshing];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.delegate = self;
}

#pragma mark - 刷新
- (void)endRefreshing {
    [super endRefreshing];

    //顶部刷新Collection单独处理
    if ([self.scrollView isKindOfClass:[UICollectionView class]] ) {

        //collectionView不延时下拉之后不流畅
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self regainPostion];
        });
    }
    else {

        [self regainPostion];
    }

}

- (BOOL)isRefreshing {
    return self.state == RefreshStateRefreshing;
}

- (void)beginRefreshing {

    //防止手动下拉刷新之后，再代码刷新
    if ([self isRefreshing]) return;
    
    [super beginRefreshing];

    //等待主线程执行完，再执行刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:SCDurationTime animations:^{
            
            [self.scrollView setContentOffset:CGPointMake(0, -SCTopHeight - 5) animated:false];
            
        } completion:^(BOOL finished) {
            
            self.state = RefreshStateRefreshing;
            
        }];
        
    });

}

/** 恢复原来的位置 */
- (void)regainPostion {

    if (self.state == RefreshStateRefreshing || self.state == RefreshStateNormal) {

        self.state = RefreshStateNormal;

        [UIView animateWithDuration:SCDurationTime animations:^{

            self.scrollView.contentInset = _scrollViewOrginInsets;

        }];

    }
}

/** 设置状态并操作 */
- (void)setState :(RefreshState)state {
    [super setState:state];
    
    if (state == RefreshStateRefreshing) {
    
        //由于无法得知header和footer谁先添加到superView上，故_scrollViewOrginInsets只有在这里一次次的设置
        _scrollViewOrginInsets = self.scrollView.contentInset;
        
        [UIView animateWithDuration: SCDurationTime animations:^{
    
            self.scrollView.contentInset = UIEdgeInsetsMake(SCTopHeight, 0, self.scrollView.contentInset.bottom, 0);
    
        } completion:^(BOOL finished) {
            
            if (self.refreshingBlock) {
                self.refreshingBlock();
            }

            if ([self.target respondsToSelector:self.action]) {
                SuppressPerformSelectorLeakWarning([self.target performSelector:self.action]);
            };
            
        }];
    }
}

#pragma mark - 监听ContentOffset
- (void)scrollViewContentOffsetChange:(NSDictionary *)change {
    [super scrollViewContentOffsetChange:change];
    
    CGFloat orginY = -[change[@"new"] CGPointValue].y;
    
    CGFloat calculateY = orginY - _scrollViewOrginInsets.top;

    //正在Dragging:其下有两种情况，一是小于刷新控件高度 二是大于刷新控件高度
    if (self.scrollView.isDragging) {
        
        //下面是临界(刷新控件完全出来)两个状态的相互转换
        if (calculateY >= SCTopHeight && self.state == RefreshStateNormal){
            self.state = RefreshStatePulled;
        } else if (calculateY < SCTopHeight && self.state == RefreshStatePulled) {
            self.state = RefreshStateNormal;
        }
        
        ///处理代理
        if (calculateY > 0 && [change[@"new"] CGPointValue].y <  [change[@"old"] CGPointValue].y) {
            
            if ([self.delegate respondsToSelector:@selector(normal2pulled:)]) {
                [self.delegate normal2pulled:[change[@"new"] CGPointValue].y];
            }
        }
        
        if (calculateY > 0 && [change[@"new"] CGPointValue].y >  [change[@"old"] CGPointValue].y) {
            
            if ([self.delegate respondsToSelector:@selector(pulled2nomal:)]) {
                [self.delegate pulled2nomal:[change[@"new"] CGPointValue].y];
            }
            
        }

    } else  { //非Dragging
        
        if (self.state == RefreshStatePulled) {
            self.state = RefreshStateRefreshing; //变成刷新状态
        }
        //正常状态
        else if (self.state == RefreshStateNormal) {
        }

    }
}

#pragma mark - SCRefreshComponentDelegate
- (void)normal2pulled:(CGFloat)contentOffSide {
    
}

- (void)pulled2nomal:(CGFloat)contentOffSide {

}

@end

@implementation UIScrollView (RefreshHeader)

/** 利用分类 和 runtime 添加 refresh 属性的set方法 */
-(void)setSc_header:(SCRefreshHeader *)sc_header {
    
    if (sc_header != self.sc_header) {
        
        [self.sc_header removeFromSuperview];
        
        //这里会触发willMoveToSuperview方法，所有对refresh做的操作都在这个方法里
        [self addSubview:sc_header];
        
        [self willChangeValueForKey:RefreshHeader];
        objc_setAssociatedObject(self, &RefreshHeaderKey, sc_header,OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:RefreshHeader];
    }
    
}

/** 利用分类 和 runtime 添加 refresh 属性的get方法 */
-(SCRefreshComponent *)sc_header{
    return objc_getAssociatedObject(self, &RefreshHeaderKey);
}

@end
