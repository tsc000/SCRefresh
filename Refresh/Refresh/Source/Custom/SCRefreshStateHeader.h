//
//  SCRefreshStateHeader.h
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshHeader.h"

@interface SCRefreshStateHeader : SCRefreshHeader

/** 顶部箭头 */
@property (nonatomic, strong) UIImageView *imageView;

/** 顶部提示 */
@property (nonatomic, weak) UILabel *remind;

/** 顶部菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *topFlower;

/** 顶部刷新时间Label */
@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) NSMutableDictionary *stateTitles;

@end
