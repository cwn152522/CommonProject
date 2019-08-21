//
//  KOCenterTitleAlertView.m
//  Xiang_driver
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "KOCenterTitleAlertView.h"

@interface KOCenterTitleAlertView ()
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *itemBtns;//复选框 按钮
@property (assign, nonatomic) NSInteger selectIndex;
@end

@implementation KOCenterTitleAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title items:(NSArray *)items selectIndex:(NSInteger)index{
    self.selectIndex = index;
    self.titleLabel.text = title;
    [self.items addObjectsFromArray:items];
    [self resetUI];
}

- (void)resetUI {
    [self.itemBtns removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //白色背景
    UIView *backView = [UIView new];
    backView.layer.cornerRadius = ShiPei(5);
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = UIColor.whiteColor;
    
    //标题
    [backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(backView);
        make.height.offset(ShiPei(40));
    }];//标题下面的分割线
    UIView *line = UIView.new;
    line.backgroundColor = HexColor(0xe3e3e3);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.offset(0.5);
    }];
    
    
    //items
    UIView *temp = nil;
    for (int i = 0; i < self.items.count; i ++) {
        UIView *view = [UIView new];
        [backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(line).offset(15);
            make.right.equalTo(line).offset(-15);
            make.top.equalTo(temp ? temp.mas_bottom : line.mas_bottom);
            make.height.offset(ShiPei(56));
        }];
        temp = view;
        //
        UIView *line = [UIView new];
        line.backgroundColor = HexColor(0xe3e3e3);
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.bottom.equalTo(view.mas_bottom);
            make.height.offset(0.5);
        }];
      //
        UIButton *title = [UIButton buttonWithType:UIButtonTypeSystem];
        [title.titleLabel setFont:[UIFont systemFontOfSize:ShiPei(15)]];
        [title setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
        title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
        }];
        [title setTitle:self.items[i] forState:UIControlStateNormal];
        [title setTag:i];
        [title addTarget:self action:@selector(onSelectTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    
        UIButton *itembtn = [[UIButton alloc] init];
        [view addSubview:itembtn];
        [itembtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right);
            make.centerY.equalTo(view.mas_centerY);
        }];
        [itembtn setImage:[UIImage imageNamed:@"withdraw_unselect"] forState:UIControlStateNormal];
        [itembtn setImage:[UIImage imageNamed:@"withdraw_select"] forState:UIControlStateSelected];
        if(self.selectIndex == i){
            itembtn.selected = YES;
        }else{
            itembtn.selected = NO;
        }
        itembtn.userInteractionEnabled = NO;
        [self.itemBtns addObject:itembtn];
    }
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom);
    }];
    
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(ShiPei(-20));
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [self show];
}


#pragma mark - <************************** 事件处理 **************************>
- (void)onSelectTitle:(UIButton *)sender {
    if(self.onSelectItemDown){
        self.onSelectItemDown(self.items[sender.tag]);
    }
    [self dismiss];
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
    

#pragma mark - <************************** get方法 **************************>

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:ShiPei(16) weight:UIFontWeightMedium];
        _titleLabel.textColor = HexColor(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (NSMutableArray *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
