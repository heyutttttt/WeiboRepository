//
//  User+Database.m
//  ReadWeibo
//
//  Created by ryan on 14-4-14.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "User+Database.h"
#import "PathHelper.h"
#import <sqlite3.h>

@implementation User (Database)

- (BOOL)save
{
    return [self saveWithDatabase:nil];
}

- (BOOL)clearDB
{
    sqlite3 *database = [User openDB];
    sqlite3_stmt *statement;
    
    NSString *sqlStr = @"TRUNCATE TABLE USER";
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        [User closeDB:database];
        return YES;
    }
    
    else
    {
        [User closeDB:database];
        return NO;
    }

}

- (BOOL)saveWithDatabase:(sqlite3*)aDatabase
{
    sqlite3 *database = aDatabase;
    
    if (!aDatabase)
    {
        database = [User openDB];
    }
    
    NSString *sqlStr = @"INSERT OR REPLACE INTO USER VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    sqlite3_stmt *statement;
    
    //预处理过程
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_int64(statement, 1, self.userID);
        sqlite3_bind_int(statement, 2, (self.following ? 1 : 0));
        sqlite3_bind_int(statement, 3, self.statuses_count);
        sqlite3_bind_int(statement, 4, self.friends_count);
        sqlite3_bind_int(statement, 5, self.followers_count);
        sqlite3_bind_text(statement, 6, [self.descriptionOfUser UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 7, [self.gender UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 8, [self.location UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 9, [self.screen_name UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 10, [self.name UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 11, [self.avatar_large UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 12, [self.avatar_hd UTF8String], -1, NULL);

        //执行插入
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSAssert(NO, @"插入数据失败。");
            
            sqlite3_finalize(statement);
            
            if (!aDatabase)
            {
                [User closeDB:database];
            }
            
            return NO;
        }
    }
    
    sqlite3_finalize(statement);
    
    if (!aDatabase)
    {
        [User closeDB:database];
    }
    
    return YES;
}

+ (User *)getStatusByID:(long long)userID
{
    User *user = nil;
    sqlite3 *database = [User openDB];
    sqlite3_stmt *statement;
    
    NSString *sqlSelect = @"SELECT * FROM USER where ID =?";
    
    if (sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        NSLog(@"数据库操作数据失败!(USER)");
    }
    
    else
    {
        NSString *userID_Str = [NSString stringWithFormat:@"%lld",userID];
        
        sqlite3_bind_text(statement, 1, [userID_Str UTF8String], -1, NULL);
        
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSDictionary *dic =
            @{@"id": [NSNumber numberWithLongLong:sqlite3_column_int64(statement, 0)],
              @"following":
                  [NSNumber numberWithBool:( (sqlite3_column_int(statement, 1) == 1) ? YES : NO)],
              @"statuses_count": [NSNumber numberWithInt:sqlite3_column_int(statement, 2)],
              @"friends_count": [NSNumber numberWithInt:sqlite3_column_int(statement, 3)],
              @"followers_count": [NSNumber numberWithInt:sqlite3_column_int(statement, 4)],
              @"description": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)],
              @"gender": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)],
              @"location": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)],
              @"screen_name": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)],
              @"name": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)],
              @"avatar_large": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)],
              @"avatar_hd": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)]
              };
            user = [User createWithDic:dic];
        }
        
        sqlite3_finalize(statement);
    }
    
    [User closeDB:database];
    
    return user;
}

+ (void)saveArray:(NSArray*)array
{
    //TODO
}

+ (NSArray *)getUsers
{
    return nil;
}

+ (sqlite3 *)openDB
{
    sqlite3 *database;
    sqlite3_open([[PathHelper getDBPath] UTF8String], &database);
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS USER (ID INTEGER PRIMARY KEY, following INTEGER, statusecount INTEGER, friendcount INTEGER, followerscount INTEGER, descriptionOfUser TEXT, gender TEXT, location TEXT, screen_name TEXT, name TEXT, avatar_large TEXT, avatar_hd TEXT)";
    
    char *err;
    if (sqlite3_exec(database, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        [User closeDB:database];
        NSLog(@"数据库操作数据失败!");
        return nil;
    }
    
    return database;
}

+ (BOOL)closeDB:(sqlite3 *)database
{
    return ((sqlite3_close(database) == SQLITE_OK) ? YES : NO);
}


@end
