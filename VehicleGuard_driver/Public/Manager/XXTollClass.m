//
//  XXTollClass.m
//  Xiang_user
//
//  Created by 小新 on 16/7/30.
//  Copyright © 2016年 小新. All rights reserved.
//

#import "XXTollClass.h"
#import <CommonCrypto/CommonDigest.h>
//#import <AFNetworking.h>
//#import <SDImageCache.h>


#define kSaveStatic [NSUserDefaults standardUserDefaults]



@interface XXTollClass()

@property (copy, nonatomic) MyQueue btnAction;

@end
@implementation XXTollClass

+(instancetype)Shared
{
    static XXTollClass *_tool = nil;
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke, ^{
        _tool = [[self alloc]init];
    });
    return _tool;
}
- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
#pragma mark - 本地数据存储
+(void)saveInMyLocalStoreForValue:(id)value atKey:(NSString *)key
{
    [kSaveStatic setValue:value forKey:key];
    [kSaveStatic synchronize];
}
+(id)getValueInMyLocalStoreForKey:(NSString *)key
{
    return [kSaveStatic objectForKey:key];
}
+(void)DeleteValueInMyLocalStoreForKey:(NSString *)key
{
    [kSaveStatic removeObjectForKey:key];
    [kSaveStatic synchronize];
}
#pragma mark -
#pragma mark - 基础控件
// 创建按钮
+ (UIButton *)getButtonInitWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius imageName:(NSString *)imageName andTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    
    if (cornerRadius > 0)
    {
      button.layer.cornerRadius = cornerRadius;
    }
    if (imageName)
    {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (title)
    {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.font =kFont(16);
    [button setTitleColor:kColor_Font forState:0];
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/** 创建标签 */
+ (UILabel*)getLabel:(CGRect)frame title:(NSString *)title font:(CGFloat )font
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.text = title;
    lbl.font = [UIFont systemFontOfSize:font] ;
    lbl.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    
    return lbl;
}
/** 创建textFiled */
+ (UITextField *)getTextFiledFrame:(CGRect)fram placeholder:(NSString *)placeholder textAlignment:(NSInteger)num
{
    UITextField *txt = [[UITextField alloc] initWithFrame:fram];
    txt.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    txt.placeholder = placeholder;
    txt.font = [UIFont systemFontOfSize:16];
    
    if(num == 2)
    {
      txt.textAlignment = NSTextAlignmentCenter;
    }
    else if (num == 3)
    {
        txt.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        txt.textAlignment = NSTextAlignmentLeft;
    }
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    txt.rightView = leftView;
    txt.rightView.contentMode = UITextFieldViewModeAlways;
    
    return txt;
}
+(void)addBorderOnView:(UIView *)view cornerRad:(CGFloat)cornerRad lineCollor:(UIColor *)collor lineWidth:(CGFloat)lineWidth
{
    if (lineWidth)
    {
        view.layer.borderWidth = lineWidth;
    }
    if (collor)
    {
        view.layer.borderColor = collor.CGColor;
    }
    if (cornerRad)
    {
        view.layer.cornerRadius = cornerRad;
    }
    view.layer.masksToBounds = YES;
}
+(NSMutableAttributedString *)getOtherColorString:(NSString *)string Color:(UIColor *)Color font:(CGFloat)font inStr:(NSString *)instr
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    if (![XXTollClass isBlankString:instr]) {
        
        NSMutableString *temp = [NSMutableString stringWithString:instr];
        
        NSRange range = [temp rangeOfString:string];
        
        str = [[NSMutableAttributedString alloc] initWithString:temp];
        [str addAttribute:NSForegroundColorAttributeName value:Color range:range];
        if (font) {
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        }
    }
    return str;
}
/**
 *  自动设置文本  宽 高
 *
 *  @param text     文本内容
 *  @param w        最大宽度
 *  @param h        最大高度
 *  @param fontsize 字体大小
 *
 *  @return 返回一个size
 */
+ (CGSize)calStrSize:(NSString *)text andWidth:(CGFloat)w  andHeight:(CGFloat)h andFontSize:(CGFloat)fontsize
{
    CGRect rect=[text boundingRectWithSize:CGSizeMake(w, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil];
    CGSize size = rect.size;
    
    return size;
}
+(BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - 多线程
+(void)GCDMoreQueueParallelProgressBlock:(MyQueue)myQueue
{
    //1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        
        myQueue();
        
    });
}
+ (void)GCDMoreQueueSeriesProgressBlock:(MyQueue)myQueue
{
    //创建串行队列
    dispatch_queue_t  queue= dispatch_queue_create("wendingding", NULL);
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    dispatch_async(queue, ^{
        myQueue();
    });
}
#pragma mark -
#pragma mark - 时间转换
+ (NSString *)DateConvertTimeInterval:(NSDate *)date
{
    // 转时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

+ (NSString *)TimeIntervalConvertDate:(NSInteger)TimeInterval andType:(NSInteger)type
{
    //NSString *str= TimeInterval;//时间戳
    NSTimeInterval time = TimeInterval ;//因为时差问题要加8小时 == 28800 sec
//    if (type == 2)
//    {
//        time -= 28800;
//    }
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    if (type == 1)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (type == 2)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else if (type == 3)
    {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    }
    else if (type == 4)
    {
        [dateFormatter setDateFormat:@"MM月dd日"];
    }
    else if (type == 5)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else if(type == 6)
    {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    }
    else if (type == 7)
    {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else if (type == 8)
    {
        [dateFormatter setDateFormat:@"MM月"];
    }
    else if (type == 9)
    {
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}
#pragma mark -
#pragma mark - 缓存相关
+(void)clearCache:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
+(NSString*)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize];
        folderSize = folderSize/1000.f/1000.f;
        
        NSString *strSize = [NSString stringWithFormat:@"%.2fMb",folderSize];
        
        return strSize;
    }
    return @"0";
}
/**
 *  计算单个文件大小
 */
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma mark -
#pragma mark - 检测网络状态
/**
 *  查询网络状态
 */
+ (NSString *)getNetType
{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    NSArray *chlidrenArray = [[[application valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    NSInteger netType =0;
    
    for (id  child in chlidrenArray) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            netType = [[child valueForKeyPath:@"dataNetworkType"] integerValue];
            
        }
    }
    
    NSString *strNetType ;
    
    switch (netType) {
        case 0:
            strNetType = @"0";
            break;
        case 1:
            strNetType = @"2G";
            break;
        case 2:
            strNetType = @"3G";
            break;
        case 3:
            strNetType = @"4G";
            break;
        case 5:
            strNetType = @"WIFE";
            break;
            
        default:
            break;
    }
    
    [XXTollClass saveInMyLocalStoreForValue:strNetType atKey:kReachability];
    
    return strNetType;
}
#pragma mark -

#pragma mark - 查询是否有乘客地址数据
+ (void)loadLoaction:(NSString *)filter andTable:(NSInteger)type success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *tableid ;
    tableid = APITableID_User;
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"key":@"a57d912873a2537d75d609c52c10995e",@"tableid":[NSString stringWithFormat:@"&%@",tableid],@"filter":[NSString stringWithFormat:@"&%@",filter]};
    // 创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 10.0f;
    NSString *str = [NSString stringWithFormat:@"http://yuntuapi.amap.com/datamanage/data/list?key=a57d912873a2537d75d609c52c10995e&tableid=%@&filter=order_gid:%@",tableid,filter];
    [manager GET:[NSString stringWithFormat:@"%@",str] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - 查询是否有司机数据
+ (void)loadLoactionDriver:(NSString *)filter andDrivergid:(NSString *)drivergid success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *tableid ;
    tableid = APITableID_Driver;
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"key":@"a57d912873a2537d75d609c52c10995e",@"tableid":[NSString stringWithFormat:@"&%@",tableid],@"filter":[NSString stringWithFormat:@"&%@",filter]};
    // 创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 10.0f;
    NSString *str = [NSString stringWithFormat:@"http://yuntuapi.amap.com/datamanage/data/list?key=a57d912873a2537d75d609c52c10995e&tableid=%@&filter=order_gid:%@+driver_gid:%@",tableid,filter,drivergid];
    [manager GET:[NSString stringWithFormat:@"%@",str] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)updataLoaction:(NSString *)data andTable:(NSInteger)type
{
    NSString *tableid ;
    if (type == 1)
    {
        tableid = APITableID_User;
    }
    else
    {
        tableid = APITableID_Driver;
    }
    NSDictionary *dic = @{@"key":@"a57d912873a2537d75d609c52c10995e",@"tableid":tableid,@"data":data};
    
    // 创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager POST:@"http://yuntuapi.amap.com/datamanage/data/update" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 回调成功代码块
        NSLog(@"更新成功------%@%@",responseObject,responseObject[@"info"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 回调失败代码块
        
        NSLog(@"%@",error);
        
    }];
    
}
+(void)creacteLoaction:(NSString *)data andTable:(NSInteger)type
{
    NSString *tableid ;
    if (type == 1)
    {
        tableid = APITableID_User;
    }
    else
    {
        tableid = APITableID_Driver;
    }
    
    NSDictionary *dic = @{@"key":@"a57d912873a2537d75d609c52c10995e",@"tableid":tableid,@"data":data};
    
    // 创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 10.0f;
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [manager.requestSerializer setV alue:@"application/json"forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"text/html;charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    NSString  *mapurl = @"http://yuntuapi.amap.com/datamanage/data/create";
    [manager POST:mapurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] intValue]==1)
        {
            // 回调成功代码块
            NSLog(@"成功定位------%@",responseObject[@"info"]);
        }
        if ([responseObject[@"status"] intValue]==0)
        {
            NSLog(@"定位失败未知原因");
        }
        if ([responseObject[@"status"] intValue]==-11)
        {
            NSLog(@"失败，已存在相同名称表");
        }
        if ([responseObject[@"status"] intValue]==-21)
        {
            NSLog(@"失败，已创建表达到最大数据");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 回调失败代码块
        NSLog(@"%@",error);
    }];
}

+(void)PostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [KORequestPost PostWithURL:url parameters:params progress:progress success:success failure:failure];
}

+(void)UnderlinePostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure{
    [KORequestPost PostWithURL:Is_Release == 0 ?  [NSString stringWithFormat:@"http://demoapi.xiangbaoche.cn/api.php/main/%@", url] : url parameters:params progress:progress success:success failure:failure];
}

+(void)SuccessData:(NSDictionary *)success resData:(resDataBlock)resData
{
    resData(success[@"errCode"],success[@"resData"],success[@"resMsg"]);
}

+(void)UpLoadImage:(NSData *)imgData fileName:(NSString *)fileName PostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 10.0f;
    NSString *str = [NSString stringWithFormat:@"%@%@",kURLMain,url];
    
    [manager POST:str parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传数据，域名为fileName
        [formData appendPartWithFileData:imgData name:@"file"fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 回调成功代码块
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 回调失败代码块
        failure(error);
    }];
}
+ (void)updateFile:(NSArray*)fileData url:(NSString*)url parameters:(NSMutableDictionary*)params fileName:(NSString*)fileName viewControler:(UIViewController*)vc success:(void(^)(id result))result failure:(FailureBlock)failure;
{
    url = [NSString stringWithFormat:@"%@%@",kURLMain,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int index = 0;
        for(UIImage *image in fileData)
        {
            NSString* tempFileName = [NSString stringWithFormat:@"%@%d.png",fileName,index];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:@"file" fileName:tempFileName mimeType:@"image/png"];
            index ++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(error);
    }];
}

#pragma mark -
#pragma mark - 中文转码
+ (NSString *)stringByReplacingPercentEscapesUsingEncoding:(NSString *)str
{
    NSString *strNew = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    return strNew;
}
#pragma mark -
#pragma mark - MD5加密
/**
 *  把字符串加密成32位小写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位小写md5字符串
 */
+ (NSString*)md532BitLower:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
/**
 *  把字符串加密成32位大写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
+ (NSString*)md532BitUpper:(NSString*)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
#pragma mark -
#pragma mark - JSON转换
+ (NSString *)getJsonArray:(NSArray *)arr
{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        //NSLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON String = %@", jsonString);
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil)
    {
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    return @"111";
    
}
// 字典转JSON
+(NSString *)getJsonDictionary:(NSDictionary *)dic
{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil)
    {
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    return @"111";
}
// JSON转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark -
#pragma mark - 数据类型判断

/** 判断手机号码 */
+ (BOOL)isCarNum:(NSString *)NumText
{
//    NSString *NubRegex = @"([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}(([0-9]{5}[DF])|([DF]([A-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳]{1})";
    NumText = [NumText stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *NubRegex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[A-Za-z]{1}[0-9A-Za-z]{4,7}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NubRegex];
    return [prediate evaluateWithObject:NumText];
//    return [NumText length] >= 7 && [NumText length] <=9;
}

/** 判断手机号码 */
+ (BOOL)isTelphoneNum:(NSString *)phoneText
{
    NSString *telRegex = @"^1[3456789]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:phoneText];
}
/** 判断是否为整形 */
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
/** 判断是否包含中文 */
+ (BOOL)isValidatePassword:(NSString *)password
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:password];
    if (res == TRUE) {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

/** 判断银行卡号是否只包含中文 */
+ (BOOL) zsStringInputOnlyIsChinese:(NSString*)string
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

/** 判断银行卡号是否合法 */
+(BOOL)isBankCard:(NSString *)cardNumber{
    if(cardNumber.length==0){
        return NO;
    }
    if (cardNumber.length==19)//19位银行卡判读
    {
        int oddsum = 0;     //奇数求和
        int evensum = 0;    //偶数求和
        int allsum = 0;
        int cardNoLength = (int)[cardNumber length];
        int lastNum = [[cardNumber substringFromIndex:cardNoLength-1] intValue];
        
        cardNumber = [cardNumber substringToIndex:cardNoLength - 1];
        for (int i = cardNoLength -1 ; i>=1;i--) {
            NSString *tmpString = [cardNumber substringWithRange:NSMakeRange(i-1, 1)];
            int tmpVal = [tmpString intValue];
            if (cardNoLength % 2 ==1 ) {
                if((i % 2) == 0){
                    tmpVal *= 2;
                    if(tmpVal>=10)
                        tmpVal -= 9;
                    evensum += tmpVal;
                }else{
                    oddsum += tmpVal;
                }
            }else{
                if((i % 2) == 1){
                    tmpVal *= 2;
                    if(tmpVal>=10)
                        tmpVal -= 9;
                    evensum += tmpVal;
                }else{
                    oddsum += tmpVal;
                }
            }
        }
        
        allsum = oddsum + evensum;
        allsum += lastNum;
        if((allsum % 10) == 0)
            return YES;
        else
            return NO;
    }
    //16位银行卡判断
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size
{
    NSData* data = UIImageJPEGRepresentation(image, 0.1);
    CGFloat dataKBytes = data.length/1024.0;
    CGFloat maxQuality = 0.5f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f)
    {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        CGFloat dataKBytes = data.length/1024.0;
        if (lastData == dataKBytes)
        {
            break;
        }
        else
        {
            lastData = dataKBytes;
        }
    }
    return data;
}

//==========================
// 图像压缩
//==========================
+ (UIImage *)scaleFromImage:(UIImage *)image
{
    if (!image)
    {
        return nil;
    }
    NSData *data =UIImagePNGRepresentation(image);
    CGFloat dataSize = data.length/1024;
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size;
    
    if (dataSize<=100)//小于50k
    {
        return image;
    }
    else if (dataSize<=100)//小于100k
    {
        size = CGSizeMake(width/1.f, height/1.f);
    }
    else if (dataSize<=200)//小于200k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=500)//小于500k
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=1000)//小于1M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else if (dataSize<=2000)//小于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    else//大于2M
    {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    NSLog(@"%f,%f",size.width,size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return image;
    }
    return newImage;
}

#pragma mark - 本地数据保存
+(void)saveData:(NSString*)key value:(NSData *)data
{
    NSUserDefaults *defaults = [NSUserDefaults new];
    [defaults setObject:data forKey:key];
}
+(NSData *)loadData:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults new];
    NSData *data  = [defaults objectForKey:key];
    return data;
}

+ (NSDictionary *)loadDataKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults new];
    NSDictionary *dic  = [defaults objectForKey:key];
    return dic;
}
+ (void)saveDataKey:(NSString *)key value:(NSDictionary *)value
{
    NSUserDefaults *defaults = [NSUserDefaults new];
    [defaults setObject:value forKey:key];
}

+ (NSArray *)loadArrKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults new];
    NSArray *arr  = [defaults objectForKey:key];
    return arr;
}
+ (void)saveArrKey:(NSString *)key value:(NSArray *)value
{
    NSUserDefaults *defaults = [NSUserDefaults new];
    [defaults setObject:value forKey:key];
}

/**
  根据宽度求高度
  @param text 计算的内容
  @param width 计算的宽度
  @param font font字体大小
  @return 放回label的高度
*/
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

/**
  根据高度求宽度
  @param text 计算的内容
  @param height 计算的高度
  @param font font字体大小
  @return 返回Label的宽度
*/
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}context:nil];
     return rect.size.width;
}
#pragma mark -

//获取手机当前显示的ViewController
+ (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

+(UILabel *)setLineSpacing:(UILabel *)lbl setLineSpace:(NSInteger)space
{
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lbl.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lbl.text length])];
    lbl.text = @"";
    lbl.attributedText = attributedString;
    lbl.lineBreakMode = NSLineBreakByCharWrapping;
    return lbl;
}

/**
  根据高度求宽度
  @UIFont(FitFont) 分类方法实现,此处采用的方案是375屏宽以上字体＋1,375屏宽以下字体-1
 */
+ (UIFont *)fit_configure:(CGFloat)font {
    return [self fit_configureWithScreenWidith:font];
}

//UIView (Fit)方法实现,实现fit_configureHeight方法
+ (CGFloat)fit_configureHeight:(CGFloat)height {
    CGFloat H = ShiPei(height);
    return H;
}

//UIFont(FitFont) 分类方法实现,实现fit_configureWithScreenWidith方法
+ (UIFont *)fit_configureWithScreenWidith:(CGFloat)font {
    return [UIFont systemFontOfSize:[self fit_configureHeight:font]];
}

+ (UIFont *)fit_configureWithScreenWidithWeight:(CGFloat)font{
    if (SCREEN_WIDTH == 320) {
        return [UIFont systemFontOfSize:[self fit_configureHeight:font] weight:UIFontWeightMedium];
    }else if (SCREEN_WIDTH == 375){
        return [UIFont systemFontOfSize:[self fit_configureHeight:font] weight:UIFontWeightMedium];
    }else{
        return [UIFont systemFontOfSize:[self fit_configureHeight:font] weight:UIFontWeightMedium];
    }
}

//比较两个日期大小
+(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

+ (NSString *)getLaunchImageName
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    // 竖屏
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}



+ (NSString *)getImageOfBankName:(NSString *)bankName {
    if(kIsEmptyString(bankName))
        return @"";
    NSString *imgName = @"";
    if([bankName isEqualToString:@"中国银行"]){
        imgName = @"zhongguoyinhang";
    }else if([bankName containsString:@"农业银行"]){
        imgName = @"nongyeyinhang";
    }else if([bankName containsString:@"工商银行"]){
        imgName = @"gongshangyinhang";
    }else if([bankName containsString:@"交通银行"]){
        imgName = @"jiaotongyinhang";
    }else if([bankName containsString:@"建设银行"]){
        imgName = @"jiansheyinhang";
    }else if([bankName containsString:@"招商银行"]){
        imgName = @"zhaoshangyinhang";
    }else{//默认图片
        imgName = @"yinlian";
    }
    return imgName;
}

+(UIImage *)getQrImage:(NSString *)url {
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSString *urlString = url?:@"";
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = filter.outputImage;
    CGFloat scale = 6;
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale); // scale 为放大倍数
    CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
    // 保存
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
    UIImage *qrCodeImage = [UIImage imageWithCGImage:imageRef];
    return qrCodeImage;
}
@end
