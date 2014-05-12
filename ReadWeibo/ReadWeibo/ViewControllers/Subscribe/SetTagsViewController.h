//
//  SetTagsViewController.h
//  ReadWeibo
//
//  Created by ryan on 14-3-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetTagsViewController;

@protocol SetTagsVCDelegate <NSObject>

- (void)savaSelectedDicData;

@end



@interface SetTagsViewController : UIViewController

@property (nonatomic, retain) id<SetTagsVCDelegate> delegate;

- (id)initwithDic:(NSMutableDictionary *)dic;

@end
