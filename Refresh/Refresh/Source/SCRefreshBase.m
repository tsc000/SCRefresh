//
//  SCRefreshBase.m
//  SCRefresh
//
//  Created by tsc on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

// 1 collectionView  刷新之后上滑不流畅
// 2 scrollView 控件摆放x位置不对,没有根据scrollview居中
// 3 下拉控件怎么实时显示到最底层
// 4 performSelector 警告
// 5 观察者被移除问题

#import "SCRefreshBase.h"

@interface SCRefreshBase ()
{
    /** 内边距，用于恢复下拉刷新完成之后控件的显示样式 */
    UIEdgeInsets _scrollViewOrginInsets;
}

/** 下拉状态 */
@property (nonatomic, assign) RefreshStatus status;
/** 上拉状态 */
@property (nonatomic, assign) BOOL bottomRefreshStatus;

@property (nonatomic, copy) RefreshBlock header;
@property (nonatomic, copy) RefreshBlock footer;

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL topAction;
@property (assign, nonatomic) SEL bottomAction;

@end

@implementation SCRefreshBase

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.status = RefreshStateNormal;
        
    }
    return self;
}

- (void)innerRefresh:(RefreshOptions)type {
    
    switch (type) {
        case RefreshOptionHeader: {
            
            self.status == RefreshStateNormal ? [self manualRefresh]:[self automaticRefresh];

            break;
        }
            
        case RefreshOptionFooter: {
            
            [self bottomRefresh];
            
            break;
        }
        default:
            break;
    }
}

/** 正常手动进行的下拉刷新 */
- (void)manualRefresh {
    
    [UIView animateWithDuration:SCDisappearTime animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, -SCRefreshHeight - 5);
        
    }];
    
    //这里只是让刷新有短暂的停留
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCRemainTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //Block方式执行
        if (self.header) self.header();
        
        //Target方式执行
        if ([self.target respondsToSelector:self.topAction] ) {
            
            SuppressPerformSelectorLeakWarning([self.target performSelector:self.topAction];);
        }
        
        [UIView animateWithDuration:SCDisappearTime animations:^{
            
            self.scrollView.contentOffset = CGPointZero;
            
        }];
        
    });
    
}

/** 直接调用刷新代码进行的下拉刷新 */
- (void)automaticRefresh {
    
    [UIView animateWithDuration: SCDisappearTime animations:^{
        
        self.scrollView.contentInset = UIEdgeInsetsMake(SCRefreshHeight, 0, _scrollViewOrginInsets.bottom, 0);
        
    }];
    
    //这里只是让刷新有短暂的停留
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCRemainTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.header) self.header();
        
        if ([self.target respondsToSelector:self.topAction] ) SuppressPerformSelectorLeakWarning([self.target performSelector:self.topAction];);
        
    });
}

/** 底部刷新 */
- (void)bottomRefresh {
    
    if ([self isRefreshWithRefreshType:RefreshOptionFooter]) return;
    
    _bottomRefreshStatus = true;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.48 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //Block方式执行
        if (self.footer) self.footer();
        
        //Target方式执行
        if (self.bottomAction) SuppressPerformSelectorLeakWarning([self.target performSelector:self.bottomAction];);
        
    });
    
    [self beginRefreshRefreshType:RefreshOptionFooter];
    
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
        
        //如果是创建下拉刷新，header
        if ((self.option & RefreshOptionHeader) == RefreshOptionHeader) {
            [self setupHeaderWithSuperview:newSuperview];
        }
        
        //如果是创建上拉加载，footer
        if ((self.option & RefreshOptionFooter) == RefreshOptionFooter) {
            [self setupFooterWithSuperview:newSuperview];
        }
    }
    
}

- (void)removeFromSuperview {
    
    [self removeObserver];
    
    [super removeFromSuperview];
    
}

#pragma mark- 创建上拉控件和下拉控件
/** 为下拉刷新控件添加子控件 */
- (void)setupHeaderWithSuperview:(UIView *)newSuperview {
}

/** 为上拉加载更多控件添加子控件 */
- (void)setupFooterWithSuperview:(UIView *)newSuperview {

    /** 设置底部内边距 */
    self.scrollView.contentInset = UIEdgeInsetsMake(_scrollViewOrginInsets.top, 0, SCBottomHeight, 0);
    _scrollViewOrginInsets = self.scrollView.contentInset;

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

+ (instancetype)refreshWithHeader:(RefreshBlock)header Footer:(RefreshBlock)footer {
    SCRefreshBase *refresh = [[self alloc] init];
    
    //表明需要以Block方式建立下拉刷新
    if (header) {
        
        refresh.header = header;
        
        refresh.option |= RefreshOptionHeader;
    }
    
    //表明需要以Block方式建立上拉加载,
    if (footer) {
        
        refresh.footer = footer;
        
        refresh.option |= RefreshOptionFooter;
    }
    
    return refresh;
}

#pragma mark- 添加刷新方法
+ (instancetype)refreshWithTarget:(id)target HeaderAction:(SEL)headerAction FooterAction:(SEL)footerAction {
    
    if (!target) return nil;
    
    SCRefreshBase *refresh = [[self alloc] init];
    
    refresh.target = target;
    
    //表明需要建立下拉刷新
    if (headerAction && [target respondsToSelector:headerAction]) {
        
        refresh.option |= RefreshOptionHeader;
        
        refresh.topAction = headerAction;
    }
    
    //表明需要建立上拉加载
    if (headerAction && [target respondsToSelector:footerAction]) {
        
        refresh.option |= RefreshOptionFooter;
        
        refresh.bottomAction = footerAction;
    }
    
    return refresh;
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

    CGFloat orginY = -[change[@"new"] CGPointValue].y;
    
    CGFloat calculateY = orginY - _scrollViewOrginInsets.top;
    
    //下拉刷新存在
    if (self.option & RefreshOptionHeader) {
        
        //下拉已经在刷新
        if (self.status == RefreshStateRefresh) return;
        
        //正在Dragging:其下有两种情况，一是小于刷新控件高度 二是大于刷新控件高度
        if (self.scrollView.isDragging) {
            
            //下面是临界(刷新控件完全出来)两个状态的相互转换
            if (calculateY >= SCRefreshHeight && self.status == RefreshStateNormal){
                self.status = RefreshStatePulled;
                NSLog(@"RefreshStatePulled");
            }
            else if (calculateY < SCRefreshHeight && self.status == RefreshStatePulled) {
                self.status = RefreshStateNormal;
            }
            
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

        }
        //释放但已经超过刷新控件高度
        else if (self.status == RefreshStatePulled) {
            self.status = RefreshStateRefresh; //变成刷新状态
        }
        //正常状态
        else if (self.status == RefreshStateNormal) {
            
        }
        
        
    }

    //上拉加载存在
    if (self.option & RefreshOptionFooter) {
        
        if (_bottomRefreshStatus) return;
        
        //上拉加载更多
        if (self.scrollView.frame.size.height > self.scrollView.contentSize.height) {
            
            if (self.scrollView.contentOffset.y > SCBottomHeight) {
                if (!_bottomRefreshStatus) {
                    
                    if (self.scrollView.contentSize.height) {
                        
                        [self bottomRefresh];
                    }
                    
                }
            }
            
        }
        else if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height - self.scrollView.contentSize.height > SCBottomHeight && self.scrollView.isDragging && [change[@"new"] CGPointValue].y > [change[@"old"] CGPointValue].y) {
            
            if (!_bottomRefreshStatus) {
                [self bottomRefresh];
            }
        }
        
    }

}

#pragma mark- 刷新操作
/** 设置状态并操作 */
- (void)setStatus :(RefreshStatus)status {
    _status = status;

    switch (status) {
        case RefreshStateNormal: {

            if ([self.delegate respondsToSelector:@selector(normalStatus)]) {
                [self.delegate performSelector:@selector(normalStatus)];
            }
            
            break;
        }
            
        case RefreshStatePulled:{
            
            if ([self.delegate respondsToSelector:@selector(pulledStatus)]) {
                [self.delegate performSelector:@selector(pulledStatus)];
            }
            
            break;
        }
            
        case RefreshStateRefresh:{
            
            if ([self.delegate respondsToSelector:@selector(refreshStatus)]) {
                [self.delegate performSelector:@selector(refreshStatus)];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)endRefreshRefreshType:(RefreshOptions)type {

    //底部刷新三个控件都一样
    if ((type & RefreshOptionFooter) == RefreshOptionFooter) {
        
        _bottomRefreshStatus = false;
    }
    
    //顶部刷新Collection单独处理
    if ([self.scrollView isKindOfClass:[UICollectionView class]] && ((type & RefreshOptionHeader) == RefreshOptionHeader)) {
        
        //collectionView不延时下拉之后不流畅
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self restorePostion];
        });
    }
    else if ((type & RefreshOptionHeader) == RefreshOptionHeader){
        
        [self restorePostion];
    }
  
}

/** 恢复原来的位置 */
- (void)restorePostion {

    if (self.status == RefreshStateRefresh || self.status == RefreshStateNormal) {
        
        self.status = RefreshStateNormal;
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.scrollView.contentInset = _scrollViewOrginInsets;
            
        }];
        
    }
}

- (void)beginRefreshRefreshType:(RefreshOptions)type {
 
    [self innerRefresh:type];
}

- (BOOL)isRefreshWithRefreshType:(RefreshOptions)type {
    
    if (type == RefreshOptionHeader && self.status == RefreshStateRefresh) {
        return true;
    }
    
    if (type == RefreshOptionFooter) {
        return _bottomRefreshStatus;
    }
    
    return false;
}

#pragma mark - 处理时间
/** 获取最后一次更新时间 */
- (NSString *)getLastRefreshTime:(NSString *)key{
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (lastUpdatedTime) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day] && [cmp1 month] == [cmp2 month]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        return [NSString stringWithFormat:@"最后更新：%@", time];
    } else {
        return @"最后更新：无记录";
    }
}

/** 设置当前更新时间 */
- (void)setRefreshTime:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:SCLastRefreshTime];
}

@end


@implementation UIScrollView (ScrollViewRefresh)

/** 利用分类 和 runtime 添加 refresh 属性的set方法 */
-(void)setRefresh:(SCRefreshBase *)refresh{
    
    if (refresh != self.refresh) {
        
        [self.refresh removeFromSuperview];
        
        //这里会触发willMoveToSuperview方法，所有对refresh做的操作都在这个方法里
        [self addSubview:refresh];
        
        [self willChangeValueForKey:Refresh];
        objc_setAssociatedObject(self, &RefreshKey, refresh,OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:Refresh];
    }
    
}

/** 利用分类 和 runtime 添加 refresh 属性的get方法 */
-(SCRefreshBase *)refresh{
    return objc_getAssociatedObject(self, &RefreshKey);
}

@end
