//
//  Status.m
//  Weibo
//
//  Created by ryan on 14-1-28.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Status.h"


@implementation Status

+ (Status*)createWithDic:(NSDictionary*)dic
{
    Status *status = [[[Status alloc] init] autorelease];
    status.create_at = [status getTime:[dic objectForKey:@"created_at"] ];
    status.statusId = [[dic objectForKey:@"id"] longLongValue];
    status.sender = [User createWithDic:[dic objectForKey:@"user"]];
    status.source = [status setStatusSource:dic];
    status.text = [dic objectForKey:@"text"];
    status.reposts_count = [[dic objectForKey:@"reposts_count"] intValue];
    status.comments_count = [[dic objectForKey:@"comments_count"] intValue];
    status.attitudes_count  = [[dic objectForKey:@"attitudes_count"] intValue];
    //
    [status setRetweet:[dic objectForKey:@"retweeted_status"]];
    //
    [status setDisplayPicURL:dic];
    return status;
}

+ (Status*)createWithDicOfDatabase:(NSDictionary *)dic
{
//      @"retweeted_status": [NSNumber numberWithLongLong:sqlite3_column_int64(statement, 3)],

    Status *status = [[[Status alloc] init] autorelease];
    status.statusId = [[dic objectForKey:@"id"] longLongValue];
    status.text = [dic objectForKey:@"text"];
    status.create_at = [dic objectForKey:@"created_at"];
    status.source = [dic objectForKey:@"source"];
    status.reposts_count = [[dic objectForKey:@"reposts_count"] integerValue];
    status.comments_count = [[dic objectForKey:@"comments_count"] integerValue];
    status.attitudes_count = [[dic objectForKey:@"attitudes_count"] integerValue];
    status.sender = [dic objectForKey:@"user"];
    status.thumbnailPics = [dic objectForKey:@"thumbnailPics"];
    status.bmiddlePics = [dic objectForKey:@"bmiddlePics"];
    
    if ([dic objectForKey:@"retweeted_status"])
    {
        status.retweeted_status = [[Status alloc] init];
        NSDictionary *dic_ret = [dic objectForKey:@"retweeted_status"];
        status.retweeted_status.statusId = [[dic_ret objectForKey:@"id"] longLongValue];
        status.retweeted_status.text = [dic_ret objectForKey:@"text"];
        status.retweeted_status.create_at = [dic_ret objectForKey:@"created_at"];
        status.retweeted_status.source = [dic_ret objectForKey:@"source"];
        status.retweeted_status.reposts_count = [[dic_ret objectForKey:@"reposts_count"] integerValue];
        status.retweeted_status.comments_count = [[dic_ret objectForKey:@"comments_count"] integerValue];
        status.retweeted_status.attitudes_count = [[dic_ret objectForKey:@"attitudes_count"] integerValue];
        status.retweeted_status.sender = [dic_ret objectForKey:@"user"];
        status.retweeted_status.thumbnailPics = [dic_ret objectForKey:@"thumbnailPics"];
        status.retweeted_status.bmiddlePics = [dic_ret objectForKey:@"bmiddlePics"];
    }
    
    return status;
}

- (void)dealloc
{
    [_create_at release];
    [_sender release];
    [_source release];
    [_text release];
    [_retweeted_status release];
    [_bmiddlePics release];
    [_thumbnailPics release];
    
    [super dealloc];
}

- (void)setDisplayPicURL:(NSDictionary *)dic
{
    NSArray *array_Pics = [dic objectForKey:@"pic_urls"];
    _thumbnailPics = [[NSMutableArray alloc] init];
    _bmiddlePics = [[NSMutableArray alloc] init];
    if ([array_Pics count] > 0)
    {
        for (NSDictionary *dic_Pics in array_Pics)
        {
            [self.thumbnailPics addObject:[dic_Pics objectForKey:@"thumbnail_pic"]];

            [self.bmiddlePics addObject:[self setStringWithBmiddle:[dic_Pics objectForKey:@"thumbnail_pic"]]];
        }
    }
}


- (NSString *)setStringWithBmiddle:(NSString *)urlStr
{
    NSRange range = [urlStr rangeOfString:@"thumbnail"];
    NSString *stringForward = [urlStr substringToIndex:range.location];
    NSString *stringBehind = [urlStr substringFromIndex:(range.location + range.length)];
    
    return [NSString stringWithFormat:@"%@bmiddle%@",stringForward,stringBehind];
}

- (void)setRetweet:(NSDictionary *)dic
{
    if (dic != nil)
    {
        self.retweeted_status = [[Status alloc] init];
        self.retweeted_status.statusId = [[dic objectForKey:@"id"] longLongValue];
        self.retweeted_status.sender = [User createWithDic:[dic objectForKey:@"user"]];
        self.retweeted_status.text = [dic objectForKey:@"text"];
        self.retweeted_status.create_at = [self getTime:[dic objectForKey:@"created_at"]];
        self.retweeted_status.comments_count = [[dic objectForKey:@"comments_count"] intValue];
        self.retweeted_status.reposts_count = [[dic objectForKey:@"reposts_count"] intValue];
        self.retweeted_status.attitudes_count = [[dic objectForKey:@"attitudes_count"] intValue];
        
        [self.retweeted_status setDisplayPicURL:dic];
        
        self.retweeted_status.source = [self setStatusSource:dic];
    }
}

- (NSString *)setStatusSource:(NSDictionary *)dic
{
    NSString *sourceStr = [dic objectForKey:@"source"];
    NSInteger location1 = [sourceStr rangeOfString:@">"].location;
    NSInteger location2 = [sourceStr rangeOfString:@"</"].location;
    NSInteger length = location2 - location1 - 1;
    NSString *subStr = [sourceStr substringWithRange:NSMakeRange(location1 + 1, length)];
    return subStr;
//    return [NSString stringWithFormat:@"来自 %@",subStr];
//    self.source = subStr;
}

- (NSString *)getTime:(NSString *)time
{
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date=[iosDateFormater dateFromString:time];
    int second = (int)[[NSDate date] timeIntervalSinceDate:date];
    NSString *string = nil;
    if (second > 3600)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        
        if (second < 86400)
        {
            string = [NSString stringWithFormat:@"%d小时前", second / 3600];
        }
        else if(second < 86400 * 2)
        {
            string = dateString;
        }
        else if(second < 86400 * 3)
        {
            string = dateString;
        }
        else if(second < 86400 * 4)
        {
            string = dateString;
        }
        else
        {
            string = dateString;
        }
    }
    else
    {
        if (second < 60)
        {
            string = @"刚刚";
        }
        else
        {
            string = [NSString stringWithFormat:@"%d分钟前", second / 60];
        }
    }
    
    return string;
}

@end
