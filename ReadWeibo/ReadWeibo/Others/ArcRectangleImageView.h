//
//  ArcRectangleImageView.h
//  Weibo
//
//  Created by ryan on 14-3-1.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcRectangleImageView : UIImageView
- (void)setArcRectangleWithRadius:(CGFloat)radius
                       WithHeight:(CGFloat)height
                        WithWidth:(CGFloat)width
                    WithLineWidth:(CGFloat)lineWidth
                          WithRed:(CGFloat)red
                        WithGreen:(CGFloat)green
                         WithBlue:(CGFloat)blue
                        WithAlpha:(CGFloat)alpha;
@end
