//
//  HomeViewController.h
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "LoadingView.h"

@protocol PanGestureRecognizerOfStatusTableVCDelegate <NSObject>

- (void)handleOfPanGesture:(UIPanGestureRecognizer *)recoginzer;

@end

@protocol StatusTableViewControllerSetBarsHiddenDelegate <NSObject>

@optional

- (void)showNavigationBar;

- (void)setTabBarHidden:(BOOL)shouldHide;

- (void)setNavigationBarHidden:(BOOL)shouleHide;

@end

@interface StatusTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WBHttpRequestDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<PanGestureRecognizerOfStatusTableVCDelegate,StatusTableViewControllerSetBarsHiddenDelegate> delegate;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) BOOL isNavHidden;
@property (nonatomic, retain) LoadingView *loadingView;

- (id)initWithUrlStr:(NSString *)urlStr;
- (void)refreshDataWithDelayDuration:(float)duration;

@end
