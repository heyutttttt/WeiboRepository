//
//  StatusPicsView.h
//  ReadWeibo
//
//  Created by ryan on 14-3-8.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusPicsView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (void)loadForStatusPics:(NSArray *)arrayOfPics;
+ (float)getHeightOfStatusPics;
@end
