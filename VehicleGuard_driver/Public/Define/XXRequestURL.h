//
//  RequestURL.h
//  Xiang_driver
//
//  Created by 小新 on 16/9/21.
//  Copyright © 2016年 小新. All rights reserved.
//

#ifndef XXRequestURL_h
#define XXRequestURL_h

#pragma mark - URL

//#define AppStoreID @"1141756661"
//获取 app 的版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define Is_Release  0  //1正式环境、0测试环境

#if Is_Release//正式环境
//////////------------------------------------------------------------------------------------------------
    ////2019年V3测试版本URL
    #define kURLMain @"http://copyapixbc.xiangbaoche.cn/api.php/main/"
    //#pragma mark - H5测试链接
    #define kH5URL @"https://copyh5.xiangbaoche.cn"
    // 关于我们
    #define kH5URL_about_us @"https://copyh5.xiangbaoche.cn/driver_about_us.html"
    // 超行程费用参考
    #define kH5URL_over_travel_bill @"https://copyh5.xiangbaoche.cn/driver_over_travel_bill.html"
    // 车队等级规定
    #define kH5URL_car_level @"https://copyh5.xiangbaoche.cn/driver_car_level.html"
    // 常见问题
    #define kH5URL_FAQ @"https://copyh5.xiangbaoche.cn/driver_FAQ.html"
    // 用车指南
    #define kH5URL_car_guide @"https://copyh5.xiangbaoche.cn/driver_order_guide.html"
    // 隐私条款
    #define kH5URL_privacy_policy @"https://copyh5.xiangbaoche.cn/driver_privacy_policy.html"
    // 会员协议
    #define kH5URL_membership_agreement @"https://copyh5.xiangbaoche.cn/driver_membership_agreement.html"
    // 订单详情
    #define kH5URL_Order @"http://copyh5.xiangbaoche.cn/new_order_bill_driver.html?"
    // 线下预定订单详情
    #define kH5URL_UnderOrder @"https://h5.xiangbaoche.cn/driver_demand.html?"
    // 线路包车，效果预览
    #define kH5URL_Order_XianLu @"http://m.xiangbaoche.cn/index/line"
    //任性包车，效果预览
    #define kH5URL_Order_RenXing @"http://m.xiangbaoche.cn/index/freedom"
    //分享订单行程
    #define kH5URL_Order_RoutShare @"http://m.xiangbaoche.cn/customerorder/sendDriver/demand_gid/"
////////------------------------------------------------------------------------------------------------



#else//测试环境
//////------------------------------------------------------------------------------------------------
////2018年v3内部测试版本URL
#define kURLMain @"http://demonewapi.xiangbaoche.cn/api.php/main/"
//#pragma mark® - H5测试链接®
#define kH5URL @"https://demoh5.xiangbaoche.cn"
// 关于我们
#define kH5URL_about_us @"https://demoh5.xiangbaoche.cn/driver_about_us.html"
// 超行程费用参考
#define kH5URL_over_travel_bill @"https://demoh5.xiangbaoche.cn/driver_over_travel_bill.html"
// 车队等级规定
#define kH5URL_car_level @"https://demoh5.xiangbaoche.cn/driver_car_level.html"
// 常见问题
#define kH5URL_FAQ @"https://demoh5.xiangbaoche.cn/driver_FAQ.html"
// 用车指南
#define kH5URL_car_guide @"https://demoh5.xiangbaoche.cn/driver_order_guide.html"
// 隐私条款
#define kH5URL_privacy_policy @"https://demoh5.xiangbaoche.cn/driver_privacy_policy.html"
// 会员协议
#define kH5URL_membership_agreement @"https://demoh5.xiangbaoche.cn/driver_membership_agreement.html"
// 订单详情
#define kH5URL_Order @"http://demoh5.xiangbaoche.cn/new_order_bill_driver.html?"
// 线下预定订单详情
#define kH5URL_UnderOrder @"http://demoh5.xiangbaoche.cn/driver_demand.html?"

// 线路包车，效果预览
#define kH5URL_Order_XianLu @"http://demom.xiangbaoche.cn/index/line"
//任性包车，效果预览
#define kH5URL_Order_RenXing @"http://demom.xiangbaoche.cn/index/freedom"
//分享订单行程
#define kH5URL_Order_RoutShare @"http://demom.xiangbaoche.cn/customerorder/sendDriver/demand_gid/"
////------------------------------------------------------------------------------------------------
#endif


#endif

