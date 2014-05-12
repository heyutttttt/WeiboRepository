//
//  Personal_Info.m
//  Weibo
//
//  Created by ryan on 14-1-23.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "User.h"

@implementation User

- (void)dealloc
{
    [_descriptionOfUser release];
    [_gender release];
    [_location release];
    [_screen_name release];
    [_name release];
    [_avatar_hd release];
    [_avatar_large release];
    
    [super dealloc];
}

+ (User*)createWithDic:(NSDictionary*)dic
{
    //Convert data from dic to a status object
    User* user = [[User alloc] init];
    user.userID = [[dic objectForKey:@"id"] longLongValue];
    user.name = [dic objectForKey:@"name"];
    user.screen_name = [dic objectForKey:@"screen_name"];
    user.avatar_large = [dic objectForKey:@"avatar_large"];
    user.avatar_hd = [dic objectForKey:@"avatar_hd"];
    user.statuses_count = [[dic objectForKey:@"statuses_count"] integerValue];
    user.followers_count = [[dic objectForKey:@"followers_count"] integerValue];
    user.friends_count = [[dic objectForKey:@"friends_count"] integerValue];
    user.following = [[dic objectForKey:@"following"] boolValue];
    user.descriptionOfUser = [dic objectForKey:@"description"];
    user.location = [dic objectForKey:@"location"];
    user.gender = [dic objectForKey:@"gender"];

    return user;
}

#pragma NSCoder

- (void)encodeWithCoder:(NSCoder *)coder
{
    //    [super encodeWithCoder:coder];
    [coder encodeObject:[NSNumber numberWithBool:self.userID]  forKey:@"userID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.screen_name forKey:@"screen_name"];
    [coder encodeObject:self.avatar_large forKey:@"avatar_large"];
    [coder encodeObject:self.avatar_hd forKey:@"avatar_hd"];
    [coder encodeObject:[NSNumber numberWithInt:self.statuses_count]  forKey:@"statuses_count"];
    [coder encodeObject:[NSNumber numberWithInt:self.followers_count] forKey:@"followers_count"];
    [coder encodeObject:[NSNumber numberWithInt:self.friends_count] forKey:@"friends_count"];
    [coder encodeObject:[NSNumber numberWithBool:self.following] forKey:@"following"];
    [coder encodeObject:self.descriptionOfUser forKey:@"descriptionOfUser"];
    [coder encodeObject:self.location forKey:@"location"];
    [coder encodeObject:self.gender forKey:@"gender"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.userID = [[coder decodeObjectForKey:@"userID"] longLongValue];
        self.name = [coder decodeObjectForKey:@"name"];
        self.screen_name = [coder decodeObjectForKey:@"screen_name"];
        self.avatar_hd = [coder decodeObjectForKey:@"avatar_hd"];
        self.avatar_large = [coder decodeObjectForKey:@"avatar_large"];
        self.statuses_count = [[coder decodeObjectForKey:@"statuses_count"] intValue];
        self.followers_count = [[coder decodeObjectForKey:@"followers_count"] intValue];
        self.friends_count = [[coder decodeObjectForKey:@"friends_count"] intValue];
        self.following = [[coder decodeObjectForKey:@"following"] boolValue];
        self.descriptionOfUser = [coder decodeObjectForKey:@"descriptionOfUser"];
        self.location = [coder decodeObjectForKey:@"location"];
        self.gender = [coder decodeObjectForKey:@"gender"];
    }
    return self;
}


@end
