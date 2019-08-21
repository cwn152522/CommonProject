//
//  KOCenterTitleAlertView.h
//  Xiang_driver
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 chuanghu. All rights reserved.
// 居中的标题弹窗选择视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KOCenterTitleAlertView : UIView
@property (copy, nonatomic) void(^onSelectItemDown)(NSString *item);
- (void)showWithTitle:(NSString *)title items:(NSArray *)items selectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
