//
//  KONotificationCenter.m
//  Xiang_driver
//
//  Created by mac on 2019/5/6.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "KONotificationCenter.h"
#import "XXTollClass.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
// 个推=======
#import  <GTSDK/GeTuiSdk.h> // GetuiSdk头文件应用
/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#define kGtAppId           @"3KglYQWndU6vMMzgjtlmn8"
#define kGtAppKey          @"KmK6u09OYeAPxTllOaHakA"
#define kGtAppSecret       @"44Y9xTf9yt8wbCbDF22U68"
#define kGcAppId @"NYVgQh4liDAmzUE9buCmj3"

// !!!: 我的订单模块
NSString *kMyOrder_ReloadShiShiNotification = @"reload_shishi";
NSString *kMyOrder_ReloadXianLuNotification = @"reload_xianglu";
NSString *kMyOrder_ReloadRenXingNotification = @"reload_renxing";
NSString *kMyOrder_ReloadBookedNotification = @"reload_booked";
NSString *kMyOrder_ReloadRuningNotification = @"reload_runing";
NSString *kMyOrder_ReloadFinishedNotification = @"reload_finished";
NSString *kMyOrder_getOrderNumNotification = @"getOrderNum";
// !!!: 我的账单模块
NSString *kMyBill_WeChatPayResultNotification = @"wei_payState";//我的账单 - 微信支付结果通知
NSString *kMyBill_AliPayResultNotification = @"ali_payState";//我的账单 - 阿里支付结果通知

static KONotificationCenter *instance;


@interface KONotificationCenter ()<UNUserNotificationCenterDelegate, GeTuiSdkDelegate>

@end

@implementation KONotificationCenter

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [KONotificationCenter new];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)hanldeMassage:(NSDictionary *)dic {
//    if(kIsEmptyString([XXUser shareUser].gid)){
//        return;
//    }
//        //解析msgtype
//        NSString *msgtype = [NSString stringWithFormat:@"%@",dic[@"type"]];
//        #pragma mark <************************** 订单通知 **************************>
//        if ([msgtype intValue]==1)
//        {
//            //订单控制器
//            UIViewController *vc_order;
//
//            //推送提示消息
//            NSString *message = [NSString stringWithFormat:@"%@",dic[@"message"]];
//
//            //订单状态 （1-未报价 2-未预定 3-未触发 4-行驶中 5-已完成）
//            NSString *order_type = [NSString stringWithFormat:@"%@",dic[@"order_type"]];
//            //订单模式：1-实时订单 2-线路包车 3-任性包车 0-全部
//            NSString *chartered_type = [NSString stringWithFormat:@"%@",dic[@"chartered_type"]];
//            NSString *title = @"您有新订单通知 ";
//
//
//            if( [order_type integerValue] == 1 || [order_type integerValue] == 2) {
//              // !!!:未报价、未预定推送消息处理
//                if ([chartered_type integerValue] == 1) {//实时报价
//                    KOShiShiBaoJiaIndexCtl *ctl = [KOShiShiBaoJiaIndexCtl new];
//                    ctl.homeData = self.homeData;
//                    ctl.index = [order_type integerValue] == 1 ? 0 : 1;
//                    vc_order = ctl;
//                    [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadShiShiNotification object:nil userInfo:@{@"order_type":[NSString stringWithFormat:@"%ld", order_type.integerValue],@"chartered_type":[NSString stringWithFormat:@"%ld", chartered_type.integerValue]}];//发送通知
//                } else if ([chartered_type integerValue] == 2) {//线路包车
//                    KOXianLuBaoCheIndexCtl *ctl = [KOXianLuBaoCheIndexCtl new];
//                    ctl.homeData = self.homeData;
//                    ctl.index = [order_type integerValue] == 1 ? 0 : 1;
//                    vc_order = ctl;
//                     [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadXianLuNotification object:nil userInfo:@{@"order_type":[NSString stringWithFormat:@"%ld", order_type.integerValue],@"chartered_type":[NSString stringWithFormat:@"%ld", chartered_type.integerValue]}];//发送通知
//                } else if ([chartered_type integerValue] == 3) {//任性包车
//                    KORenXingBaoCheIndexCtl *ctl = [KORenXingBaoCheIndexCtl new];
//                    ctl.homeData = self.homeData;
//                    ctl.index = [order_type integerValue] == 1 ? 0 : 1;
//                    vc_order = ctl;
//                    [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadRenXingNotification object:nil userInfo:@{@"order_type":[NSString stringWithFormat:@"%ld", order_type.integerValue],@"chartered_type":[NSString stringWithFormat:@"%ld", chartered_type.integerValue]}];//发送通知
//                }
//            } else if ([order_type integerValue] == 3) {
//                // !!!:已预定(未出发)推送消息处理
//                KOBookedCtl *ctl = [KOBookedCtl new];
//                ctl.homeData = self.homeData;
//                vc_order = ctl;
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadBookedNotification object:nil userInfo:nil];//发送通知，刷新已预定列表
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadShiShiNotification object:nil userInfo:@{@"order_type":@"2",@"chartered_type":@"1"}];//同时需发送通知，刷新未预定列表
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadShiShiNotification object:nil userInfo:@{@"order_type":@"2",@"chartered_type":@"2"}];//同时需发送通知，刷新未预定列表
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadShiShiNotification object:nil userInfo:@{@"order_type":@"2",@"chartered_type":@"3"}];//同时需发送通知，刷新未预定列表
//            } else if ([order_type integerValue] == 4) {
//                // !!!:行驶中推送消息处理
//                KORuningCtl *ctl = [KORuningCtl new];
//                ctl.homeData = self.homeData;
//                vc_order = ctl;
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadRuningNotification object:nil userInfo:nil];//发送通知，刷新行驶中列表
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadBookedNotification object:nil userInfo:nil];//同时需发送通知，刷新已预定列表
//            } else if ([order_type integerValue] == 5) {
//                // !!!:已完成推送消息处理
//                KOFinishedCtl *ctl = [KOFinishedCtl new];
//                ctl.homeData = self.homeData;
//                vc_order = ctl;
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadFinishedNotification object:nil userInfo:@{@"order_type":[NSString stringWithFormat:@"%ld", order_type.integerValue],@"chartered_type":[NSString stringWithFormat:@"%ld", chartered_type.integerValue]}];//发送通知，刷新已完成列表
//                [[NSNotificationCenter defaultCenter]postNotificationName:kMyOrder_ReloadRuningNotification object:nil userInfo:nil];//同时需发送通知，刷新行驶中列表
//            }
//
//            [JXTAlertTools showTipTwoBtnAlertViewWith:[XXTollClass currentViewController].navigationController title:title message:[NSString stringWithFormat:@"\n%@",message] callbackBlock:^(NSInteger btnIndex) {
//                if (btnIndex==1)
//                {
//                    if (![[XXTollClass currentViewController] isKindOfClass:[vc_order class]])
//                    {
//                        [[XXTollClass currentViewController].navigationController pushViewController:vc_order animated:YES];
//                    }
//                }
//            } OKbuttonTitle:@"取消" CanclebuttonTitle:@"确定"];
//        }
//        else{
//            #pragma mark <************************** 其他通知 **************************>
//        }
}






#pragma mark - 推送
/** 注册APNS */
- (void)registerRemoteNotification {
    // 个推 ======== 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    //向个推服务器注册deviceToken
    //    [GeTuiSdk registerDeviceToken:token];
    
    // [3]:向个推服务器注册deviceToken 为了方便开发者，建议使用新方法
    [GeTuiSdk registerDeviceTokenData:deviceToken];
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
//    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
//    [XXTollClass saveDataKey:@"clientId" value:@{@"clientId":clientId}];
//    
//    // 绑定用户别名[XXUser shareUser].gid
//    NSString *gid  = [XXUser shareUser].gid ?: @"";
//#if Is_Release == 0
//    if(gid.length)
//        gid =  [@"test" stringByAppendingString:gid];
//#endif
//    [GeTuiSdk bindAlias:gid andSequenceNum:@"seq-1"];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}
/** SDK收到透传消息回调 - app在线*/
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"SDK收到透传消息回调taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @"在线"];
    XXLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    NSDictionary *dic_show = [XXTollClass dictionaryWithJsonString:payloadMsg];
    // !!!: 前台, 推送通知消息接收处理
    [KONotificationCenter.defaultCenter hanldeMassage:dic_show];
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息 - app 后台 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"APP已经接收到“远程”通知(推送)\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    //通知消息
    // !!!: 后台, 推送通知消息接收处理
    [KONotificationCenter.defaultCenter hanldeMassage:[XXTollClass dictionaryWithJsonString:userInfo[@"payload"]]];
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - <************************** 我的订单通知消息 **************************>
- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    if ([kGtResponseBindType isEqualToString:action]) {
        NSLog(@"绑定结果 ：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        if (!isSuccess) {
            NSLog(@"失败原因: %@", aError);
        }
    } else if ([kGtResponseUnBindType isEqualToString:action]) {
        NSLog(@"绑定结果 ：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        if (!isSuccess) {
            NSLog(@"失败原因: %@", aError);
        }
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}
#endif

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark 接收到推送通知之后
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // NSLog(@"Receive remote notification : %@",userInfo[@"aps"][@"alert"]);
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"温馨提示"
                               message:userInfo[@"aps"][@"alert"]
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil];
    [alert show];
}

@end
