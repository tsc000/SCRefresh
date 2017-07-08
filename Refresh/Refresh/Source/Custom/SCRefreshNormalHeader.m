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
    
    self.timeLabel.hidden = true;
    
    self.topArrowImageView.size = CGSizeMake(15, 30);
    
    [self updateFrame];

}

/** 监听ContentSize改变事件 */
- (void)scrollViewContentSizeChange:(NSDictionary *)change {
    
    [super scrollViewContentSizeChange:change];

    [self updateFrame];
 
}

- (void)updateFrame {
    self.topFlower.center = CGPointMake(self.timeLabel.x - 10, self.topFlower.centerY);
    
    self.topArrowImageView.center = self.topFlower.center;
    
    self.stateLabel.centerY = self.topFlower.centerY;
}

@end
