//
//  DashLineView.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2018/1/24.
//  Copyright © 2018年 songzhaojie. All rights reserved.
//

#import "DashLineView.h"

@interface DashLineView ()

@end
@implementation DashLineView

- (void)dealloc{
//    DLog(@"fdsa");
}

- (void)layoutSubviews{
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    BOOL widthThanHeight = rect.size.width > rect.size.height;//宽大于高
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    
    if(self.drawAround == NO){//水平、竖直绘制
        CGContextSetLineWidth(context, widthThanHeight ? rect.size.height : rect.size.width);
        CGContextMoveToPoint(context, widthThanHeight ?  0 : rect.size.width / 2.0,  widthThanHeight ? rect.size.height / 2.0 : 0);
        CGContextAddLineToPoint(context, widthThanHeight ? rect.size.width : rect.size.width / 2.0, widthThanHeight ? rect.size.height / 2.0 : rect.size.height);
    }else{//沿四周绘制
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddRect(context, rect);
    }
    
    CGFloat length[] = {self.lineLength, self.lineSpace};
    CGContextSetLineDash(context, 0, length, 2);
    CGContextStrokePath(context);
}


#pragma mark get/set方法
//- (void)setLineColor:(UIColor *)lineColor{
//    _lineColor = lineColor;
//}
- (UIColor *)lineColor{
    if(!_lineColor){
        _lineColor = kColor_bluce;
    }
    return _lineColor;
}

- (CGFloat)lineLength{
    if(!_lineLength){
        _lineLength = 4;
    }
    return _lineLength;
}

- (CGFloat)lineWidth{
    if(!_lineWidth){
         _lineWidth = 1;
    }
    return _lineWidth;
}

- (CGFloat)lineSpace{
    if(!_lineSpace){
        _lineSpace = 2;
    }
    return _lineSpace;
}

@end
