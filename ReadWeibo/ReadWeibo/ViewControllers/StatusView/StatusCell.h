//
//  CustomCell.h
//  Weibo
//
//  Created by ryan on 14-1-27.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface StatusCell : UITableViewCell

@property (nonatomic, retain) Status *status;

+ (CGFloat)getHeightOfCell:(Status *)status;
@end
