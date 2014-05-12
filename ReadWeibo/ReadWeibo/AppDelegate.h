//
//  AppDelegate.h
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

#define AppDelegateInstance (AppDelegate*)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
