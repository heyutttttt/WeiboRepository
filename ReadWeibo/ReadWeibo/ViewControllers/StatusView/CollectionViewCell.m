//
//  CollectionViewCell.m
//  ReadWeibo
//
//  Created by ryan on 14-3-12.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}
- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}
@end
