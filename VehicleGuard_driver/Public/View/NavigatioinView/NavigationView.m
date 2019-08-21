//
//  NavigationView.m
//  GuPiaoTong
//
//  Created by songzhaojie on 17/1/12.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "NavigationView.h"
@interface NavigationView ()
@property (strong, nonatomic) UIImageView *backgroundImage;//背景图片
@property (strong, nonatomic) UINavigationBar *navigationBar;//自定义导航

@property (copy, nonatomic) void (^leftBarBtnClickBlock)(void);//返回按钮点击事件
@end

@implementation NavigationView

- (void)dealloc{
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self configNavigationBar];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self){
        [self configNavigationBar];
    }
    return self;
}

- (void)configNavigationBar {
    //背景图
    UIImage *image = [UIImage  imageNamed:@"bar"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    _backgroundImage = [UIImageView new];
    _backgroundImage.image = image;
    [self addSubview:_backgroundImage];
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    //自定义状态栏
    UIView *statusBar  = [UIView new];
    statusBar.backgroundColor = [UIColor clearColor];
    [self addSubview:statusBar];
    [statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo (self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.offset(kStatusBarHeight);
    }];
    
    //自定义导航栏
    UINavigationBar *nav = [UINavigationBar new];
    self.navigationBar  = nav;
    [self addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(statusBar.mas_bottom);
    }];
    
    
    //初始化NavigationItem
    UINavigationItem *item = [UINavigationItem new];
    //删除navigationBar默认背景图
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self setTintColor:[UIColor whiteColor]];
    //标题偏好设置
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,[UIFont systemFontOfSize:18 weight:UIFontWeightMedium],NSFontAttributeName,nil]];
    
    //装载navigationItem
    [self.navigationBar pushNavigationItem:item animated:YES];
}


#pragma mark - <**************************  公有方法 **************************>
- (void)setLeftBtnImage:(NSString *)image {
    [self setTitle:self.navigationBar.topItem.title leftBtnImage:image clickBlock:self.leftBarBtnClickBlock];
}

-(void)setTitle:(NSString*)title leftBtnImage:(NSString *)leftImg clickBlock:(void (^)())leftBarBtnClickBlock{
    self.leftBarBtnClickBlock = leftBarBtnClickBlock;
    
    //标题
    self.navigationBar.topItem.title = title;
    
    //返回按钮
    leftImg = leftImg ?: @"btn_back_white";
    if(leftImg.length) {
        //重写返回按钮
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:leftImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(Leftbtn) ];
        if([leftImg isEqualToString:@"btn_back_white"]){
            leftBar.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        }else{
            CGFloat left = self.leftImageEdge.left, right = self.leftImageEdge.right, top = self.leftImageEdge.top, bottom = self.leftImageEdge.bottom;
            leftBar.imageInsets = UIEdgeInsetsMake(top, left, bottom, right);
        }
        self.navigationBar.topItem.leftBarButtonItem = leftBar;
    }
}

- (void)setBackImageViewHidden:(BOOL)backImageViewHidden {
    self.backgroundImage.hidden = backImageViewHidden;
}

#pragma mark - <************************** 事件处理 **************************>
-(void)Leftbtn
{
    if(self.leftBarBtnClickBlock){
        self.leftBarBtnClickBlock();
    }
}
-(void)reghtBtn1
{

}


#pragma mark - <************************** set/get方法 **************************>
- (void (^)(void))leftBarBtnClickBlock {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLeftBarBtnClickBlock:(void (^)(void))leftBarBtnClickBlock {
    objc_setAssociatedObject(self, @selector(leftBarBtnClickBlock), leftBarBtnClickBlock, OBJC_ASSOCIATION_COPY);
}

@end
