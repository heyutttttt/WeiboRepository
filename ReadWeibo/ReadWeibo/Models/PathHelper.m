//
//  PathHelper.m
//  ReadWeibo
//
//  Created by ryan on 14-4-13.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "PathHelper.h"

@implementation PathHelper

+ (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"readWeibo.db"];
    
    return path;
}
@end
