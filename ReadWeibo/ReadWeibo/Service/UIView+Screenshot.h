//
//  UIView+Screenshot.h
//  ReadWeibo
//
//  Created by ryan on 14-4-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

-(UIImage *)convertViewToImage;
- (UIImage *)convertViewToBlurryImageWithBlur:(CGFloat)blur;

@end
