//
//  PersonalView.h
//  ReadWeibo
//
//  Created by ryan on 14-3-19.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol PersonalViewDelegate <NSObject>

@required

- (void)methodForPhotoButton;
- (void)methodForCollectionButton;
- (void)methodForMessageButton;
- (void)methodForStatusCountButton;
- (void)methodForFollowersCountButton;
- (void)methodForFollowingsCountButton;

@end

@interface PersonalView : UIView

@property (nonatomic, assign) id<PersonalViewDelegate> delegate;

- (id)initWithUser:(User *)user WithFrame:(CGRect)frame;
- (void)updateData:(User *)user;
@end
