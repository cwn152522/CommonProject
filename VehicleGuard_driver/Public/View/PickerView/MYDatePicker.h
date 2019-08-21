//
//  MYDatePicker.h
//  GuDaShi
//
//  Created by chenweinan on 17/2/27.
//  Copyright © 2017年 songzhaojie. All rights reserved.
// 日期选择|单项选择

#import <UIKit/UIKit.h>
@class MYDatePicker;

@protocol MYDatePickerDatasource <NSObject>

- (NSInteger)numberOfDates:(MYDatePicker *)picker;
- (NSString *)picker:(MYDatePicker *)picker titleForRow:(NSInteger)row;

@end

@protocol MYDatePickerDelegate <NSObject>

@optional;
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

@end


typedef void (^MYDatePickerSelectedDownBlock)(NSString *selectDate);//确认日期按钮事件回调
typedef void (^MYDatePickerSelectedCancelBlock)();//取消按钮事件回调
typedef NS_ENUM(NSUInteger, MYDatePickerType) {
    MYDatePickerTypeCustomStyle,//自定义日期
    MYDatePickerTypeSystemStyle//系统日期
};

@interface MYDatePicker : UIView

@property (copy, nonatomic) MYDatePickerSelectedDownBlock dateSelectedBlock;//取消按钮点击回调
@property (copy, nonatomic) MYDatePickerSelectedCancelBlock selectCanceledBlock;//确定按钮点击回调

@property (assign, nonatomic, readonly) MYDatePickerType type;
@property (strong, nonatomic) NSDate *maximumDate;//允许滚动最大日期(系统)
@property (strong, nonatomic) NSDate *minimumDate;//允许滚动最小日期(系统)
@property (assign, nonatomic, readonly) NSInteger selectRow;//当前选中的行(自定义)
@property (assign, nonatomic) BOOL isOnShow;//datePicker是否正在显示，调用

@property (strong, nonatomic) NSString *title;//可选参数，选择器标题

@property (strong, nonatomic) UIColor *toolBarColor;//工具栏背景色(自定义)
@property (strong, nonatomic) UINavigationItem *naviPickerItem;
@property (strong, nonatomic) NSString *confirmTitle;//确认按钮标题
@property (strong, nonatomic) UIColor *titleColor;//取消、确认按钮字体颜色

@property (weak, nonatomic) id <MYDatePickerDelegate> delegate;//代理(自定义)


/**
 实例化方法
 
 @param contentView 父视图，pikerView会添加至该视图并在底部显示，高度为259
 @param datasource 数据源，仅在仅在type = MYDatePickerTypeCustomStyle时需要传入
 @param type 控件类型，目前可选：1.自定义控件  2.系统日期控件
 @return 时间选择器实例
 */
- (id)initWithContentView:(UIView *)contentView dataSource:( id <MYDatePickerDatasource>)datasource pickerType:(MYDatePickerType) type;

/**
 设置当前日期
 
 @param row 当前需显示日期行数
 @note  仅在type = MYDatePickerTypeCustomStyle时有效
 */
- (void)setCurrentDateRow:(NSInteger)row;

/**
 设置当前日期
 
 @param date 当前选择日期
 @param format 当前日期格式
 @param outFormat 输入日期格式
 @note  仅在type = MYDatePickerTypeSystemStyle时有效
 */
- (void)setCurrentDate:(NSString *)date format:(NSString *)format  outPutFormat:(NSString *)outFormat;

/**
 设置系统日期样式
 
 @param mode 日期样式
 @note  默认样式为：  UIDatePickerModeDate    eg.2017-09-26；
 @note  日期时间样式为： UIDatePickerModeDateAndTime    eg.2017-09-26 10:08；
 @note  时间样式为： UIDatePickerModeTime    eg.10:08
 @note  仅在type = MYDatePickerTypeSystemStyle时有效，设置完会马上切换到指定样式
 */
- (void)setDatePickerMode:(UIDatePickerMode)mode;

/**
 刷新数据
 
 @note 仅在type = MYDatePickerTypeCustomStyle时有效
 */
- (void)reloadData;

/**
 弹出日期控件
 */
- (void)show;

/**
 收起日期控件
 */
- (void)hidden;

@end
