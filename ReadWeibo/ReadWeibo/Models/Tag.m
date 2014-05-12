//
//  Tag.m
//  ReadWeibo
//
//  Created by ryan on 14-3-22.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "Tag.h"

@implementation Tag

+ (Tag *)TagWithName:(NSString *)nameStr
{
    Tag *tag = [[[Tag alloc]init] autorelease];
    tag.name = nameStr;
    tag.isSelected = NO;
    tag.isOnAddView = NO;
    return tag;
}

- (void)dealloc
{
    [_name release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
//    [super encodeWithCoder:coder];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:[NSNumber numberWithBool:self.isSelected]  forKey:@"isSelected"];
    [coder encodeObject:[NSNumber numberWithBool:self.isOnAddView] forKey:@"isOnView"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.name = [coder decodeObjectForKey:@"name"];
        self.isSelected = [[coder decodeObjectForKey:@"isSelected"] boolValue];
        self.isOnAddView = [[coder decodeObjectForKey:@"isOnView"] boolValue];
    }
    return self;
}
@end
