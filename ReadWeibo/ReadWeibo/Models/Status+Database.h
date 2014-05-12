//
//  Status+Database.h
//  ReadWeibo
//
//  Created by ryan on 14-4-13.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Status.h"

@interface Status (Database)

- (BOOL)save;

+ (void)saveArray:(NSArray*)array;

+ (Status *)getStatusByID:(long long)statusID;

+ (NSArray *)getStatuses;

@end
