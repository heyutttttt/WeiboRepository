//
//  Tag.h
//  ReadWeibo
//
//  Created by ryan on 14-3-22.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject<NSCoding>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isOnAddView;

+ (Tag *)TagWithName:(NSString *)nameStr;

@end
