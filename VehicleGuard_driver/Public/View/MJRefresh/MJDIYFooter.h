//
//  MJDIYFooter.h
//  Xiang_driver
//
//  Created by mac on 2019/5/8.
//  Copyright © 2019 chuanghu. All rights reserved.
//

//#import "MJRefreshFooter.h"
#import <MJRefresh/MJRefreshAutoNormalFooter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJDIYFooter : MJRefreshAutoFooter
@property (strong ,nonatomic) UIColor *loadingTintColor;
@property (strong ,nonatomic) UIColor *tipColor;
@end

NS_ASSUME_NONNULL_END
