//
//  UIView+CWNView.h
//  NSLayout封装
//
//  Created by 陈伟南 on 15/12/29.
//  Copyright © 2015年 陈伟南. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface UIView (CWNView)

@property (nonatomic, assign) IBInspectable BOOL cornerCircle;//正方形内切圆角
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;//不适配的圆角
@property (nonatomic, assign) IBInspectable CGFloat cornerRadiusAdapter;//有适配的圆角

//xib字体大小适配
@property(assign, nonatomic) IBInspectable BOOL adapterFont;//字体大小适配
@property (nonatomic, strong) IBInspectable UIColor *borderColor;//设置0.5的边框

@end

#pragma mark - <************************** xib中进行单个约束适配 **************************>
@interface NSLayoutConstraint (IBDesignable)
//单个约束适配
@property(assign, nonatomic) IBInspectable BOOL adapterScreen;//单个约束的适配
@end
