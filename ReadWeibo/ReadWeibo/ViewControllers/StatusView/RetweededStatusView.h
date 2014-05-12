//
//  RetweededStatusView.h
//  ReadWeibo
//
//  Created by ryan on 14-3-9.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface RetweededStatusView : UIView

- (void)setDatasOfCell:(Status *)status;
+ (float)getHeightOfRetweededStatusView:(Status *)status;

@end
