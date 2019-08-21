//
//  XXTollClass.h
//  Xiang_user
//
//  Created by 小新 on 16/7/30.
//  Copyright © 2016年 小新. All rights reserved.
//
// 必备框架============================================
// #import <AFNetworking.h>    #import <SDImageCache.h>


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "XXRequestURL.h"
//#import <MBProgressHUD.h>
//#import "IdiotSentinelProgressHUD.h"

typedef void(^MyQueue)();

typedef void(^ProgressBlock)(id progress);
typedef void(^SuccessBlock)(id success);
typedef void(^FailureBlock)(id failure);

typedef void(^resDataBlock)(id errCode,id resData, NSString* resMsg);

@interface XXTollClass : NSObject
+(instancetype)Shared;

#pragma mark - 基础控件
+ (UIButton *)getButtonInitWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius imageName:(NSString *)imageName andTitle:(NSString *)title target:(id)target action:(SEL)action;
/**
 *  创建Label
 *
 *  @param frame frame
 *  @param title 标题
 *  @param font  字体大小
 *
 *  @return Label
 */
+ (UILabel*)getLabel:(CGRect)frame title:(NSString *)title font:(CGFloat )font;
/**
 *  创建textField
 *
 *  @param fram        frame
 *  @param placeholder 默认文字
 *  @param num         对齐方式  1左 2中  3右
 *
 *  @return textField
 */
+ (UITextField *)getTextFiledFrame:(CGRect)fram placeholder:(NSString *)placeholder textAlignment:(NSInteger)num;

/**
 *  添加圆角边框
 */
+(void)addBorderOnView:(UIView *)view cornerRad:(CGFloat)cornerRad lineCollor:(UIColor *)collor lineWidth:(CGFloat)lineWidth;
/**
 *  不同颜色不同字体大小字符串
 */
+(NSMutableAttributedString *)getOtherColorString:(NSString *)string Color:(UIColor *)Color font:(CGFloat)font inStr:(NSString *)instr;

#pragma mark - 多线程

/**
 *  异步  并行通信
 *
 *  @param progress 任务
 */
+ (void)GCDMoreQueueParallelProgressBlock:(MyQueue)myQueue;
/**
 *  异步 串行通信
 *
 *  @param myQueue 任务
 */
+ (void)GCDMoreQueueSeriesProgressBlock:(MyQueue)myQueue;

#pragma mark - 字符串处理
// 计算高度
+ (CGSize)calStrSize:(NSString *)text andWidth:(CGFloat)w  andHeight:(CGFloat)h andFontSize:(CGFloat)fontsize;
// 判断是不是空
+ (BOOL)isBlankString:(NSString *)string;
#pragma mark -

#pragma mark - 时间转换
/**
 *  时间转换成时间戳
 *
 *  @param date 时间
 *
 *  @return 时间戳
 */
+ (NSString *)DateConvertTimeInterval:(NSDate *)date;

/**
 *  时间戳转换成时间
 *
 *  @param TimeInterval 时间戳
 *  
 *  @type 1 日期 2  时间 3 时间加日期
 *  @return 时间
 */
+ (NSString *)TimeIntervalConvertDate:(NSInteger)TimeInterval andType:(NSInteger)type;

#pragma mark -

#pragma mark - 清理缓存
/**
 *  计算缓存值
 *
 *  @param path 路径
 *
 *  @return 计算结果
 */
+(NSString*)folderSizeAtPath:(NSString *)path;
/**
 *  清理缓存
 *
 *  @param path 路径
 */
+(void)clearCache:(NSString *)path;
#pragma mark -

#pragma mark - MD5加密
//把字符串加密成32位小写md5字符串
+ (NSString*)md532BitLower:(NSString *)inPutText;

//把字符串加密成32位大写md5字符串
+ (NSString*)md532BitUpper:(NSString*)inPutText;

#pragma mark -
#pragma mark - 转码
+ (NSString *)stringByReplacingPercentEscapesUsingEncoding:(NSString *)str;
#pragma mark -

#pragma mark - 网络请求
/**
 *  获取当前网络类型
 *
 *  @return 网络类型
 */
+ (NSString *)getNetType;
/**
 *  post请求
 *
 *  @param url      除去固定部分 拼接的URL
 *  @param params   请求参数字典
 *  @param progress 请求进度回调代码块
 *  @param succress 请求成功回调代码块
 *  @param failure  请求失败回调代码块
 */
+(void)PostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 线下预定模块测试环境是demoapi而不是demonewapi，因此单独写一个线下预定的请求方法
 */
+(void)UnderlinePostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  请求数据处理
 *
 *  @param success  请求成功的回调
 *  @param errCode  网络请求返回码
 *  @param resData  网络请求回调数据
 *  @param resMsg   网络请求提示文字
 */
+(void)SuccessData:(NSDictionary *)success resData:(resDataBlock)resData;

/**
 *  图片上传
 *
 *  @param imgData  图片数据  Data
 *  @param fileName 服务器文件路径
 *  @param url      除去固定部分 拼接的URL
 *  @param params   请求参数字典
 *  @param progress 请求进度回调代码块
 *  @param succress 请求成功回调代码块
 *  @param failure  请求失败回调代码块
 */
+(void)UpLoadImage:(NSData *)imgData fileName:(NSString *)fileName PostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 *  上传文件
 *
 *  @param fileData 图片组
 *  @param params   其他参数
 *  @param result   成功回调
 *  @param failure  失败回调
 */
+ (void)updateFile:(NSArray*)fileData url:(NSString*)url parameters:(NSMutableDictionary*)params fileName:(NSString*)fileName viewControler:(UIViewController*)vc success:(void(^)(id result))result failure:(FailureBlock)failure;
/**
 *  云  创建一条用户位置信息
 *
 *  @param data 位置数据
 *  @param type 表标记  1 用户表  2 司机表
 */
+(void)creacteLoaction:(NSString *)data andTable:(NSInteger)type;
/**
 *  更新位置
 *
 *  @param data 位置数据
 *  @param type 表标记  1 用户表  2 司机表
 */
+(void)updataLoaction:(NSString *)data andTable:(NSInteger)type;
/**
 *  位置检索乘客
 *
 *  @param filter  筛选条件 ordergid
 *  @param type    表标记  1 用户表  2 司机表 (现在已分开请求不需要用到)
 *  @param success 成功数据
 *  @param failure 失败数据
 */
+(void)loadLoaction:(NSString *)filter andTable:(NSInteger)type success:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 *  位置检索司机
 *
 *  @param filter  筛选条件 ordergid
 *  @param type    表标记  1 用户表  2 司机表 (现在已分开请求不需要用到)
 *  @param success 成功数据
 *  @param failure 失败数据
 */
+ (void)loadLoactionDriver:(NSString *)filter andDrivergid:(NSString *)drivergid success:(SuccessBlock)success failure:(FailureBlock)failure;
#pragma mark -

#pragma mark - 数据存储

/**
 *  存储value
 */
+(void)saveInMyLocalStoreForValue:(id)value atKey:(NSString *)key;
/**
 *  获取value
 */
+(id)getValueInMyLocalStoreForKey:(NSString *)key;
/**
 *  删除value
 */
+(void)DeleteValueInMyLocalStoreForKey:(NSString *)key;

#pragma mark -

#pragma mark - 数据类型转换
/**
 *  字典转JSON
 *
 *  @param dic 字典
 *
 *  @return JOSN数据串
 */
+(NSString *)getJsonDictionary:(NSDictionary *)dic;

/**
 *  JSON转字典
 *
 *  @param dic 字典
 *
 *  @return jsonString数据串
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  数组转JSON
 *
 *  @param arr 数组
 *
 *  @return JOSN数据串
 */
+(NSString *)getJsonArray:(NSArray *)arr;

#pragma mark -

#pragma mark - 判断数据类型

/**
 *  判断车牌号是否正确
 *
 *  @param NumText 车牌号
 *
 *  @return 判读结果
 */
+ (BOOL)isCarNum:(NSString *)NumText;

/**
 *  判断手机号码是否正确
 *
 *  @param phoneText 手机号
 *
 *  @return 判读结果
 */
+ (BOOL)isTelphoneNum:(NSString *)phoneText;
/**
 *  判断是否是整形数据
 *
 *  @param string 数据
 *
 *  @return 结果
 */
+ (BOOL)isPureInt:(NSString*)string;
/**
 *  判断是否包含中文
 *
 *  @param password 字符串
 *
 *  @return 结果
 */
+ (BOOL)isValidatePassword:(NSString *)password;

/**
 *  判断银行卡号是否合法(储蓄卡)
 *  如果是信用卡返回否
 *  @param cardNumber 字符串
 *
 *  @return 结果
 */
+(BOOL)isBankCard:(NSString *)cardNumber;

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

+ (UIImage *)scaleFromImage:(UIImage *)image;

/**
 *  data保存数据到本地
 *  @return 数据
 */
+(void)saveData:(NSString*)key value:(NSData *)data;
+(NSData *)loadData:(NSString *)key;

/**
 *  dic保存数据到本地
 *  @return 数据
 */
+ (void)saveDataKey:(NSString *)key value:(NSDictionary *)value;
+ (NSDictionary*)loadDataKey:(NSString* )key;

/**
 *  arr保存数据到本地
 *  @return 数据
 */
+ (void)saveArrKey:(NSString *)key value:(NSArray *)value;
+ (NSArray *)loadArrKey:(NSString *)key;

/**
  根据宽度求高度
  @param text 计算的内容
  @param width 计算的宽度
  @param font font字体大小
  @return 放回label的高度
 */
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
/**
  根据高度求宽度
  @param text 计算的内容
  @param height 计算的高度
  @param font font字体大小
  @return 返回Label的宽度
 */
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;

/**
  根据高度求宽度
  @375以上屏幕字体适配
 */
+ (UIFont *)fit_configure:(CGFloat)font;

/**
  根据高度求宽度
  UIView (Fit)方法实现,实现fit_configureHeight方法
 */
+ (CGFloat)fit_configureHeight:(CGFloat)height;

/**
  根据高度求宽度
  UIFont(FitFont) 分类方法实现,实现fit_configureWithScreenWidith方法
 */
+ (UIFont *)fit_configureWithScreenWidith:(CGFloat)font;

/**
  根据高度求宽度
  UIFont(FitFont) 分类方法实现,实现fit_configureWithScreenWidith方法
  加粗
 */
+ (UIFont *)fit_configureWithScreenWidithWeight:(CGFloat)font;

/**
  获取手机当前显示的ViewController
 */
+ (UIViewController*)currentViewController;

/**
  文本显示间距调整  lbl:需修改文本 space: 间距
 */
+(UILabel *)setLineSpacing:(UILabel *)lbl setLineSpace:(NSInteger)space;

/**
  比较两个日期大小
 */
+(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate;

/** 判断银行卡号是否只包含中文 */
+ (BOOL) zsStringInputOnlyIsChinese:(NSString*)string;


//获取实际使用的LaunchImage图片
+ (NSString *)getLaunchImageName;

//根据银行名称获取银行图标
+ (NSString *)getImageOfBankName:(NSString *)bankName;

//获取某个链接对应的二维码
+ (UIImage *)getQrImage:(NSString *)url;

#pragma mark - 宏定义
#pragma mark - KEY
#define APIKey_Map @"25d8153a84e07213ab73d85d14f316f2"//高德地图key
#define APITableID_User @"5796bb0e7bbf1978ba69246d"//高德云图用户表
#define APITableID_Driver @"57e615af7bbf19153142e6fc"//高德云图司机表

#pragma mark - 判断数据是否为空
//字符串是否为空
#define kIsEmptyString(str) ([str isKindOfClass:[NSNull class]] || str == nil || ( [str isKindOfClass:[NSString class]] &&( [str length] < 1 ? YES : NO ||[str isEqualToString:@"<null>"]||[str isEqualToString:@""]||[str isEqualToString:@"(null)"])))
//数组是否为空
#define kIsEmptyArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kIsEmptyDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)
//是否是空对象
#define kIsEmptyObject(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
#pragma mark -

#pragma mark - 限制文本输入类型
#define TEXTNUM @"0123456789"
#define TEXTLETTER @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM_LETTER @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#pragma mark - 常用
/**
 *  持久化 KEY 值
 */
#define kReachability @"myReachability"

/**
 *  当前网络状态
 */
#define kNetworkType [XXTollClass getValueInMyLocalStoreForKey:kReachability]
/**
 *  懒人简化书写宏
 */
#define kXXTollClass [XXTollClass Shared]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kNetWorkManager [NetWorkManager sharedInstance]
#define kWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/**
 *  请求提示文字
 */
#define kText_Loading @"请稍后..."
#define kText_Failure @"失败"
#define kText_Success @"成功"
#define kText_NetworkPoor @"网络不给力啊"
/**
 *  iPhone or iPad
 */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//// 自定义输出在调测时
//#ifdef DEBUG
//#define XXLog(...) NSLog(__VA_ARGS__)
//#else
//#define XXLog(...)
//#endif

#define filePath3 [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

// 系统版本
#define kSystem_version [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark - 颜色
//// RGB颜色设置
//#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//// RGB 透明度 颜色设置
//#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]
///**
// *  默认页面背景色
// */
//#define kColor_BackGround [UIColor groupTableViewBackgroundColor]
/**
 *  默认白色
 */
#define kColor_White [UIColor whiteColor]
/**
 *  分割线灰色等...
 */
#define kSeperateLineGrayColor HexColor(0xe6e6e6)
/**
 *  主题颜色
 */
#define kColor_Main [UIColor colorWithRed:0.0 green:0.6667 blue:0.949 alpha:1.0]
/**
 *  主题辅助颜色（状态，提示等...） 黄色
 */
#define kColor_Yellow [UIColor colorWithRed:0.9412 green:0.7608 blue:0.1216 alpha:1.0]
/**
 *  主要字体颜色
 */
#define kColor_Font [UIColor colorWithRed:0.2941 green:0.2941 blue:0.2941 alpha:1.0]

///**
// *  主要颜色蓝色
// */
//#define kColor_bluce [UIColor colorWithRed:0/255.0 green:170/255.0 blue:242/255.0 alpha:1.0]
//
///**
// *  主要颜色浅蓝色
// */
//#define kColor_bluceother [UIColor colorWithRed:94/255.0 green:205/255.0 blue:252/255.0 alpha:1.0]

/**
 *  红色字体
 */
#define kredColor_Font [UIColor colorWithRed:209/255.0 green:73/255.0 blue:78/255.0 alpha:1.0]
#define kredColor_102 [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define kRedColor HexColor(0xff4c4c)

/**
 *  灰色字体
 */
#define kgrayColor51 HexColor(0x666666)
#define kgrayColor102 [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define kgrayColor150 [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]
#define kgrayColor214 [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0]
#define kgrayColor230 [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define kgrayColor247 [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]
#define kgrayColor200 [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

/**
 *  主题辅助颜色（状态，提示等...） 黄色
 */
#define kyellow_font [UIColor colorWithRed:242/255.0 green:201/255.0 blue:31/255.0 alpha:1.0]

/**
 *  黑色字体
 */
#define kblackColor_Font HexColor(0x333333)

/**
 *  默认图地址 空图片地址
 */
#define kdefaultImage @"http://managerimage.xiangbaoche.cn/50edabd1ba38237b3a59498d3793c47f.png?v=54966"

#pragma mark - 对象 属性 控件
// Image宏
#define kImage(imgName) [UIImage imageNamed:(imgName)]
// 字体大小
#define kFont(x) [UIFont systemFontOfSize:x]

//iPhoneX / iPhoneXS
#define  isIphoneX_XS     (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
//iPhoneXR / iPhoneXSMax
#define  isIphoneXR_XSMax    (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)
//异性全面屏
#define   isFullScreen    (isIphoneX_XS || isIphoneXR_XSMax)

// frame
#define kFrame(x,y,w,h)         CGRectMake((x), (y), (w), (h))
// 创建点Point
#define  kPoint(x,y)             CGPointMake((x), (y))
// 创建尺寸size
#define  kSize(w,h)              CGSizeMake((w), (h))

#pragma mark - 尺寸
//// 屏幕宽
//#define kScreen_W [UIScreen mainScreen].bounds.size.width
//// 屏幕高
//#define kScreen_H [UIScreen mainScreen].bounds.size.height
/**
 *  获取Window
 */
#define kWindow [UIApplication sharedApplication].keyWindow
/**
 *  获取mainScreen的bounds
 */
#define kScreenBounds [[UIScreen mainScreen] bounds]

// 适配比例 iPhone6 为标准  等比例缩放宽高位置 4（320*480） 5（320*568）6（375*667）6+（414*736）
#define kScale_W(w) (w*kScreen_W/375.0)
#define kScale_H(h) kScale_W(h)
#define kScale_Frame(x,y,w,h)  CGRectMake((x*kScreen_W/375.0), (y*(kScreen_H == 480 ? 568:kScreen_H)/667.0), (w*kScreen_W/375.0), (h*(kScreen_H == 480 ? 568:kScreen_H)/667.0))

// 只有6P 变大  其他  不变
#define kScale6p_W(w) ShiPei(w)
#define kScale6p_H(h)  kScale6p_W(h)
#define kScale6p_Frame(x,y,w,h)  CGRectMake((x*kScreen_W/375.0), (y*(kScreen_H == 736 ? 736:667.0)/667.0), (w*(kScreen_W == 414 ? 414:375)/375.0), (h*(kScreen_H == 736 ? 736:667)/667.0))

// 适配字体大小
#define kScale_Font(x) [UIFont systemFontOfSize:ShiPei(x)]
// 适配6P字体大小
#define kScale6p_Font(x) [UIFont systemFontOfSize:kScale6p_W(x)]

//UIFont(FitFont) 分类方法实现,此处采用的方案是375屏宽以上字体＋1,375屏宽以下字体-1
//#define FontCaseOne(F) [XXTollClass fit_configure:(F)]
//
//#define FontCaseTwo(F) [XXTollClass fit_configureWithScreenWidith:(F)]
//#define FitHeight(H) [UIView fit_configureHeight:(H)]

//是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//导航栏高度 是否iphoneX
//#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)

/**
 * MARK:-屏幕尺寸宏定义
 * 导航栏高度 状态栏高度 底部tabbar高度 苹果X底部安全区高度
 */
//屏幕rect
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))
//iPhone X系列判断
#define  IS_iPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))
//状态栏高度
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define NavBarHeight (44.f+StatusBarHeight)
//底部标签栏高度
#define TabBarHeight (IS_iPhoneX ? (49.f+34.f) : 49.f)
//安全区域高度
#define TabbarSafeBottomMargin     (IS_iPhoneX ? 34.f : 0.f)


#pragma mark -

@end
