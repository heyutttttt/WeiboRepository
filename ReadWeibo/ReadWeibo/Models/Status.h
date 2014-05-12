//
//  Status.h
//  Weibo
//
//  Created by ryan on 14-1-28.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Status : NSObject

@property (nonatomic, assign) long long statusId;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) User* sender;
@property (nonatomic, retain) Status* originStatus;
@property (nonatomic, retain) NSString *create_at;
@property (nonatomic, retain) NSString* source;
@property (nonatomic, assign) int reposts_count;
@property (nonatomic, assign) int comments_count;
@property (nonatomic, assign) int attitudes_count;
@property (nonatomic, retain) Status *retweeted_status;

@property (nonatomic, retain) NSMutableArray *thumbnailPics;
@property (nonatomic, retain) NSMutableArray *bmiddlePics;


+ (Status*)createWithDic:(NSDictionary*)dic;
+ (Status*)createWithDicOfDatabase:(NSDictionary *)dic;

- (NSString *)getTime:(NSString *)time;

@end
