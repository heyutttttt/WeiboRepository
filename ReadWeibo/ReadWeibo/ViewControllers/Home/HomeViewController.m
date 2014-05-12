//
//  HomeViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-30.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "HomeViewController.h"
#import "StatusTableViewController.h"
#import "UIView+screenShot.h"
#import "AppDelegate.h"

#import "PostViewController.h"

@interface HomeViewController () <PanGestureRecognizerOfStatusTableVCDelegate,StatusTableViewControllerSetBarsHiddenDelegate>
{
    float panGestureBeginOffsetTop;
    float viewBeginOffsetTop;
    float viewBeginHeight;
}

@property (nonatomic, retain) StatusTableViewController *statusTVC;

@property (nonatomic, retain) UIBarButtonItem *rightItem;

@property (nonatomic, assign) BOOL isNavTopSlided;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)dealloc
{
    [_statusTVC release];
    [_rightItem release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(postStatus)];
    self.navigationItem.rightBarButtonItem = _rightItem;
    
    _statusTVC = [[StatusTableViewController alloc] initWithUrlStr:kURLStrOfStatus];
    _statusTVC.delegate = self;
    [_statusTVC.view setFrame:self.view.bounds];
    [self.view addSubview:_statusTVC.view];
    
    // Do any additional setup after loading the view.
    
    [self.statusTVC refreshDataWithDelayDuration:0.1];
}

- (void)postStatus
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil] autorelease]];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma PanGestureRecognizerOfStatusTableVCDelegate

- (void)handleOfPanGesture:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint translation = [recoginzer translationInView:[self.view superview]];
    
    static float translationYDeviations = 0;
    static BOOL isFirst = YES;
    
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        panGestureBeginOffsetTop = self.navigationController.navigationBar.top;
        viewBeginOffsetTop = self.view.top;
        viewBeginHeight = self.view.height;
    }
    
    if (translation.y <= 0)
    {//hide
        self.navigationController.navigationBar.top = MAX(panGestureBeginOffsetTop+translation.y, -24);
        self.view.top = MAX(viewBeginOffsetTop + translation.y,
                            MIN(-44, (20 - self.statusTVC.tableView.contentInset.top)));//-44
        self.view.height = MIN(viewBeginHeight - translation.y, SCREEN_HEIGH + MIN(44, (self.statusTVC.tableView.contentInset.top - 20)));//44
        
        self.isNavTopSlided = NO;
        
        if (self.navigationController.navigationBar.top == -24)
        {
            
            self.statusTVC.isNavHidden = YES;
            [self.statusTVC.loadingView setHidden:YES];
            
            panGestureBeginOffsetTop = self.navigationController.navigationBar.top;
            viewBeginHeight = self.view.height;
            viewBeginOffsetTop = self.view.top;
            
            [self.navigationItem setRightBarButtonItem:nil animated:NO];
            
            translationYDeviations = 0;
            isFirst= YES;
            self.isNavTopSlided = YES;
        }
    }
    
    else if(translation.y >0 && self.statusTVC.tableView.contentOffset.y <= -64 )
    {
        //show
        
        if (isFirst)
        {
            translationYDeviations = translation.y - 1.0f;
            isFirst = NO;
        }
        
        self.navigationController.navigationBar.top = MIN(panGestureBeginOffsetTop + translation.y - translationYDeviations, 20);
        self.view.top = MIN(viewBeginOffsetTop + translation.y - translationYDeviations , 0);
        self.view.height = MAX(viewBeginHeight - (translation.y - translationYDeviations) , SCREEN_HEIGH);
        
        if (self.navigationController.navigationBar.top == 20)
        {
            self.statusTVC.isNavHidden = NO;
            [self.statusTVC.loadingView setHidden:NO];
            
            panGestureBeginOffsetTop = self.navigationController.navigationBar.top;
            viewBeginHeight = self.view.height;
            viewBeginOffsetTop = self.view.top;
            
            [self.navigationItem setRightBarButtonItem:self.rightItem animated:NO];
            
            translationYDeviations = 0;
            isFirst = YES;
            
            self.isNavTopSlided = NO;
        }
    }
    
    
    if(recoginzer.state == UIGestureRecognizerStateEnded)
    {
        BOOL toTop = translation.y < 0;
        if (toTop)
        {
            
            
            if (self.view.top < 0 && self.view.top > -34)
            {//not finish hide
                [UIView animateWithDuration:0.2 animations:^{
                    self.navigationController.navigationBar.top = -14;
                    self.view.top = -34;
                    self.view.height = 34 + SCREEN_HEIGH;
                }];
            }
            
            [UIView animateWithDuration:0.8 animations:^{
                self.navigationController.navigationBar.top = -24;
                self.view.top =  MIN(-44, (20 - self.statusTVC.tableView.contentInset.top));//-44
                self.view.height = MIN(44, (self.statusTVC.tableView.contentInset.top - 20)) + SCREEN_HEIGH;//44
                
            } completion:^(BOOL finished) {
                
                [self.statusTVC.loadingView setHidden:YES];
                [self.navigationItem setRightBarButtonItem:nil animated:NO];
                translationYDeviations = 0;
                isFirst = YES;
                
                self.isNavTopSlided = YES;
                
            }];
        }
        
        else
        {
            if (self.view.top > -44 && self.view.top < 0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.navigationController.navigationBar.top = 20;
                    self.view.top = 0;
                    self.view.height = SCREEN_HEIGH;
                    
                } completion:^(BOOL finished) {
                    
                    self.isNavTopSlided = NO;
                    
                    translationYDeviations = 0;
                    isFirst = YES;
                    
                    [self.statusTVC.loadingView setHidden:NO];
                    [self.navigationItem setRightBarButtonItem:self.rightItem animated:NO];
                }];
            }
        }
    }
}


#pragma StatusTableViewControllerSetBarsHiddenDelegate

- (void)showNavigationBar
{
    if (self.view.top == -74)
    {
        [UIView animateWithDuration:0.15 animations:^{
            self.navigationController.navigationBar.top = 20;
            self.view.top = 0;
            self.view.height = SCREEN_HEIGH;
            
        } completion:^(BOOL finished) {
            self.statusTVC.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            self.statusTVC.tableView.contentOffset = CGPointMake(0, -64);
            
            [self.statusTVC.loadingView setHidden:NO];
            [self.navigationItem setRightBarButtonItem:self.rightItem animated:NO];
        }];
    }
}

- (void)setNavigationBarHidden:(BOOL)shouleHide
{
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.statusTVC.tableView.contentInset));
    NSLog(@"%@",NSStringFromCGPoint(self.statusTVC.tableView.contentOffset));
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    if (!shouleHide)
    {

       [self.navigationController.navigationBar setHidden:shouleHide];
        
        if (self.isNavTopSlided)
        {
//            self.navigationController.navigationBar.top = 20;
//            self.view.top = 0;
//            self.view.height = SCREEN_HEIGH;
//            [self.statusTVC.loadingView setHidden:NO];
//            [self.navigationItem setRightBarButtonItem:self.rightItem animated:NO];
            
            self.navigationController.navigationBar.top = -24;
            self.view.top = -44;
            
            self.statusTVC.tableView.contentOffset = CGPointMake(0, self.statusTVC.tableView.contentOffset.y + 44);
        }
    }
    
   [self.navigationController.navigationBar setHidden:shouleHide];
    
}

- (void)setTabBarHidden:(BOOL)shouldHide
{
    [self.tabBarController.tabBar setHidden:shouldHide];
}

@end
