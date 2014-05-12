//
//  Comment.h
//  Weibo
//
//  Created by ryan on 14-2-27.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"
#import "User.h"

@interface Comment : NSObject

@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *created_at;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, assign) long long *mid;

+ (Comment*)createWithDic:(NSDictionary*)dic;
@end
