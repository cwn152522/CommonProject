//
//  UINavigationController+Based.h
//  Xiang_driver
//
//  Created by mac on 2019/4/24.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 此分类为了:
 1.统一导航返回按钮
 2.拦截系统返回按钮点击事件，来决定要不要触发返回(系统默认返回事件无法拦截)
 */

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Based)
@end

NS_ASSUME_NONNULL_END
