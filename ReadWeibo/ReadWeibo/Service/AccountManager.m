//
//  AccountManager.m
//  Weibo
//
//  Created by ryan on 14-1-29.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "AccountManager.h"
#import "NSString+URLEncoding.h"
#import "LogInViewController.h"

#define kAuthData               @"AuthData"
#define kAuthDataToken          @"AuthDataToken"
#define kAuthDataUid            @"AuthDataUid"
#define kAuthDataExpiredDate    @"AuthDataExpiredDate"
#define kAuthDataUser           @"kAuthDataUser"

#define kUpdateUser @"kUpdateUser"
#define kUserLogOut @"kUserLogOut"

typedef void(^Completion)();

@interface AccountManager ()

@property (nonatomic, copy) Completion tempCompletion;
@property (nonatomic, assign) BOOL shouldSaveData;

@end

@implementation AccountManager

+ (instancetype)sharedInstance
{
    static AccountManager* _instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[AccountManager alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self readData];
        [self updateUser:nil];
    }
    
    return self;
}

- (void)dealloc
{
    self.tempCompletion = nil;
    
    [_token release];
    [_expiredDate release];
    [_user release];
    [super dealloc];
}

- (void)loginWithUid:(long long)uid token:(NSString *)token expiredDate:(NSDate *)expiredDate
{
    self.uid = uid;
    self.token = token;
    self.expiredDate = expiredDate;
    
    //save data
    self.shouldSaveData = YES;
    [self updateUser:nil];
}

- (void)logout
{
    [WeiboSDK logOutWithToken:self.token delegate:self withTag:@"kUserLogOut"];
}

- (void)logout:(void (^)(void))completion
{
    self.tempCompletion = completion;
    [WeiboSDK logOutWithToken:self.token delegate:self withTag:@"kUserLogOut"];
}

- (void)saveData
{
    if (self.isLogin)
    {
        NSDictionary* authData = @{kAuthDataToken: self.token,
                                   kAuthDataUid: [NSNumber numberWithLongLong:self.uid],
                                   kAuthDataExpiredDate: self.expiredDate,
                                   kAuthDataUser: [NSKeyedArchiver archivedDataWithRootObject:self.user]};
        
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:kAuthData];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)readData
{
    NSDictionary* authData = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthData];
    if (authData)
    {
        self.token = [authData objectForKey:kAuthDataToken];
        self.uid = [[authData objectForKey:kAuthDataUid] longLongValue];
        self.expiredDate = [authData objectForKey:kAuthDataExpiredDate];
        self.user = [NSKeyedUnarchiver unarchiveObjectWithData:[authData objectForKey:kAuthDataUser]];
    }
}

- (BOOL)isLogin
{
    return (self.token && self.uid && self.expiredDate);
}

- (void)updateUser:(void (^)(void))completion
{
    if (self.isLogin)
    {
        self.tempCompletion = completion;
        
        NSString *urlStr = @"https://api.weibo.com/2/users/show.json";
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",self.uid],@"uid", nil];
        
        [WBHttpRequest requestWithAccessToken:self.token url:urlStr httpMethod:@"GET" params:params delegate:self withTag:kUpdateUser];
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([request.tag isEqualToString:kUpdateUser])
    {
        self.user = [User createWithDic:dictionary];
        if (self.tempCompletion)
        {
            if (self.shouldSaveData)
            {
                [self saveData];
                self.shouldSaveData = NO;
            }
            
            self.tempCompletion();
            
            self.tempCompletion = nil;
        }
    }
    else if([request.tag isEqualToString:kUserLogOut])
    {
        if ([[dictionary objectForKey:@"result"] isEqualToString:@"true"])
        {
            self.uid = 0;
            self.token = nil;
            self.expiredDate = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAuthData];
            [[NSUserDefaults standardUserDefaults] synchronize];

            //show LogInView
            if (self.tempCompletion)
            {
                self.tempCompletion();
                self.tempCompletion = nil;
            }
        }
    }
}


@end
