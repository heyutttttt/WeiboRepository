//
//  Personal_Info.h
//  Weibo
//
//  Created by ryan on 14-1-23.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, assign)long long userID;
@property (nonatomic, assign)bool following;
//@property (nonatomic, assign)bool follow_me;
@property (nonatomic, assign)NSInteger statuses_count;
@property (nonatomic, assign)NSInteger friends_count;
@property (nonatomic, assign)NSInteger followers_count;

@property (nonatomic, retain)NSString *descriptionOfUser;
@property (nonatomic, retain)NSString *gender;
@property (nonatomic, retain)NSString *location;
@property (nonatomic, retain)NSString *screen_name;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString* avatar_large;
@property (nonatomic, retain)NSString* avatar_hd;

+ (User*)createWithDic:(NSDictionary*)dic;

@end
