//
//  SCRefreshStateHeader.m
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshStateHeader.h"

@interface SCRefreshStateHeader()
{
    NSDate *_lastRefreshDate; /** 保存刷新时间 */
    RefreshState _oldstate;
}

@end

@implementation SCRefreshStateHeader

- (void)prepare {
    [super prepare];
    
    /** 提示 */
    self.stateLabel = [self createLabelWithSize:CGSizeMake(160, 24) Title: SCTopNormalTitle];
    
    /** 时间 */
    self.timeLabel = [self createLabelWithSize:CGSizeMake(160, 24) Title:@"最后更新: 暂无更新"];

    /** 箭头 */
    [self createImageViewWithSize:CGSizeMake(15, 45)];
    
    /** 菊花 */
    self.topFlower = [self createActivityIndicatorViewWithSize:CGSizeMake(50/375 * self.scrollView.width, 50/375 * self.scrollView.width)];
    
    self.timeLabel.text = [self getLastRefreshTime:SCLastRefreshTime];
}

- (void)placeSubviews {

    [super placeSubviews];

    [self changeFrame];
}

- (void)endRefreshing {
    [super endRefreshing];
    
    [self revertstate:false];
    
    [self updateRefreshTime];
}

/** 更新刷新时间 */
- (void)updateRefreshTime {
    
    NSDate *date = [NSDate date];
    
    _lastRefreshDate = date;
    
    [self setRefreshTime:date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH:mm"];
    
    self.timeLabel.text = [NSString stringWithFormat:@"最后更新: 今天 %@",[formatter stringFromDate:date]];
}

- (void)scrollViewContentOffsetChange:(NSDictionary *)change {
    [super scrollViewContentOffsetChange:change];

}

- (void)setState:(RefreshState)state {
    
    //防止重复调用
    SCStateCheck();

    switch (state) {
        case RefreshStateRefreshing:
            
            [self revertstate:true];
            
            break;
        case RefreshStateNormal:{
            
            [UIView animateWithDuration:SCDurationTime animations:^{
                
                self.topArrowImageView.transform = CGAffineTransformIdentity;
                
                self.stateLabel.text = self.stateTitles[@(self.state)];
            }];
            
            break;
        }
       
        case RefreshStatePulled: {
            
            [UIView animateWithDuration:SCDurationTime animations:^{
                
                self.topArrowImageView.transform = CGAffineTransformRotate(self.topArrowImageView.transform, 0.000001 - M_PI);
                
                self.stateLabel.text = self.stateTitles[@(self.state)];
            }];
            
            break;
        }

    }
    
}

- (void)revertstate:(BOOL)state {
    self.topArrowImageView.hidden = state;
    
    self.topFlower.hidden = !state;

    self.stateLabel.text = self.stateTitles[@(self.state)];
    
    state ? [self.topFlower startAnimating] : [self.topFlower stopAnimating];
}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
    
    [super scrollViewContentSizeChange:change];
    
    [self changeFrame];
}

- (void)changeFrame {

    CGFloat centerX = self.scrollView.centerX - self.scrollView.x;
    
    self.stateLabel.center = CGPointMake(centerX, -SCTopHeight + 14);

    self.timeLabel.center = CGPointMake(centerX, CGRectGetMaxY(self.stateLabel.frame) + self.timeLabel.height / 2.0);

    self.topFlower.center = CGPointMake(self.timeLabel.x - 40, - SCTopHeight / 2.0 );
    
    self.topArrowImageView.center = self.topFlower.center;

}

- (void)setTitle:(NSString *)title forState:(RefreshState) state {
    
    if (!title) { return; }
    
    [super setTitle:title forState:state];
    
    self.stateTitles[@(state)] = title;
    
    self.stateLabel.text = self.stateTitles[@(state)];
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

/** 创建菊花 */
- (UIActivityIndicatorView *)createActivityIndicatorViewWithSize:(CGSize)size {
    
    UIActivityIndicatorView *flower = [[UIActivityIndicatorView alloc] init];
    
    flower.size = size;
    
    flower.hidden = true;
    
    [flower setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self addSubview:flower];
    
    return flower;
}

/** 创建标签 */
- (UILabel *)createLabelWithSize:(CGSize)size Title:(NSString *)title{
    
    UILabel *textLabel = [[UILabel alloc] init];

    textLabel.size = size;

    textLabel.text = title;
    
    textLabel.textColor = SCRefreshColor(90, 90, 90);
    
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    [self addSubview:textLabel];
    
    return textLabel;
}

/** 创建箭头 */
- (void)createImageViewWithSize:(CGSize)size {
    
    NSBundle *bundleString = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[SCRefreshStateHeader class]] pathForResource:@"SCRefresh" ofType:@"bundle"]];
    
    UIImage * arrowImage = [[UIImage imageWithContentsOfFile:[bundleString pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
    
    imageView.size = size;
    
    [self addSubview:imageView];
    
    self.topArrowImageView = imageView;
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
