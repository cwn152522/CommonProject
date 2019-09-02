//
//  UIViewController+Based.h
//  BasedVC
//
//  Created by chenweinan on 2017/7/10.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
#import <MBProgressHUD/MBProgressHUD.h>

/**
 关于每个控制器一个独立的导航栏说明
 使用系统的导航很难控制，而且容易出现奇怪的bug，比如
 1.导航的页面pop到没导航的页面，导航栏可能会出现黑色，特别是在侧滑返回手势触发的时候；
 2.每次都要重写navigationItem来捕获系统的默认返回事件，导致返回按钮的图片位置经常不对，还导致代码冗余不好维护；
 3.导航栏的显示隐藏不好控制，由于共用系统导航，每次都得考虑有无导航间的切换对push、pop的其他页面的影响。
 可能需要多次调用setNavigationBarHidden:、setTranslucent:方法等，同样照成很多冗余代码
 
 解决方案：
 1. (基于自定义视图) 在本分类中，添加一个customNavigationBar属性，控制器中需要自定义导航调用self.customNavigationBar懒加载出一个导航视图，其实就一个普通的UIView（但建议子视图直接用UINavigationBar而不是完全自定义）
 然后系统的navigationBar始终隐藏掉。实现应用内导航的统一，同时也没有了上述所有问题
 2. (基于系统导航) 在本分类中，添加一个navigationBarHidden属性，控制器viewDidLoad里当页面不需要导航的时候，设置为yes即可。
 原理是：本分类中利用runtime的方法调配，在viewWillAppear和viewWillDisappear中通过nav的一个代理方法，解决了上诉第1点和第3点的问题
 3.本分类中，添加一个navigationBarBackBtnClickBlock，控制器需要拦截系统的back事件，可实现self.navigationBarBackBtnClickBlock回调，retun no则拦截系统默认pop事件解决了上诉的第2点问题。
 原理是：UINavigationController+Based分类中，重写了系统的push方法，在push前为每一个页面添加navigationItem，如果控制器实现了本分类中的这个block就可以拦截到返回事件
 4.关于有的页面想从y是0开始布局，有的页面想从y是64开始布局，为了避免出现其他未知bug，尽量不用使用setTranslucent:方法，全局setTranslucent:NO即可，而使用解决方案的第2个方案在导航代理方法中setNavigationBarHidden，注意，设置setNavigationBarHidden:YES能解决有导航页pop到无导航页的时候出现黑屏的bug；但是无导航页push无导航页的时候会出现闪屏，这时候得特殊处理, 在push的时候setNavigationBarHidden:NO即可解决
 
 
 
 
 
 总结：建议上述两种方案一起使用
 1.平时，大多数情况下使用系统默认导航即可。。。页面布局以y=64为原点
 - (void)viewDidLoad {
 [super viewDidLoad];
 self.title = @"消息通知";
 }
 
 2.个别页面完全不需要使用导航，也不需要返回按钮和标题，将系统导航隐藏即可。。。。页面布局以y=0为原点
 - (void)viewDidLoad {
 [super viewDidLoad];
 self.navigationBarHidden = YES;//隐藏系统导航
 }
 
 3.部分页面不需要使用导航，但有返回按钮和标题，此时需要有个导航，但没有背景图，将系统导航隐藏，使用自定义导航，背景图去掉即可。。。页面布局以y=0为原点
 - (void)viewDidLoad {
 [super viewDidLoad];
 //1.隐藏系统导航
 self.navigationBarHidden = YES;
 //2.添加自定义导航
 WeakObj(self);
 [self.customNavigationBar setTitle:@"我的账单" leftBtnImage:nil clickBlock:^{//leftBtnImage传nil默认返回箭头
 [weakself.navigationController popViewControllerAnimated:YES];
 }];
 //3.去掉背景图
 self.customNavigationBar.backImageViewHidden = YES;
 }
 
 4.想要拦截系统导航的返回事件自己决定要不要pop，不想直接pop？实现系统导航返回事件回调，return NO即可
 - (void)viewDidLoad {
 [super viewDidLoad];
 //重写返回按钮
 WeakObj(self);
 self.navigationBarBackBtnClickBlock = ^BOOL{
 if (weakself.saveData1==2) {
 [JXTAlertTools showTipTwoBtnAlertViewWith:weakself title:@"新填写的信息未保存\n确认离开此页面?" message:@"" callbackBlock:^(NSInteger btnIndex) {
 if (btnIndex==0)//确定
 {
 [weakself.navigationController popViewControllerAnimated:YES];
 }
 }
 else
 {
 [weakself.navigationController popViewControllerAnimated:YES];
 }
 return NO;
 };
 
 5.想要页面随便哪个位置侧滑都触发返回上一个页面的手势，而不是左边缘才触发？
 - (void)viewDidLoad {
 [super viewDidLoad];
 //导航
 self.isNeedGoBack = YES;
 }
 */
@interface UIViewController (Based)<UIGestureRecognizerDelegate>




// !!!: ------------------------------------------属性类------------------------------------------
// MARK: ---------------------安全域Insets---------------------
/**
 安全域Insets；适配iOS11以下
 */
@property (nonatomic)UIEdgeInsets safeAreaOfInsets;

// MARK: ---------------------加载视图---------------------
/**
 加载视图
 */
@property (strong,nonatomic)MBProgressHUD *loadingView;


// MARK: ---------------------导航视图---------------------
/**
 导航栏是否隐藏，默认为no，需要隐藏时在viewDidLoad设置为yes即可
 */
@property (strong, nonatomic) NavigationView *customNavigationBar;
@property (assign, nonatomic) BOOL navigationBarHidden;//导航栏是否隐藏，内部解决了有导航页pop到无导航页，出现导航栏黑屏的bug
@property (assign, nonatomic) BOOL navigationBarHiddenNoAnimated;//设置导航栏隐藏的时候不要有动画，解决navigationBarHidden=YES导致，无导航页push无导航页的时候，导航栏出现闪屏的bug。。。平时一般不需要用到。
@property (copy, nonatomic) BOOL(^navigationBarBackBtnClickBlock)();//返回按钮回调


// MARK: ---------------------滑动返回手势---------------------
/**
 是否需要滑动返回手势
 */
@property (assign, nonatomic)BOOL isNeedGoBack;


// MARK: ---------------------导航按钮---------------------
/**
 设置右边文本按钮
 */
- (void)setNavigationBarRightBarItemTitle:(NSString *)title onClickBlock:(void(^)(void))block;

// !!!: ------------------------------------------方法类------------------------------------------
@end
