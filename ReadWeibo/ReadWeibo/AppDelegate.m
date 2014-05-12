//
//  AppDelegate.m
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "AppDelegate.h"
#import "AccountManager.h"
#import "LogInViewController.h"
#import "MainViewController.h"

#define kLoginVCModal @"kLoginVCModal"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    [self customizeStyle];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginPage) name:kLoginVCModal object:nil];
    
    if ([[AccountManager sharedInstance] isLogin])
    {
        [self showMainPage];
    }
    else
    {
        [self showLoginPage];
    }
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginVCModal object:nil];
    [super dealloc];
}


- (void)showLoginPage
{
    LogInViewController *logVC = [[LogInViewController alloc] init];
    self.window.rootViewController = logVC;
    [logVC release];
}

- (void)showMainPage
{
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = mainVC;
    [mainVC release];
}

- (void)customizeStyle
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
    NSDictionary* barItemTitleAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: [UIFont systemFontOfSize:10]};

    
    [[UITabBarItem appearance] setTitleTextAttributes:barItemTitleAttrs forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:barItemTitleAttrs forState:UIControlStateNormal];

    [UINavigationBar appearance].tintColor = [UIColor whiteColor];

    [UITabBar appearance].tintColor = [UIColor whiteColor];
    
    [UINavigationBar appearance].barTintColor = RGB(46,134,189);//RGB(40, 45, 50);
    [UITabBar appearance].barTintColor = RGB(46,134,189);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse* authResponse = (WBAuthorizeResponse*)response;
        if (authResponse.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            [[AccountManager sharedInstance] loginWithUid:authResponse.userID.longLongValue token:authResponse.accessToken expiredDate:authResponse.expirationDate];
            
            [self showMainPage];
        }
    }
}

- (void)weiboLogIn
{
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

@end
