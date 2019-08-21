//
//  OrderListCtl.m
//  VehicleGuard_driver
//
//  Created by mac on 2019/8/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "OrderListCtl.h"

@interface OrderListCtl ()

@end

@implementation OrderListCtl

#pragma mark - <************************** 生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
}


#pragma mark - <************************** 初始化视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.title = @"订单列表";
    self.view.backgroundColor = UIColor.orangeColor;
    self.isNeedGoBack = YES;
}


#pragma mark - <*********************** 懒加载控件/数据 **********************>


#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}


#pragma mark - <************************** 代理方法 **************************>


#pragma mark - <************************** 点击事件 **************************>


#pragma mark - <************************** 私有方法 **************************>


#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    XXLog(@"%@释放掉",[self class]);
}


@end
