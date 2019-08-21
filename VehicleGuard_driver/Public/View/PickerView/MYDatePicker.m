//
//  MYDatePicker.m
//  GuDaShi
//
//  Created by chenweinan on 17/2/27.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYDatePicker.h"
#define RGBColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

static CGFloat const kDatePickerHeight = 215;
static CGFloat const kNaviPickerBarHeight = 44;

@interface MYDatePicker ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIView *backView;//日期背景视图
@property (strong, nonatomic) UILabel *titleLabel;//标题

@property (nonatomic, weak) UIView *contentView;//self的父视图
@property (nonatomic, strong) NSLayoutConstraint *constraintY;//self底部相对父视图底部的约束

@property (nonatomic, strong) UIPickerView *datePicker;//自定义pickerview
@property (nonatomic, strong) UIDatePicker *system_datePicker;//系统pickerview

//以下二者一起可组成顶部导航
@property (strong, nonatomic) UINavigationBar *naviPickerBar;

@property (strong, nonatomic) NSString *selectDate;//当前选中的日期
@property (strong, nonatomic) NSString *outFormat;//当前选中的日期格式

@property (weak, nonatomic) id <MYDatePickerDatasource> datasource;

@end

@implementation MYDatePicker

- (id)initWithContentView:(UIView *)contentView dataSource:( id <MYDatePickerDatasource>)datasource pickerType:(MYDatePickerType) type{
    if (self = [super init]) {
        _type = type;
        self.contentView = contentView;
        self.datasource = datasource;
        self.backgroundColor = [HexColor(0x000000) colorWithAlphaComponent:0.5];
        [contentView addSubview:self];
        
        self.backView = [UIView new];
        [self addSubview:self.backView];
        
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *constraintsH1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
        NSArray *constraintsV1 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[self]-0-|"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
        [contentView addConstraints:constraintsH1];
        [contentView addConstraints:constraintsV1];
        
        [self.backView setTranslatesAutoresizingMaskIntoConstraints:NO];
        constraintsH1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView)];
        constraintsV1 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_backView(==%lf)]", kDatePickerHeight + kNaviPickerBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backView)];
        self.constraintY = [NSLayoutConstraint constraintWithItem:self.backView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kDatePickerHeight + kNaviPickerBarHeight];
        
        [self addConstraints:constraintsH1];
        [self addConstraints:constraintsV1];
        [self addConstraint:self.constraintY];
        
        //UIDatePicker初始化，位置在底部216高度；UINavigationBar初始化，位置在picker的顶部
        [self configDatePickerAndNavigationBar];
    }
    
    return self;
}

#pragma mark 控件初始化

- (void)configDatePickerAndNavigationBar{
    if(self.type == MYDatePickerTypeCustomStyle){//自定义pickerview
        self.datePicker = [[UIPickerView alloc] init];
        [self.datePicker setBackgroundColor:[UIColor whiteColor]];
        [self.datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.datePicker.dataSource = self;
        self.datePicker.delegate = self;
        [self.backView addSubview:self.datePicker];
    }else{//系统datepicker
        self.system_datePicker = [[UIDatePicker alloc] init];
        [self.system_datePicker setBackgroundColor:[UIColor whiteColor]];
        self.system_datePicker.datePickerMode = UIDatePickerModeDate;
        self.outFormat = @"yyyy-MM-dd";
        [self.system_datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.system_datePicker addTarget:self action:@selector(onDatePickerSelectedDate:) forControlEvents:UIControlEventValueChanged];
        [self.backView addSubview:self.system_datePicker];
    }
    
    self.naviPickerBar = [[UINavigationBar alloc] init];
    [self.naviPickerBar setClipsToBounds:YES];
    [self.naviPickerBar setBackgroundImage:[self changeColorToImage:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.naviPickerBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backView addSubview:self.naviPickerBar];
    
    NSArray *constraintsH2 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[%@]-0-|", self.type == MYDatePickerTypeCustomStyle ? @"_datePicker" : @"_system_datePicker"] options:0 metrics:nil views:self.type == MYDatePickerTypeCustomStyle ? NSDictionaryOfVariableBindings( _datePicker) : NSDictionaryOfVariableBindings( _system_datePicker)];
    NSArray *constraintsH3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_naviPickerBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_naviPickerBar)];
    NSArray *constraintsV2 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_naviPickerBar(==%lf)]-0-[%@(==%lf)]-0-|", kNaviPickerBarHeight,  self.type == MYDatePickerTypeCustomStyle ? @"_datePicker" : @"_system_datePicker",kDatePickerHeight] options:0 metrics:nil views:self.type == MYDatePickerTypeCustomStyle ? NSDictionaryOfVariableBindings(_naviPickerBar, _datePicker) :NSDictionaryOfVariableBindings(_naviPickerBar, _system_datePicker)];
    
    [self.backView addConstraints:constraintsH2];
    [self.backView addConstraints:constraintsH3];
    [self.backView addConstraints:constraintsV2];
    
    UIView *line = [UIView new];
    line.backgroundColor = HexColor(0xE3E3E3);
    [self.naviPickerBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.naviPickerBar);
        make.height.offset(0.5);
    }];
    
    UILabel *title = [UILabel new];
    title.textColor = HexColor(0x3333333);
    title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.naviPickerBar addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.naviPickerBar);
    }];
    self.titleLabel = title;
    
    [self configNavigationItem];
}

- (void)configNavigationItem{
    self.naviPickerItem = [[UINavigationItem alloc] init];
    [_naviPickerBar pushNavigationItem:_naviPickerItem animated:NO];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftItemAction:)];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} forState:UIControlStateNormal|UIControlStateHighlighted];
    [leftItem setBackgroundImage:[self changeColorToImage:[UIColor whiteColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    _naviPickerItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:kColor_bluce];
    rightBtn.frame = CGRectMake(0, 0, 60, 26);
    [rightBtn.layer setCornerRadius:4];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBtn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _naviPickerItem.rightBarButtonItem = rightItem;
    
    [self setTitleColor:kColor_bluce];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setCurrentDateRow:(NSInteger)row{
    if(row < [self.datasource numberOfDates:self] ){
        _selectRow = row;
        self.selectDate = [self.datasource  picker:self titleForRow:row];
    }
    
    [self.datePicker selectRow:row inComponent:0 animated:YES];
}

- (void)setCurrentDate:(NSString *)date format:(NSString *)format  outPutFormat:(NSString *)outFormat{
    NSAssert([format length], @"format不能为空");
    NSAssert([outFormat length], @"format不能为空");
    
    self.outFormat = outFormat;
    
    //设置当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    [self.system_datePicker setDate:[formatter dateFromString:date] animated:YES];
    
    
    //输出格式
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:outFormat];
    NSString *dateTime = [formatter2 stringFromDate:[formatter dateFromString:date]];
    
    self.selectDate = dateTime;
    self.selectDate = [self.selectDate length] ? self.selectDate  : [formatter2 stringFromDate:[NSDate date]];
}

- (void)setDatePickerMode:(UIDatePickerMode)mode{
    self.system_datePicker.datePickerMode = mode;
}

- (void)reloadData{
    [self.datePicker reloadAllComponents];
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    [self.system_datePicker setMaximumDate:maximumDate];
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    [self.system_datePicker setMinimumDate:minimumDate];
}

- (void)setToolBarColor:(UIColor *)toolBarColor{
    _toolBarColor = toolBarColor;
    [self.naviPickerBar setBackgroundImage:[self changeColorToImage:toolBarColor] forBarMetrics:UIBarMetricsDefault];
    [self.naviPickerItem.leftBarButtonItem setBackgroundImage:[self changeColorToImage:toolBarColor] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.naviPickerItem.rightBarButtonItem setBackgroundImage:[self changeColorToImage:toolBarColor] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)setConfirmTitle:(NSString *)confirmTitle{
    _confirmTitle = confirmTitle;
    self.naviPickerItem.rightBarButtonItem.title = confirmTitle;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.naviPickerItem.leftBarButtonItem.tintColor = HexColor(0x999999);
    self.naviPickerItem.rightBarButtonItem.tintColor = titleColor;
    self.naviPickerBar.tintColor = titleColor;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.datasource numberOfDates:self];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //设置分割线的颜色
    
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = RGBColor(205, 212, 218, 1);
        }
    }
    
    return [self.datasource picker:self titleForRow:row];
}

#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectRow = row;
    self.selectDate = [self.datasource picker:self titleForRow:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat height = 34;
    if([self.delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)]){
        height = [self.delegate pickerView:pickerView rowHeightForComponent:component];
    }
    return height;
}

#pragma mark 事件响应

- (void)onDatePickerSelectedDate:(UIDatePicker *)datePicker{
    NSDate *myDate = datePicker.date;
    
    //输出格式
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:self.outFormat];
    NSString *dateTime = [formatter2 stringFromDate:myDate];
    
    self.selectDate = dateTime;
    self.selectDate = [self.selectDate length] ? self.selectDate  : [formatter2 stringFromDate:[NSDate date]];
}

- (void)leftItemAction:(id)sender{
    [self hidden];
    
    //取消回调
    if(self.selectCanceledBlock){
        self.selectCanceledBlock();
    }
    
    [self.datePicker selectRow:0 inComponent:0 animated:YES];
}

- (void)rightItemAction:(id)sender{
    [self hidden];
    
    if (self.dateSelectedBlock){
        
        if(!self.datasource){//系统datePicker
            [self onDatePickerSelectedDate:self.system_datePicker];
            self.dateSelectedBlock(self.selectDate);
        }else{//自定义pickerView
            self.dateSelectedBlock([self.selectDate length] == 0 ? [self.datasource picker:self titleForRow:0] : self.selectDate);
        }
    }
}

- (void)show{
    if([self.selectDate length] == 0){
        if(self.maximumDate != nil){
            [self.system_datePicker setDate:self.maximumDate animated:YES];
            [self onDatePickerSelectedDate:self.system_datePicker];
        }else{
            [self.system_datePicker setDate:[NSDate date] animated:YES];
            [self onDatePickerSelectedDate:self.system_datePicker];
        }
    }
    
    self.isOnShow = YES;
    __weak typeof(self) weakSelf = self;
    [self.contentView layoutIfNeeded];
    weakSelf.constraintY.constant = 0.0f;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
          weakSelf.alpha = 1.0f;
        [weakSelf.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)hidden{
    self.isOnShow = NO;
    __weak typeof(self) weakSelf = self;
    [self.contentView layoutIfNeeded];
    weakSelf.constraintY.constant = kNaviPickerBarHeight + kDatePickerHeight;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.alpha = 0.0f;
        [weakSelf.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.alpha = 0.0f;
    }];
}

#pragma mark private methods

- (UIImage *)changeColorToImage:(UIColor *)color{
    UIImage *image;
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
