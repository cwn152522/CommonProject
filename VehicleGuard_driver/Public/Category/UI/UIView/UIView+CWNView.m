//
//  UIView+CWNView.m
//  NSLayout封装
//
//  Created by 陈伟南 on 15/12/29.
//  Copyright © 2015年 陈伟南. All rights reserved.
//

#import "UIView+CWNView.h"
#import <objc/runtime.h>
#define SHIPEI(a)  [UIScreen mainScreen].bounds.size.width/375.0*a

@implementation UIView (CWNView)

- (void)setCornerRadius:(CGFloat)cornerRadius{//设置圆角
    objc_setAssociatedObject(self, @selector(cornerRadius), @(cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}
- (CGFloat)cornerRadius{
    return  [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBorderColor:(UIColor *)borderColor{//设置边框颜色
    objc_setAssociatedObject(self, @selector(borderColor), borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 0.5;
}
- (UIColor *)borderColor{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCornerRadiusAdapter:(CGFloat)cornerRadiusAdapter{//设置圆角
    objc_setAssociatedObject(self, @selector(cornerRadiusAdapter), @(cornerRadiusAdapter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadiusAdapter;
}
- (CGFloat)cornerRadiusAdapter{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCornerCircle:(BOOL)cornerCircle{
    objc_setAssociatedObject(self, @selector(cornerCircle), @(cornerCircle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)cornerCircle{
    return [objc_getAssociatedObject(self, _cmd)  boolValue];
}

- (void)layoutSubviews{
    if(self.cornerCircle){
        self.layer.cornerRadius = self.frame.size.height / 2.0;
        self.layer.masksToBounds = YES;
    }
}


#pragma mark - <************************** xib中进行字体大小适配 **************************>
#pragma mark - 全部适配
- (void)setAdapterFont:(BOOL)adapterFont{
    objc_setAssociatedObject(self, @selector(adapterFont), [NSNumber numberWithBool:adapterFont], OBJC_ASSOCIATION_RETAIN);
    if(adapterFont){
        if ([self isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)self;
            CGFloat fontSize = label.font.pointSize;
            //创建一个新的字体相同当前字体除了指定的大小
            label.font = [label.font fontWithSize:SHIPEI(fontSize)];
        }
        if ([self isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)self;
            CGFloat fontSize = button.titleLabel.font.pointSize;
            //创建一个新的字体相同当前字体除了指定的大小
            button.titleLabel.font = [button.titleLabel.font fontWithSize:SHIPEI(fontSize)];
        }
        if ([self isKindOfClass:[UITextField class]]) {
            UITextField * button = (UITextField *)self;
            CGFloat fontSize = button.font.pointSize;
            //创建一个新的字体相同当前字体除了指定的大小
            button.font = [button.font fontWithSize:SHIPEI(fontSize)];
        }
        if ([self isKindOfClass:[UITextView class]]) {
            UITextView * button = (UITextView *)self;
            CGFloat fontSize = button.font.pointSize;
            //创建一个新的字体相同当前字体除了指定的大小
            button.font = [button.font fontWithSize:SHIPEI(fontSize)];
        }
    }
}
- (BOOL)adapterFont{
    BOOL adapterFont = [objc_getAssociatedObject(self, _cmd) boolValue];
    return adapterFont;
}
@end


#pragma mark - <************************** xib中进行单个约束适配 **************************>
@implementation NSLayoutConstraint (IBDesignable)
-  (void)setAdapterScreen:(BOOL)adapterScreen{
    objc_setAssociatedObject(self, @selector(adapterScreen), [NSNumber numberWithBool:adapterScreen], OBJC_ASSOCIATION_RETAIN);
    if(adapterScreen){
        self.constant =  SHIPEI(self.constant);
    }
}
-  (BOOL)adapterScreen{
    BOOL adapterScreen = [objc_getAssociatedObject(self, _cmd) boolValue];
    return adapterScreen;
}

@end




#pragma mark - <************************** xib中image改颜色 **************************>
@implementation UIImageView (Coloraful)
- (void)setImageColor:(UIColor *)imageColor {
    objc_setAssociatedObject(self, @selector(imageColor), imageColor , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
-  (UIColor *)imageColor{
    UIColor *imageColor = objc_getAssociatedObject(self, _cmd);
    return imageColor;
}

@end
