//
//  SCRefreshNormalHeader.m
//  Refresh
//
//  Created by tsc on 2017/7/7.
//  Copyright © 2017年 DMS. All rights reserved.
//

#import "SCRefreshNormalHeader.h"

@implementation SCRefreshNormalHeader

- (void)prepare {
    [super prepare];
}

- (void)placeSubviews {
    
    [super placeSubviews];
    
    self.time.hidden = true;
    
    self.remind.centerY = self.topFlower.centerY;
}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
    
    [super scrollViewContentSizeChange:change];

    self.remind.centerY = self.topFlower.centerY;
}


@end
