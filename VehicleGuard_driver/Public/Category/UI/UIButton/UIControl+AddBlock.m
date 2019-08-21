//
//  UIButton+AddBlock.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "UIControl+AddBlock.h"
#import <objc/runtime.h>

@interface UIControl ()
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;//拖拽手势
@property (strong, nonatomic) NSDictionary *event_blocks;//block事件缓存
@end

@implementation UIControl (AddBlock)

#pragma mark - <*********************** 手势拖拽 ************************>

- (BOOL)enableTouchMove{
    BOOL enable = [objc_getAssociatedObject(self, _cmd) boolValue];
    return enable;
}
- (void)setEnableTouchMove:(BOOL)enableTouchMove{
    if(enableTouchMove == YES){
        if(self.canMoveFrame.size.width == 0){
            self.canMoveFrame = [UIScreen mainScreen].bounds;
        }
        [self addGestureRecognizer:self.panGesture];
    }else{
        [self removeGestureRecognizer:self.panGesture];
    }
    objc_setAssociatedObject(self, @selector(enableTouchMove), @(enableTouchMove), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTouchEndBlock:(void (^)())touchEndBlock{
    objc_setAssociatedObject(self, @selector(touchEndBlock), touchEndBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)())touchEndBlock{
    return objc_getAssociatedObject(self, _cmd);
}

- (CGRect)canMoveFrame{
    CGRect rect = [objc_getAssociatedObject(self, _cmd) CGRectValue];
    return rect;
}
- (void)setCanMoveFrame:(CGRect)moveFrame{
    objc_setAssociatedObject(self, @selector(canMoveFrame), [NSValue valueWithCGRect:moveFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)panGesture{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if(!pan){
        // 添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    pan = objc_getAssociatedObject(self, _cmd);
    return pan;
}

// !!!: 拖拽手势
-(void)panAction:(UIPanGestureRecognizer *)pan{
    //获取手势位置
    CGPoint translation = [pan translationInView:self];
    CGPoint newCenter = CGPointMake(pan.view.center.x+ translation.x,pan.view.center.y + translation.y);
    if (newCenter.x+pan.view.bounds.size.width/2.0>CGRectGetMaxX(self.canMoveFrame)) {
        newCenter.x = CGRectGetMaxX(self.canMoveFrame)-pan.view.bounds.size.width/2.0;
    }
    if (newCenter.x< self.canMoveFrame.origin.x + pan.view.bounds.size.width/2.0) {
        newCenter.x = self.canMoveFrame.origin.x + pan.view.bounds.size.width/2.0;
    }
    if (newCenter.y+pan.view.bounds.size.height/2.0>CGRectGetMaxY(self.canMoveFrame)) {
        newCenter.y = CGRectGetMaxY(self.canMoveFrame)-pan.view.bounds.size.height/2.0;
    }
    if (newCenter.y<self.canMoveFrame.origin.y+pan.view.bounds.size.height/2.0) {
        newCenter.y = self.canMoveFrame.origin.y+pan.view.bounds.size.height/2.0;
    }
    pan.view.center = newCenter;
    [pan setTranslation:CGPointZero inView:self];
    
    if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled){
        if (pan.view.center.x < pan.view.superview.frame.size.width/2.0) {
            [UIView animateWithDuration:0.25 animations:^{
                pan.view.center = CGPointMake(self.canMoveFrame.origin.x + 6 + pan.view.bounds.size.width/2.0, pan.view.center.y);
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                pan.view.center = CGPointMake(CGRectGetMaxX(self.canMoveFrame) - 6 -pan.view.bounds.size.width/2.0, pan.view.center.y);
            }];
        }
    }
}


#pragma mark - <*********************** 按钮事件 ************************>

// !!!: 添加按钮事件
- (void)addBlock:(void(^)(UIControl *sender))block forControlEvents:(UIControlEvents)controlEvents{
    NSAssert(block, @"不行，block必须传！");
    
    SEL sel;
    switch (controlEvents) {
        case UIControlEventTouchDown:
            sel = @selector(UIControlEventTouchDown);
            break;
        case UIControlEventTouchDownRepeat:
            sel = @selector(UIControlEventTouchDownRepeat);
            break;
        case UIControlEventTouchDragInside:
            sel = @selector(UIControlEventTouchDragInside);
            break;
        case UIControlEventTouchDragOutside:
            sel = @selector(UIControlEventTouchDragOutside);
            break;
        case UIControlEventTouchDragEnter:
            sel = @selector(UIControlEventTouchDragEnter);
            break;
        case UIControlEventTouchDragExit:
            sel = @selector(UIControlEventTouchDragExit);
            break;
        case UIControlEventTouchUpInside:
            sel = @selector(UIControlEventTouchUpInside);
            break;
        case UIControlEventTouchUpOutside:
            sel = @selector(UIControlEventTouchUpOutside);
            break;
        case UIControlEventTouchCancel:
            sel = @selector(UIControlEventTouchCancel);
            break;
        default:
            break;
    }
    
    [self.event_blocks setValue:block forKey:NSStringFromSelector(sel)];
    [self addTarget:self action:sel forControlEvents:controlEvents];
}

// !!!: 事件处理
- (void)UIControlEventTouchDown{[self block:_cmd];}
- (void)UIControlEventTouchDownRepeat{[self block:_cmd];}
- (void)UIControlEventTouchDragInside{[self block:_cmd];}
- (void)UIControlEventTouchDragOutside{[self block:_cmd];}
- (void)UIControlEventTouchDragEnter{[self block:_cmd];}
- (void)UIControlEventTouchDragExit{[self block:_cmd];}
- (void)UIControlEventTouchUpInside{[self block:_cmd];}
- (void)UIControlEventTouchUpOutside{[self block:_cmd];}
- (void)UIControlEventTouchCancel{[self block:_cmd];}
- (void)block:(SEL)cmd{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(event_blocks));
    void (^blcok)(UIControl *) = [dic objectForKeyNotNull:NSStringFromSelector(cmd)];
    if(blcok){
        blcok(self);
    }
}

// !!!: setter/getter方法
- (NSDictionary *)event_blocks{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if(!dic){
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic = objc_getAssociatedObject(self, _cmd);
    }
    return dic;
}
@end
