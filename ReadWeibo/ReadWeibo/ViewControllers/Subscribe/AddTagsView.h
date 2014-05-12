//
//  AddTagsView.h
//  ReadWeibo
//
//  Created by ryan on 14-3-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTagsView : UIView

@property (nonatomic, assign) BOOL shouldRemoveFromSuperView;

- (id)initWithFrame:(CGRect)frame WithTags:(NSArray *)array WithDic:(NSMutableDictionary *)dic;

@end


