//
//  AccountManager.h
//  Weibo
//
//  Created by ryan on 14-1-29.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "User.h"

@interface AccountManager : NSObject <WBHttpRequestDelegate>

@property (nonatomic, assign) long long uid;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSDate* expiredDate;
@property (nonatomic, retain) User* user;

+ (instancetype)sharedInstance;
- (void)loginWithUid:(long long)uid token:(NSString*)token expiredDate:(NSDate*)expiredDate;
- (void)logout;
- (BOOL)isLogin;
- (void)updateUser:(void (^)(void))completion;
- (void)logout:(void (^)(void))completion;
@end
