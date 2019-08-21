//
//  TriangleArrowView.m
//  Xiang_driver
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019 chuanghu. All rights reserved.
//

#import "TriangleArrowView.h"

@implementation TriangleArrowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = HexColor(0xe3e3e3);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //绘制三角形
    CGPoint first = CGPointMake(0, 0);
    CGPoint second = CGPointMake(rect.size.width / 2.0, rect.size.height);
    CGPoint third = CGPointMake(rect.size.width, 0);
    CGContextMoveToPoint(context, first.x, first.y);
    CGContextAddLineToPoint(context, second.x, second.y);
    CGContextAddLineToPoint(context, third.x, third.y);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextMoveToPoint(context, first.x, first.y);
    CGContextAddLineToPoint(context, second.x, second.y);
    CGContextAddLineToPoint(context, third.x, third.y);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
}


@end
