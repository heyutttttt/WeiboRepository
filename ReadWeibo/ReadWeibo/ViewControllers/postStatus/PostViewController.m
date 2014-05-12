//
//  PostViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-5-12.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "PostViewController.h"

#import "AccountManager.h"
#import "WeiboSDK.h"

@interface PostViewController ()<UITextViewDelegate,WBHttpRequestDelegate>

@property (nonatomic, retain) IBOutlet UITextView *inputView;
@property (nonatomic, retain) NSString *statusText;
@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _statusText = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_inputView release];
    [_statusText release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary* barItemTitleAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                        NSFontAttributeName: [UIFont systemFontOfSize:15]};
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(methodForBackToHome)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(methodForPostStatus)];
    
    [leftItem setTitleTextAttributes:barItemTitleAttrs forState:UIControlStateNormal];
    [rightItem setTitleTextAttributes:barItemTitleAttrs forState:UIControlStateNormal];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [leftItem release];
    [rightItem release];
    
    self.inputView.delegate = self;
}

- (void)methodForBackToHome
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)methodForPostStatus
{
    AccountManager *account = [AccountManager sharedInstance];
    NSString *urlStr = @"https://api.weibo.com/2/statuses/update.json";
    
    self.statusText = [self.statusText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.statusText,@"status", nil];
    
    [WBHttpRequest requestWithAccessToken:account.token url:urlStr httpMethod:@"POST" params:params delegate:self withTag:@"POSTSTATUS"];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputView becomeFirstResponder];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.statusText = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.statusText = textView.text;
    [self methodForPostStatus];
}



@end
