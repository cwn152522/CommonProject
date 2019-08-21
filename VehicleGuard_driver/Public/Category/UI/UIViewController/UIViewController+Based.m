//
//  UIViewController+Based.m
//  BasedVC
//
//  Created by chenweinan on 2017/7/10.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "UIViewController+Based.h"
#import <objc/runtime.h>
#import <UMMobClick/MobClick.h>

@interface UIViewController()<UINavigationControllerDelegate,  UINavigationBarDelegate>
@end
@implementation UIViewController (Based)

#pragma mark - ***************************************--- 安全域Insets；适配iOS11以下---***************************************
- (void) jx_viewSafeAreaInsetsDidChange {
    if (@available(iOS 11.0, *)) {
        self.safeAreaOfInsets = self.view.safeAreaInsets;
    } else {
        self.safeAreaOfInsets = UIEdgeInsetsZero;
    }
    [self jx_viewSafeAreaInsetsDidChange];
}

- (UIEdgeInsets)safeAreaOfInsets{
    UIEdgeInsets insets = [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
    if (@available(iOS 11.0, *)) {
        insets = self.view.safeAreaInsets;
    } else {
        insets = UIEdgeInsetsZero;
    }
    return insets;
}
-(void)setSafeAreaOfInsets:(UIEdgeInsets)safeAreaOfInsets {
    objc_setAssociatedObject(self, @selector(safeAreaOfInsets), [NSValue valueWithUIEdgeInsets:safeAreaOfInsets], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark - ***************************************---加载视图---***************************************
-(MBProgressHUD *)loadingView{
    MBProgressHUD *juhua = objc_getAssociatedObject(self, _cmd);
    if (juhua==nil) {
        juhua = [[MBProgressHUD alloc] initWithView:self.view];
//        juhua.label.text = @"正在加载";
        [self.view addSubview:juhua];
        [juhua mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(juhua.superview.mas_centerX);
            make.centerY.equalTo(juhua.superview.mas_centerY);
            make.top.equalTo(juhua.superview.mas_top);
            make.left.equalTo(juhua.superview.mas_left);
        }];
        objc_setAssociatedObject(self, @selector(loadingView), juhua, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return juhua;
}
-(void)setLoadingView:(MBProgressHUD *)loadingView{
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




#pragma mark - ***************************************---导航视图---***************************************
-(NavigationView *)customNavigationBar{
    NavigationView *navBar = objc_getAssociatedObject(self, _cmd);
    if (navBar==nil) {
        navBar = [[NavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kNavigationbarHeight)];
        objc_setAssociatedObject(self, @selector(customNavigationBar), navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.view addSubview:navBar];
    }
    return navBar;
}


-  (BOOL)navigationBarHidden{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden{
        objc_setAssociatedObject(self, @selector(navigationBarHidden), @(navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL (^)())navigationBarBackBtnClickBlock{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNavigationBarBackBtnClickBlock:(BOOL (^)())navigationBarBackBtnClickBlock{
     objc_setAssociatedObject(self, @selector(navigationBarBackBtnClickBlock), navigationBarBackBtnClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - ***************************************---返回手势---***************************************
-(BOOL)isNeedGoBack{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setIsNeedGoBack:(BOOL)isNeedGoBack{
    objc_setAssociatedObject(self, @selector(isNeedGoBack), [NSNumber numberWithBool:isNeedGoBack], OBJC_ASSOCIATION_ASSIGN);
    if (isNeedGoBack) {
        // 获取系统自带滑动手势的target对象
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
        // 设置手势代理，拦截手势触发
        pan.delegate=self;
        // 给导航控制器的view添加全屏滑动手势
        [self.view addGestureRecognizer:pan];
        // 禁止使用系统自带的滑动手势
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if(self.navigationController.childViewControllers.count == 1){
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pag{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ***************************************---是否需要刷新---***************************************
-(BOOL)needToRefresh{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setNeedToRefresh:(BOOL)needToRefresh{
    objc_setAssociatedObject(self, @selector(needToRefresh), [NSNumber numberWithBool:needToRefresh], OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - ***************************************---系统方法调配---***************************************
+ (void)load {
    [self exchangeMethod:@selector(viewDidLoad)];
    [self exchangeMethod:@selector(viewSafeAreaInsetsDidChange)];
    [self exchangeMethod:NSSelectorFromString(@"dealloc")];
    [self exchangeMethod:@selector(viewWillAppear:)];
     [self exchangeMethod:@selector(viewDidAppear:)];
    [self exchangeMethod:@selector(viewWillDisappear:)];
    [self exchangeMethod:@selector(viewDidDisappear:)];
}
+ (void)exchangeMethod:(SEL)originalSelector{
    SEL swizzledSelector = NSSelectorFromString([@"jx_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)jx_viewDidLoad{
    XXLog(@"进入了：%@,%@",[self class],self.title);
    [self jx_viewDidLoad];
}


- (void)jx_dealloc{
    XXLog(@"%@释放啦～～～",[self class]);
    [self jx_dealloc];
}

- (void)jx_viewWillAppear:(BOOL)animated{
    //1.控制隐藏navigationBar
    if(self.navigationController){
        if(self.navigationBarHidden== YES){//如果不需要导航，则实现代理(触发在viewWillAppear前，因此返回手势触发进行页面切换时，不会看到突然黑屏)，在代理中将导航栏隐藏起来即可
            self.navigationController.delegate = self;
        }else{
           [self.navigationController setNavigationBarHidden:NO animated:YES];//动画写yes，否则可能出现黑屏
        }
    }
    //2.默认相应系统边缘手势
    if(self.isNeedGoBack ==  NO){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    //3.设置导航不透明，防止被某些页面或第三方改了yes，导致本来应该不透明的变成了半透明
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)jx_viewDidAppear:(BOOL)animated{
    //页面统计
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    [self jx_viewDidAppear:animated];
}
- (void)jx_viewWillDisappear:(BOOL)animated{
    if(self.navigationBarHidden && self.navigationController){
        self.navigationController.delegate = nil;
    }
}
- (void)jx_viewDidDisappear:(BOOL)animated{
    //页面统计
    [MobClick endLogPageView:NSStringFromClass(self.class)];
    [self jx_viewDidDisappear:animated];
}
// 将要显示控制器 隐藏导航栏，解决有无导航页面切换可能出现黑屏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.navigationBarHidden == YES){
        // 判断要显示的控制器是否是自己
        BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
        [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];//动画写yes否则可能出现黑屏，隐藏后controller原点在y=0，默认原点在y=64
    }
}
- (void)leftAction{
    if(self.navigationBarBackBtnClickBlock){
        BOOL needPop = self.navigationBarBackBtnClickBlock();
        if(needPop){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//状态栏由各自控制器控制，全局控制无效
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}



// MARK: ---------------------导航按钮---------------------
/**
 设置右边文本按钮
 */
- (void)setNavigationBarRightBarItemTitle:(NSString *)title onClickBlock:(void(^)(void))block{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:title?:@"" style:UIBarButtonItemStyleDone target:self action:@selector(rihtAction:) ];
    objc_setAssociatedObject(right, @selector(rihtAction:), block, OBJC_ASSOCIATION_COPY);
    self.navigationItem.rightBarButtonItem = right;
}
- (void)rihtAction:(UIBarButtonItem *)sender{
    void(^block)(void) = objc_getAssociatedObject(sender, _cmd);
    if(block){
        block();
    }
}
@end
