//
//  RefreshScrollViewController.m
//  Refresh
//
//  Created by tsc on 16/7/14.
//  Copyright © 2016年 DMS. All rights reserved.
//

#import "RefreshScrollViewController.h"
//#import "SCRefresh.h"
#import "SCRefreshStateHeader.h"
#import "SCRefreshNormalFooter.h"

@interface RefreshScrollViewController ()
{
    NSInteger _index;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UILabel *label;

@end

@implementation RefreshScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    self.view .backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 600)];
    
    self.scrollView.contentSize = CGSizeMake(375, 200);

    __weak typeof (self)weakSelf = self;
    
    self.scrollView.sc_header = [SCRefreshStateHeader headerWithRefreshingCallBack:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.label.text = @"小明已经上大三了，还是没有女朋友。在寝室的哥们的怂恿下，他决定去追一个心仪已久的女生一天，他看到那个女生一个人在操场散步，便跟了过去，由于不知如何开口才好，小明心里非常焦急。眼看那个女生越走越远，他只好从地上捡了一样东西，追上去说：“小姐，这块砖头是不是你掉的啊？";
        
                   [weakSelf.scrollView.sc_header endRefreshing];
                });
        
        
    }];
    
    
    self.scrollView.sc_footer = [SCRefreshNormalFooter footerWithRefreshingCallBack:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.label.text = @"小时候看武侠小说里讲的“艺高人胆大”，着实赞同了十几年，直到毕业后走出社会才知道是我错了，现在是“艺高没鸟用，财高人胆大";
    
                _index ++;

    
                [weakSelf.scrollView.sc_footer endNoMoreDataRefreshing];
            });
    }];
    
//    self.scrollView.refresh = [SCRefresh refreshWithHeader:^{
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.label.text = @"小明已经上大三了，还是没有女朋友。在寝室的哥们的怂恿下，他决定去追一个心仪已久的女生一天，他看到那个女生一个人在操场散步，便跟了过去，由于不知如何开口才好，小明心里非常焦急。眼看那个女生越走越远，他只好从地上捡了一样东西，追上去说：“小姐，这块砖头是不是你掉的啊？";
//            
//           [weakSelf.scrollView.refresh endRefreshRefreshType:RefreshOptionFooter | RefreshOptionHeader];
//        });
//
//    } Footer:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.label.text = @"小时候看武侠小说里讲的“艺高人胆大”，着实赞同了十几年，直到毕业后走出社会才知道是我错了，现在是“艺高没鸟用，财高人胆大";
// 
//            _index ++;
//            if (_index >=2) {
//                
//                self.scrollView.refresh.finishedFootTitle = @"竟然没有数据了....";
//                
//            }
//
//            [weakSelf.scrollView.refresh endRefreshRefreshType:RefreshOptionFooter | RefreshOptionHeader];
//        });
//    }];
//    
//    self.scrollView.refresh.loadingFootTitle = @"哈哈，我正在偷网络数据";
    
//self.scrollView.contentSize = CGSizeMake(375, 600);
    [self.view addSubview:self.scrollView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    textLabel.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, 200);
    
    textLabel.textColor = [UIColor blackColor];
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    textLabel.backgroundColor= [UIColor lightGrayColor];
    
    textLabel.font = [UIFont systemFontOfSize:14];
    
    textLabel.numberOfLines = 0 ;
    
    textLabel.text = @"全场卖两块，买啥都两块，两块钱，你买不了吃亏，两块钱，你买不了上当，真正的物有所值。拿啥啥便宜 买啥啥不贵，都两块，买啥都两块，全场卖两块，随便挑，随便选，都两块～～ 全场卖两块，买啥都两块，两块钱，你买不了吃亏，两块钱，你买不了上当，真正的物有所值。拿啥啥便宜 买啥啥不贵，都两块，买啥都两块，全场卖两块，随便挑，随便选，都两块～～ 全场卖两块，买啥都两块，两块钱，你买不了吃亏，两块钱，你买不了上当，真正的物有所值。拿啥啥便宜 买啥啥不贵，都两块，买啥都两块，全场卖两块，随便挑，随便选，都两块～～块，两块钱，你买不了吃亏，两块钱，你买不了上当，真正的物有所值。拿啥啥便宜 买啥啥不贵，都两块，买啥都两块，全场卖两块，随便挑，随便选，都两块～～都两块";
    
    textLabel.textColor = [UIColor yellowColor];
    
    [self.scrollView addSubview:textLabel];
    self.label = textLabel;

}

@end
