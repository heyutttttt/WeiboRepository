//
//  Status+Database.m
//  ReadWeibo
//
//  Created by ryan on 14-4-13.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Status+Database.h"
#import "PathHelper.h"
#import "User+Database.h"
#import <sqlite3.h>

@implementation Status (Database)

- (BOOL)clearDB
{
    sqlite3 *database = [Status openDB];
    sqlite3_stmt *statement;
    
    NSString *sqlStr = @"TRUNCATE TABLE STATUS;";
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        [Status closeDB:database];
        return YES;
    }
    
    else
    {
        [Status closeDB:database];
        return NO;
    }
    
}

- (BOOL)save
{
    return [self saveWithDatabase:nil WithIsoriginal:1];
}

- (BOOL)saveWithDatabase:(sqlite3*)aDatabase WithIsoriginal:(NSInteger)isoriginal
{
    sqlite3 *database = aDatabase;
    
    if (!aDatabase)
    {
        database = [Status openDB];
    }
    
    NSString *sqlStr = @"INSERT OR REPLACE INTO STATUS VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
    sqlite3_stmt *statement;
    
    //预处理过程
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        
        sqlite3_bind_int64(statement, 1, self.statusId);
        sqlite3_bind_text(statement, 2, [self.text UTF8String], -1, NULL);
        sqlite3_bind_int64(statement, 3, self.sender.userID);
        [self.sender save];

        sqlite3_bind_text(statement, 5, [self.create_at UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 6, [self.source UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 7, self.reposts_count);
        sqlite3_bind_int(statement, 8, self.comments_count);
        sqlite3_bind_int(statement, 9, self.attitudes_count);
        sqlite3_bind_text(statement, 10, [[self.thumbnailPics componentsJoinedByString:@","] UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 11, [[self.bmiddlePics componentsJoinedByString:@","] UTF8String], -1, NULL);
        
        if (self.retweeted_status)
        {
            sqlite3_bind_int64(statement, 4, self.retweeted_status.statusId);
        }
        
        else
        {
            sqlite3_bind_int64(statement, 4, -1);
        }
        
        sqlite3_bind_int(statement, 12, isoriginal);
        
        
        //执行插入
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSAssert(NO, @"插入数据失败。");
            
            sqlite3_finalize(statement);
            
            if (!aDatabase)
            {
                [Status closeDB:database];
            }
            
            return NO;
        }
        
    }
    
    sqlite3_finalize(statement);
    
    if (!aDatabase)
    {
        [Status closeDB:database];
    }
    
    return YES;
}

+ (void)saveArray:(NSArray*)array
{
    sqlite3 *database = [Status openDB];
    
    for (Status* status in array)
    {
        [status saveWithDatabase:database WithIsoriginal:1];
        if (status.retweeted_status)
        {
            if ( ![status.retweeted_status saveWithDatabase:database WithIsoriginal:0])
            {
                NSAssert(NO, @"插入失败");
            }
        }
    }
    
    [Status closeDB:database];
}

+ (Status *)getStatusByID:(long long)statusID
{
    sqlite3 *database = [Status openDB];
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM STATUS where ID =?"];
    
    Status *status = nil;
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &statement, NULL) == SQLITE_OK)
    {
        NSString *statusID_str = [NSString stringWithFormat:@"%lld",statusID];
        
        sqlite3_bind_text(statement, 1, [statusID_str UTF8String], -1, NULL);
        
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSDictionary *dic = [Status createStatusDictionary:statement];
            
            if (sqlite3_column_int64(statement, 3) != -1)
            {
                //
                sqlite3_stmt *statement2;
                if (sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &statement2, NULL) == SQLITE_OK)
                {
                    long long ID = sqlite3_column_int64(statement, 3);
                    statusID_str = [NSString stringWithFormat:@"%lld",ID];
                    sqlite3_bind_text(statement2, 1, [statusID_str UTF8String], -1, NULL);
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        NSDictionary *dic_ret = [Status createStatusDictionary:statement2];
                        [dic setValue:dic_ret forKey:@"retweeted_status"];
                    }
                }
                
                sqlite3_finalize(statement2);
            }

            status = [Status createWithDicOfDatabase:dic];
        }
        
    }
    
    sqlite3_finalize(statement);
    
    [Status closeDB:database];
    
    return status;
}

+ (NSMutableDictionary *)createStatusDictionary:(sqlite3_stmt *)statement
{
    NSDictionary *dic =
    @{@"id": [NSNumber numberWithLongLong:sqlite3_column_int64(statement, 0)],
      @"text": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)],
      @"created_at": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)],
      @"source": [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)],
      @"reposts_count": [NSNumber numberWithInt:sqlite3_column_int(statement, 6)],
      @"comments_count": [NSNumber numberWithInt:sqlite3_column_int(statement, 7)],
      @"attitudes_count": [NSNumber numberWithInt:sqlite3_column_int(statement, 8)],
      @"user": [User getStatusByID:sqlite3_column_int64(statement, 2)],
      @"retweeted_statusID": [NSNumber numberWithLongLong:sqlite3_column_int64(statement, 3)],
      @"thumbnailPics": [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] componentsSeparatedByString:@","],
      @"bmiddlePics": [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] componentsSeparatedByString:@","]
      };
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    return mdic;
}

+ (NSArray *)getStatuses
{
    return nil;
}

+ (sqlite3 *)openDB
{
    sqlite3 *database;
    sqlite3_open([[PathHelper getDBPath] UTF8String], &database);
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS STATUS (ID INTEGER PRIMARY KEY, content TEXT, senderID INTEGER, retweeted_statusID INTEGER , create_at TEXT, source TEXT, reposts_count INTEGER, comments_count INTEGER, attitudes_count INTEGER, thumbnailPics TEXT, bmiddlePics TEXT, isOriginal INTEGER DEFAULT 1)";
    
    char *err;
    if (sqlite3_exec(database, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        [Status closeDB:database];
        NSLog(@"数据库操作数据失败!");
    }
    
    return database;
}

+ (BOOL)closeDB:(sqlite3 *)database
{
//    if (sqlite3_close(database) == SQLITE_OK)
//    {
//        return YES;
//    }
//    
//    else
//    {
//        return NO;
//    }
//    
    return ((sqlite3_close(database) == SQLITE_OK) ? YES : NO);
}

@end
