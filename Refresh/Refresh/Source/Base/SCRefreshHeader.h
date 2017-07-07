//
//  SCRefreshHeader.h
//  Refresh
//
//  Created by 童世超 on 2017/7/4.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshComponent.h"

@interface SCRefreshHeader : SCRefreshComponent<SCRefreshComponentDelegate>

+ (instancetype)headerWithRefreshingCallBack: (SCRefreshComponentRefreshingBlock)callBack;

+ (instancetype)headerWithTarget:(id)target action:(SEL)action;

- (void)normal2pulled:(CGFloat)contentOffSide;

- (void)pulled2nomal:(CGFloat)contentOffSide;
@end

@interface UIScrollView (RefreshHeader)

/** 在分类中给UIScrollView添加一个属性，这个属性可以用runtime添加一个set get方法 */
@property (nonatomic, weak) SCRefreshHeader *sc_header;

@end
