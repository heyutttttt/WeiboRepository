//
//  MessagesHeadView.m
//  ReadWeibo
//
//  Created by ryan on 14-4-9.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "MessagesHeaderView.h"
#import "LoadingView.h"

#define kRadius 0.5

#define kContextOfMessagesHeaderView @"kContextOfMessagesHeaderView"

@interface MessagesHeaderView ()

@property (nonatomic, retain) UIButton *commentButton;
@property (nonatomic, retain) UIButton *repostButton;

@property (nonatomic, retain) UIImageView *underLineView;

@property (nonatomic, retain) LoadingView *loadingView;

@end

@implementation MessagesHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CAGradientLayer *shadow = [CAGradientLayer layer];
        
        [shadow setStartPoint:CGPointMake(0.5, 1.0)];
        [shadow setEndPoint:CGPointMake(0.5, 0.0)];
        
        shadow.frame = CGRectMake(0, self.bounds.size.height - kRadius, self.bounds.size.width, kRadius);
        
        shadow.colors = [NSArray arrayWithObjects:(id)[RGB(46,134,189) CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [self.layer insertSublayer:shadow atIndex:0];
        
        self.underLineView = [self createUnderlineView];
        self.underLineView.bottom = self.height;
        self.underLineView.right = self.width - 10;
        self.underLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.underLineView];
        
        self.commentButton = [self createButton:@"评论"];
        self.commentButton.right = self.width - 10;
        self.commentButton.tag = 0;
        [self addSubview:self.commentButton];
        
        self.repostButton = [self createButton:@"转发"];
        self.repostButton.right = self.commentButton.left - 10;
        self.repostButton.tag = 1;
        [self addSubview:self.repostButton];
        
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
        _loadingView.centerY = self.height *0.5;
        [self addSubview:_loadingView];
        [_loadingView setHidden:YES];
        
        [self.loadingView addObserver:self forKeyPath:@"isEndedAnimating"
                              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                              context:kContextOfMessagesHeaderView];
    
    }
    return self;
}

- (void)dealloc
{
    [_commentButton release];
    [_repostButton release];
    [_underLineView release];
    [_loadingView release];
    
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isEndedAnimating"] && [((NSString *)context) isEqualToString:kContextOfMessagesHeaderView])
    {
        if ( ![[change objectForKey:@"old"] boolValue]  &&
            [[change objectForKey:@"new"] boolValue] )
        {
//            [UIView animateWithDuration:0.5 animations:^{
//                self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//            } completion:^(BOOL finished) {
//                
//                self.isRefreshingData = NO;
//                self.shouldRefreshData = NO;
//                [self.tableView reloadData];
//            }];
            [self.loadingView setHidden:YES];
        }
    }
}

- (UIButton *)createButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, self.height*0.3, 30, self.height*0.6)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(46,134,189) forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)clickOnButton:(UIButton *)button
{
    [self.loadingView setHidden:NO];
    [self.loadingView startAnimation];
    
    UIButton *anotherButton = nil;
    NSInteger origin_X = 0;
    
    if (button.tag == 0)
    {
        anotherButton = self.repostButton;
        origin_X = button.left;
    }
    
    else if (button.tag == 1)
    {
        anotherButton = self.commentButton;
        origin_X = button.left;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.underLineView.left = origin_X;
        [button setTitleColor:RGB(46,134,189) forState:UIControlStateNormal];
        [anotherButton setTitleColor:[UIColor colorWithRed:46/255.0 green:134/255.0 blue:189/255.0 alpha:0.4] forState:UIControlStateNormal];
        
    }completion:^(BOOL finished) {
        //refresh
        [self.loadingView stopAnimation];
    }];
}

- (UIImageView *)createUnderlineView
{
    UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 2)] autorelease];
    UIGraphicsBeginImageContext(view.frame.size);
    [view.image drawInRect:CGRectMake(0, 0, view.width, view.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0f);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 46/255.0, 134/255.0, 189/255.0, 1.0);
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), view.width, 0);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    view.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return view;
}

@end
