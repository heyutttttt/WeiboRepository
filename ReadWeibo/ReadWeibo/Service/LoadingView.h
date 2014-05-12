//
//  LoadingView.h
//  Weibo
//
//  Created by ryan on 14-2-24.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (nonatomic, assign) BOOL isEndedAnimating;

- (void)startAnimation;
- (void)stopAnimation;

- (void)setDotNormalWithIndex:(NSInteger)index;
- (void)setDotHightLightedWithIndex:(NSInteger)index;

@end
