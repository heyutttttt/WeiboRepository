//
//  Repost.h
//  Weibo
//
//  Created by ryan on 14-2-28.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"
#import "User.h"

@interface Repost : NSObject

@property (nonatomic, assign) long long statusID;

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *created_at;
@property (nonatomic, retain) NSString *text;
//@property (nonatomic, retain) NSString *source;

+ (Repost *)createWithDic:(NSDictionary *)dic;
@end
