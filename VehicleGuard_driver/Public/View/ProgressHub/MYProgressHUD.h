//
//  MYProgressHub.h
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/5/2.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYProgressHUD : UIView//黑底白字，，显示提示语

+ (BOOL)isVisible;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status font:(CGFloat)font duration:(CGFloat)duration delay:(CGFloat)delay centerYOffset:(CGFloat)centerYOffset;//centerYOffset 0默认为屏幕中间

@end
