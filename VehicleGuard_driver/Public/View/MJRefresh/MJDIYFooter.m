//
//  MJDIYFooter.m
//  Xiang_driver
//
//  Created by mac on 2019/5/8.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "MJDIYFooter.h"

@interface MJDIYFooter ()
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation MJDIYFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    self.mj_w = kScreen_W;
    
    // 添加label
    //    _label = [[UILabel alloc] init];
    //    _label.font = [UIFont boldSystemFontOfSize:16];
    //    _label.textAlignment = NSTextAlignmentCenter;
    //    _label.textColor = [UIColor darkGrayColor];
    //    [self addSubview:_label];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_indicator];
    
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
}


-(void)setLoadingTintColor:(UIColor *)loadingTintColor{
    _loadingTintColor = loadingTintColor;
    _indicator.tintColor = loadingTintColor;
}
-(void)setTipColor:(UIColor *)tipColor{
    _tipColor = tipColor;
    //    _label.textColor = tipColor;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    //    self.label.frame = self.bounds;
    //    self.indicator.center = CGPointMake(self.mj_w/2.0-self.indicator.frame.size.width/2.0, self.mj_h/2.0);
    switch (state) {
        case MJRefreshStateIdle:
            //            self.label.text = @"下拉可以刷新";
            [self.indicator stopAnimating];
            break;
        case MJRefreshStatePulling:
            //            self.label.text = @"松开立即刷新";
            [self.indicator startAnimating];
            break;
        case MJRefreshStateRefreshing:
            //            self.label.text = @"正在刷新数据中…";
            //            CGSize size = [self.label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            //            self.label.center = CGPointMake(self.mj_w/2.0+space+indicatorSize.width/2.0, self.mj_h/2.0);
            //            self.indicator.center = CGPointMake(self.mj_w/2.0-size.width/2.0-space-20/2.0+space/2.0+indicatorSize.width/2.0, self.mj_h/2.0-7);
            [self.indicator startAnimating];
            break;
        default:
            break;
    }
}


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}
@end
