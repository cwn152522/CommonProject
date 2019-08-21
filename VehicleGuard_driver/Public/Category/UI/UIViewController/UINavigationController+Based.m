//
//  UINavigationController+Based.m
//  Xiang_driver
//
//  Created by mac on 2019/4/24.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "UINavigationController+Based.h"
#import <objc/runtime.h>

@implementation UINavigationController (Based)
//状态栏由各自控制器控制，全局控制无效
- (UIStatusBarStyle)preferredStatusBarStyle {
    if([self.childViewControllers count] > 0)
        return self.childViewControllers[0].preferredStatusBarStyle;
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}



#pragma mark - ***************************************---系统方法调配---***************************************
+ (void)load {
    [self exchangeMethod:@selector(pushViewController:animated:)];
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
- (void)jx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //重写返回按钮
    if([viewController isKindOfClass:[UINavigationController class]]){
        return;
    }
    
    if(self.childViewControllers.count == 0){//根页面不需要返回按钮
        [self jx_pushViewController:viewController animated:animated];
        return;
    }
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_white"] style:UIBarButtonItemStyleDone target:viewController action:@selector(leftAction) ];
    left.imageInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    viewController.navigationItem.leftBarButtonItem = left;
    [self jx_pushViewController:viewController animated:animated];
}
@end
