//
//  UIScrollView+ExtensionView.h
//  Xiang_driver
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ExtensionView)

/**
 显示空视图1（纯文本提示）
 */
- (void)showEmptyViewWithImage:(NSString *)imgName tipMsg:(NSString *)msg;

/**
 显示空视图2（富文本提示）
 */
//- (void)showEmptyViewWithImage:(NSString *)imgName tipMsgAttr:(NSAttributedString *)msgAttr;

/**
 隐藏空视图
 */
- (void)hideEmptyView;

@end
