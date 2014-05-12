//
//  ArcRectangleImageView.m
//  Weibo
//
//  Created by ryan on 14-3-1.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "ArcRectangleImageView.h"

@implementation ArcRectangleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setArcRectangleWithRadius:(CGFloat)radius
                    WithHeight:(CGFloat)height
                     WithWidth:(CGFloat)width
                    WithLineWidth:(CGFloat)lineWidth WithRed:(CGFloat)red
                        WithGreen:(CGFloat)green
                         WithBlue:(CGFloat)blue
                        WithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.width, self.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
//    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(context, 192/255.0, 192/255.0, 192/255.0, 1.0);

    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(context, radius, 0);
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextDrawPath(context, kCGPathFill);
    
    self.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}
@end
