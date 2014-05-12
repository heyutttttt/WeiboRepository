//
//  LogInViewController.m
//  Weibo
//
//  Created by ryan on 14-2-15.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "LogInViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"


#define kButtonWidth SCREEN_WIDTH/2.0
#define kButtonHeight 80

@interface LogInViewController ()

@property (nonatomic, retain) UIButton *logInButton;

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor orangeColor]];
        
        self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.logInButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:97/255.0 blue:0 alpha:1]];
        [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
        [self.logInButton.titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:30]];
        [self.logInButton setFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
        self.logInButton.centerX = SCREEN_WIDTH/2.0;
        self.logInButton.centerY = SCREEN_HEIGH/2;
        [self.logInButton addTarget:self action:@selector(methodForLogInButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.logInButton];
    }
    return self;
}

- (void)dealloc
{
    [_logInButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)methodForLogInButton
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
