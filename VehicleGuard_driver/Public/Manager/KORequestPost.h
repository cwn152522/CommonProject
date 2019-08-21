//
//  KORequestPost.h
//  Xiang_driver
//
//  Created by Vin on 2019/4/18.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

@interface KORequestPost : NSObject

typedef void(^ProgressBlock)(id progress);
typedef void(^SuccessBlock)(id success);
typedef void(^FailureBlock)(id failure);

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

@end

NS_ASSUME_NONNULL_END
