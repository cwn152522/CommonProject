//
//  DefinesHeader.h
//  Xiang_driver
//
//  Created by mac on 2019/4/18.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#ifndef DefinesHeader_h
#define DefinesHeader_h

#pragma mark - <************************** 颜色类 **************************>
// RGB颜色设置
#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
// RGB 透明度 颜色设置
#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]
// rgb颜色转换（16进制->10进制）
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]
/**
 *  默认页面背景色
 */
#define kColor_BackGround [UIColor groupTableViewBackgroundColor]
/**
 *  主要颜色蓝色
 */
#define kColor_bluce HexColor(0x00a9f1)
/**
 *  主要颜色浅蓝色
 */
#define kColor_bluceother [UIColor colorWithRed:94/255.0 green:205/255.0 blue:252/255.0 alpha:1.0]



#pragma mark - <************************** 图片类 **************************>
#define kGoBackImage @"btn_back_white"




#pragma mark - <************************** 屏幕适配类 **************************>
//适配方法
#define ShiPei(a)  ([UIScreen mainScreen].bounds.size.width/375.0*(a))
// 屏幕宽
#define kScreen_W [UIScreen mainScreen].bounds.size.width
// 屏幕高
#define kScreen_H [UIScreen mainScreen].bounds.size.height
//状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define kNavigationbarHeight (kStatusBarHeight+44.0)




#pragma mark - <************************** 日志类 **************************>
// 自定义输出在调测时
#ifdef DEBUG
#define XXLog(...) NSLog(__VA_ARGS__)
#else
#define XXLog(...)
#endif




#pragma mark - <************************** 其他类 **************************>
// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define WeakObj(o) __weak typeof(o) weak##o = o

#endif /* DefinesHeader_h */
