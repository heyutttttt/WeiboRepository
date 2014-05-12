//
//  Repost.m
//  Weibo
//
//  Created by ryan on 14-2-28.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Repost.h"

@implementation Repost

+ (Repost *)createWithDic:(NSDictionary *)dic
{
    Repost *repost = [[Repost alloc] init];
    repost.created_at = [repost getTime:[dic objectForKey:@"created_at"]];
    repost.text = [dic objectForKey:@"text"];
    repost.user = [User createWithDic:[dic objectForKey:@"user"]];
    return repost;
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
//        self.accurateTime = [dateFormatter stringFromDate:date];
        
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
