//
//  NavigationView.h
//  GuPiaoTong
//
//  Created by songzhaojie on 17/1/12.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface NavigationView : UIView

/**
 隐藏渐变色背景视图
 */
@property (assign, nonatomic) BOOL backImageViewHidden;

@property (assign, nonatomic) UIEdgeInsets leftImageEdge;

- (void)setLeftBtnImage:(NSString *)image;

/**
 设置文字标题
 
 @param title 标题
 @param leftImg 左图片
 */
-(void)setTitle:(NSString*)title leftBtnImage:(NSString*)leftImg clickBlock:(void(^)())leftBarBtnClickBlock;

@end
