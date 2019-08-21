//
//  KONotificationCenter.h
//  Xiang_driver
//
//  Created by mac on 2019/5/6.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "KOHomeData.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark - <************************** 通知名 **************************>
// !!!: 我的订单模块
extern NSString *kMyOrder_ReloadShiShiNotification;//我的订单 - 刷新实时报价列表
extern NSString *kMyOrder_ReloadXianLuNotification;//我的订单 - 刷新线路报价列表
extern NSString *kMyOrder_ReloadRenXingNotification;//我的订单 - 刷新任性报价列表
extern NSString *kMyOrder_ReloadBookedNotification;//我的订单 - 刷新已预定列表
extern NSString *kMyOrder_ReloadRuningNotification;//我的订单 - 刷新行驶中列表
extern NSString *kMyOrder_ReloadFinishedNotification;//我的订单 - 刷新已结束列表
extern NSString *kMyOrder_getOrderNumNotification;//我的订单 - 刷新待处理订单数
// !!!: 我的账单模块
extern NSString *kMyBill_WeChatPayResultNotification;//我的账单 - 微信支付结果通知
extern NSString *kMyBill_AliPayResultNotification;//我的账单 - 阿里支付结果通知

@interface KONotificationCenter : NSObject
//@property (strong, nonatomic) KOHomeData *homeData;//首页整合数据

+ (instancetype)defaultCenter;
- (void)hanldeMassage:(NSDictionary *)dic;//处理推送消息

- (void)registerRemoteNotification;//注册推送
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
