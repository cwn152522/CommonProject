//
//  MYProgressHub.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/5/2.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYProgressHUD.h"
//#import "UIView+CWNView.h"
#import "XXTollClass.h"

static UILabel *statusLabel;
static BOOL isVisible = NO;

@interface MYProgressHUD ()

@end

@implementation MYProgressHUD

+ (void)showWithStatus:(NSString *)status{
    [self showWithStatus:status font:15 duration:0.44 delay:1.0f centerYOffset:0];
}

+ (void)showWithStatus:(NSString*)status font:(CGFloat)font duration:(CGFloat)duration delay:(CGFloat)delay centerYOffset:(CGFloat)centerYOffset{
    if (kIsEmptyString(status)) {
        return;
    }
    if(isVisible == YES){
        [statusLabel.layer removeAllAnimations];
        [statusLabel removeFromSuperview];
        isVisible = NO;
    }
    
    if(statusLabel == nil){
        statusLabel = [[UILabel alloc] init];
        statusLabel.backgroundColor = HexColor(0x333333);
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.font = [UIFont systemFontOfSize:font];
        statusLabel.numberOfLines = 0;
        
        statusLabel.layer.cornerRadius = 4.0f;
        statusLabel.layer.masksToBounds = YES;
    }
    
    CGSize size = [status boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
    [statusLabel setText:status];
    [[[UIApplication sharedApplication].delegate window] addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusLabel.superview).offset(centerYOffset);
        make.centerX.equalTo(statusLabel.superview);
        make.height.offset(size.height + 12);
    }];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:statusLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:statusLabel.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:ShiPei(15)];
    left.priority = UILayoutPriorityRequired;
    [statusLabel.superview addConstraint:left];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:statusLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.width + 20];
    width.priority = UILayoutPriorityDefaultHigh;
    [statusLabel.superview addConstraint:width];
    
    isVisible = YES;
    
    [self hideStatusLabelAfterTimInterval:duration delay:delay];
}

+ (void)hideStatusLabelAfterTimInterval:(CGFloat)duration delay:(CGFloat)delay{
    statusLabel.alpha = 1;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        statusLabel.alpha = 0;
    }completion:^(BOOL finished) {
        if(finished == NO)
            return ;
        [statusLabel removeFromSuperview];
        isVisible = NO;
    }];
}

+ (BOOL)isVisible{
    return isVisible;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
