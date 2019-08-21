//
//  UIScrollView+ExtensionView.m
//  Xiang_driver
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "UIScrollView+ExtensionView.h"
//#import "XXTollClass.h"
#import <objc/runtime.h>

@interface UIScrollView()
@property (strong, nonatomic) UIImageView *emptyImage;
@property (strong, nonatomic) UILabel *emptyTipLabel;
@end

@implementation UIScrollView (ExtensionView)

- (UIImageView *)emptyImage {
    UIImageView *image = objc_getAssociatedObject(self, _cmd);
    if (!image) {
        image = [[UIImageView alloc] init];
        objc_setAssociatedObject(self, _cmd, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return image;
}

- (UILabel *)emptyTipLabel {
    UILabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = [UILabel new];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:ShiPei(14)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =  [UIColor grayColor];;
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}

- (void)showEmptyViewWithImage:(NSString *)imgName tipMsg:(NSString *)msg{
    imgName = imgName ?: @"invalidName-1";
    msg =  msg ?: @"暂无数据";
    
    [self.emptyTipLabel removeFromSuperview];
    [self.emptyImage removeFromSuperview];
    
    [self addSubview:self.emptyImage];
    [self addSubview:self.emptyTipLabel];
    
    __block MASConstraint *consntraint = nil;
    [self.emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        consntraint = make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    [self.emptyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImage.mas_bottom);
        make.left.equalTo(self.mas_left).offset(ShiPei(45));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.emptyImage setImage:[UIImage imageNamed:imgName]];
    [self.emptyTipLabel setText:msg];
    
    [self layoutIfNeeded];
    consntraint.offset(-ShiPei(self.emptyTipLabel.frame.size.height / 2.0 +  self.emptyImage.image.size.height / 2.0));
}

- (void)showEmptyViewWithImage:(NSString *)imgName tipMsgAttr:(NSAttributedString *)msgAttr{
    imgName = imgName ?: @"invalidName-1";
    msgAttr =  msgAttr ?: [[NSMutableAttributedString alloc] initWithString:@""];
    
    [self.emptyTipLabel removeFromSuperview];
    [self.emptyImage removeFromSuperview];
    
    [self addSubview:self.emptyImage];
    [self addSubview:self.emptyTipLabel];
    
    __block MASConstraint *consntraint = nil;
    [self.emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        consntraint = make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    [self.emptyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImage.mas_bottom);
        make.left.equalTo(self.mas_left).offset(ShiPei(45));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.emptyImage setImage:[UIImage imageNamed:imgName]];
    [self.emptyTipLabel setAttributedText:msgAttr];
    
    [self layoutIfNeeded];
    consntraint.offset(-ShiPei(self.emptyTipLabel.frame.size.height / 2.0 + self.emptyImage.image.size.height / 2.0));
}

- (void)hideEmptyView {
    [self.emptyImage removeFromSuperview];
    [self.emptyTipLabel removeFromSuperview];
}

@end
