//
//  DashLineView.h
//  GuDaShi
//
//  Created by 伟南 陈 on 2018/1/24.
//  Copyright © 2018年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DashLineView : UIControl

/**
 实线颜色
 */
@property (strong, nonatomic) IBInspectable UIColor *lineColor;

/**
 实线长
 */
@property (assign, nonatomic) IBInspectable CGFloat lineLength;

/**
 空白间隔
 */
@property (assign, nonatomic) IBInspectable CGFloat lineSpace;

/**
 是否沿着四周绘制，默认为no，即只沿水平或竖直方向绘制
 */
@property (assign, nonatomic) IBInspectable BOOL drawAround;

/**
 实现宽度，仅在drawAround=YES时生效
 */
@property (assign, nonatomic) IBInspectable CGFloat lineWidth;

@end
