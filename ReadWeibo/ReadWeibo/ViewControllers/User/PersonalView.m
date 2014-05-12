//
//  PersonalView.m
//  ReadWeibo
//
//  Created by ryan on 14-3-19.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "PersonalView.h"
#import "UIImageView+WebCache.h"

#define kHeadViewLeft 15
#define kHeadViewTop 15
#define kHeadViewSize 65

#define kLabelHeight 15
#define kLabelWidth 30
#define kLabelTop 50

@interface PersonalView ()

@property (nonatomic, retain) UIImageView *headView;
@property (nonatomic, retain) User *user;

@property (nonatomic, retain) UILabel *statusCountLabel;
@property (nonatomic, retain) UILabel *followersCountLabel;
@property (nonatomic, retain) UILabel *followingsCountLabel;

@property (nonatomic, retain) UILabel *descriptionLabel;

@end

@implementation PersonalView

- (id)initWithUser:(User *)user WithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (_user != user)
        {
            [_user release];
            _user = [user retain];
        }
        
        [self setViews];
    }
    return self;
}

- (void)dealloc
{
    [_headView release];
    [_user release];
    [_followingsCountLabel release];
    [_statusCountLabel release];
    [_followersCountLabel release];
    
    [super dealloc];
}

- (void)setViews
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    [backgroundView setImage:[UIImage imageNamed:@"personalViewBg"]];
    [self addSubview:backgroundView];
    [backgroundView release];
    
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake(kHeadViewLeft, kHeadViewTop, kHeadViewSize, kHeadViewSize)];
    [self addSubview:_headView];
    
    _statusCountLabel = [self setLabel];
    _statusCountLabel.left = 130;
    [_statusCountLabel setTextColor:RGB(46,134,189)];
    [self addSubview:_statusCountLabel];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 3;
    [button setFrame:CGRectMake(self.statusCountLabel.left-5, self.statusCountLabel.top, self.statusCountLabel.width + 10, self.statusCountLabel.top + 20)];
    [button addTarget:self action:@selector(methodForButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    _followersCountLabel = [self setLabel];
    _followersCountLabel.left = 200;
    [_followersCountLabel setTextColor:RGB(46,134,189)];
    [self addSubview:_followersCountLabel];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 4;
    [button setFrame:CGRectMake(self.followersCountLabel.left-5, self.followersCountLabel.top, self.followersCountLabel.width + 10, self.followersCountLabel.top + 20)];
    [button addTarget:self action:@selector(methodForButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    _followingsCountLabel = [self setLabel];
    _followingsCountLabel.left = 272;
    [_followingsCountLabel setTextColor:RGB(46,134,189)];
    [self addSubview:_followingsCountLabel];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 5;
    [button setFrame:CGRectMake(self.followingsCountLabel.left-5, self.followingsCountLabel.top, self.followingsCountLabel.width + 10, self.followingsCountLabel.top + 20)];
    [button addTarget:self action:@selector(methodForButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHeadViewLeft, self.headView.bottom + 7, self.width - 30, 15)];
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    [_descriptionLabel setTextColor:RGB(46,134,189)];
    [self addSubview:_descriptionLabel];
    
    UIButton *button_Photo = [self createButton:@"Photo"];
    button_Photo.tag = 0;
    [self addSubview:button_Photo];
    
    UIButton *button_Collect = [self createButton:@"Collection"];
    button_Collect.tag = 1;
    button_Collect.left = button_Collect.left + SCREEN_WIDTH/3.0;
    [self addSubview:button_Collect];
    
    UIButton *button_Message = [self createButton:@"Message"];
    button_Message.tag = 2;
    button_Message.left = button_Message.left + 2*SCREEN_WIDTH/3.0;
    [self addSubview:button_Message];
}

- (UILabel *)setLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 30, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    return label;
}

- (UIButton *)createButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((SCREEN_WIDTH/3.0 - 100)/2.0, self.height - 45, 100, 40)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(46,134,189) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(methodForButtons:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)updateData:(User *)user
{
    [_headView setImageWithURL:[NSURL URLWithString:user.avatar_large]];
    
    [_statusCountLabel setText:[NSString stringWithFormat:@"%d",user.statuses_count]];
    [_statusCountLabel sizeToFit];
    _statusCountLabel.centerX = 144;
    
    [_followersCountLabel setText:[NSString stringWithFormat:@"%d",user.followers_count]];
    [_followersCountLabel sizeToFit];
    _followersCountLabel.centerX = 216;
    
    [_followingsCountLabel setText:[NSString stringWithFormat:@"%d",user.friends_count]];
    [_followingsCountLabel sizeToFit];
    _followingsCountLabel.centerX = 287;
    
    [_descriptionLabel setText:user.descriptionOfUser];
}

- (void)methodForButtons:(UIButton *)button
{
    if (button.tag == 0)
    {
        [self.delegate methodForPhotoButton];
    }
    
    else if(button.tag == 1)
    {
        [self.delegate methodForCollectionButton];
    }
    
    else if(button.tag == 2)
    {
        [self.delegate methodForMessageButton];
    }
    
    else if(button.tag == 3)
    {
        [self.delegate methodForStatusCountButton];
    }
    
    else if(button.tag == 4)
    {
        [self.delegate methodForFollowersCountButton];
    }
    
    else if(button.tag == 5)
    {
        [self.delegate methodForFollowingsCountButton];
    }
}

@end
