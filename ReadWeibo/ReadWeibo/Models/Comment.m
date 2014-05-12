//
//  Comment.m
//  Weibo
//
//  Created by ryan on 14-2-27.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Comment.h"

@implementation Comment


+ (Comment*)createWithDic:(NSDictionary*)dic
{
    Comment *comment = [[Comment alloc] init];
    comment.status = [Status createWithDic:[dic objectForKey:@"status"]];
    comment.user = [User createWithDic:[dic objectForKey:@"user"]];
    comment.created_at = [comment.status getTime:[dic objectForKey:@"created_at"]];
    comment.text = [dic objectForKey:@"text"];
    return comment;
}

//- (void)setStatusSource:(NSDictionary *)dic
//{
//    NSString *sourceStr = [dic objectForKey:@"source"];
//    NSInteger location1 = [sourceStr rangeOfString:@">"].location;
//    NSInteger location2 = [sourceStr rangeOfString:@"</"].location;
//    NSInteger length = location2 - location1 - 1;
//    NSString *subStr = [sourceStr substringWithRange:NSMakeRange(location1 + 1, length)];
//    self.source = [NSString stringWithFormat:@"来自%@",subStr];
//}

@end
