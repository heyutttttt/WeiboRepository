//
//  TabBarViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+RSAdditions.h"
#import "HomeViewController.h"
#import "SubscribeViewController.h"
#import "UserViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"微博" image:[UIImage imageNamed:@"tab_list"] tag:0];
    UINavigationController *nav_HomeVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    SubscribeViewController *subVC = [[SubscribeViewController alloc] init];
    subVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"订阅" image:[UIImage imageNamed:@"tab_star"] tag:1];
    UINavigationController *nav_SubVC = [[UINavigationController alloc] initWithRootViewController:subVC];
    
    UserViewController *userVC = [[UserViewController alloc] init];
    userVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tab_me"] tag:2];
    UINavigationController *nav_UserVC = [[UINavigationController alloc] initWithRootViewController:userVC];
    
    self.viewControllers = @[nav_HomeVC, nav_SubVC, nav_UserVC];
    self.tabBar.translucent = NO;
    
    [nav_HomeVC release];
    [nav_SubVC release];
    [nav_UserVC release];
}

@end
