//
//  SCRefreshNormalFooter.h
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshFooter.h"

@interface SCRefreshNormalFooter : SCRefreshFooter

//加载中底部按钮显示文字
@property (nonatomic, copy) NSString *loadingFootTitle;

//加载完成底部按钮显示文字
@property (nonatomic, copy) NSString *finishedFootTitle;

@end
