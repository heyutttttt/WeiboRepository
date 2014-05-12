//
//  LoadingView.m
//  Weibo
//
//  Created by ryan on 14-2-24.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "LoadingView.h"

#define kDotSize (self.width - kDotPadding*2 - kDotEdge*2)/3.0
#define kDotPadding 5
#define kDotEdge 10

#define kDuration 0.3

@interface LoadingView ()

@property (nonatomic, retain) NSMutableArray *arrayOfDots;
@property (nonatomic, assign) BOOL shouldAnimation;

@end

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.shouldAnimation = NO;
        _arrayOfDots = [[NSMutableArray array] retain];
        for (int i=0; i<3; i++)
        {
            UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - kDotSize)/2.0, kDotSize, kDotSize)];
            dot.left = kDotEdge + i*(kDotPadding+kDotSize);
            dot.backgroundColor = RGB(46,134,189);
            dot.alpha = 0.4;
            [self addSubview:dot];
            [self.arrayOfDots addObject:dot];
            [dot release];
        }
    }
    return self;
}

- (void)dealloc
{
    [_arrayOfDots release];
    [super dealloc];
}

- (void)startAnimation
{
    for (int i=0; i<3; i++)
    {
        [self setDotNormalWithIndex:i];
    }
    
    self.shouldAnimation = YES;
    [self methodForAnimation];
}

- (void)stopAnimation
{
    self.shouldAnimation = NO;
}

- (void)methodForAnimation
{
    self.isEndedAnimating = NO;
    
    [UIView animateWithDuration:kDuration animations:^{
        ((UIView *)self.arrayOfDots[0]).alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kDuration animations:^{
            ((UIView *)self.arrayOfDots[0]).alpha = 0.4;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kDuration animations:^{
                ((UIView *)self.arrayOfDots[1]).alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kDuration animations:^{
                    ((UIView *)self.arrayOfDots[1]).alpha = 0.4;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:kDuration animations:^{
                        ((UIView *)self.arrayOfDots[2]).alpha = 1;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:kDuration animations:^{
                            ((UIView *)self.arrayOfDots[2]).alpha = 0.4;
                        } completion:^(BOOL finished) {
                            
                            if (self.shouldAnimation)
                            {
                                [self methodForAnimation];
                            }
                            
                            else
                            {
                                self.isEndedAnimating = YES;
                            }
                        }];
                    }];
                }];
            }];
        }];
    }];

}

- (void)setDotHightLightedWithIndex:(NSInteger)index
{
    UIView *view = self.arrayOfDots[index];
    view.alpha = 1.0;
}

- (void)setDotNormalWithIndex:(NSInteger)index
{
    UIView *view = self.arrayOfDots[index];
    view.alpha = 0.4;
}

@end
