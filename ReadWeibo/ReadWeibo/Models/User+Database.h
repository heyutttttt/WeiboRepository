//
//  User+Database.h
//  ReadWeibo
//
//  Created by ryan on 14-4-14.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "User.h"

@interface User (Database)

- (BOOL)save;

+ (void)saveArray:(NSArray*)array;

+ (User *)getStatusByID:(long long)userID;

+ (NSArray *)getUsers;
- (BOOL)clearDB;

@end
