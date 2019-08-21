//
//  KORequestPost.m
//  Xiang_driver
//
//  Created by Vin on 2019/4/18.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "KORequestPost.h"

@implementation KORequestPost

+(void)PostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSLog(@"\n----------------------------------------------------------------------------------------------------------------------------------------------------------\n%@%@\n----------------------------------------------------------------------------------------------------------------------------------------------------------\n%@",[url hasPrefix:@"http"]?@"":kURLMain,url, params);
    // 创建请求对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager POST:[NSString stringWithFormat:@"%@%@",[url hasPrefix:@"http"]?@"":kURLMain, url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 回调成功代码块
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 回调失败代码块
        failure(error);
    }];
}

@end
