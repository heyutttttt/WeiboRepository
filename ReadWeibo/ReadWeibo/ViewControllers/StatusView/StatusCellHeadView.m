//
//  StatusCellHeadView.m
//  ReadWeibo
//
//  Created by ryan on 14-3-10.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "StatusCellHeadView.h"
#import "UIImageView+WebCache.h"

#define kHeadViewSize 30
#define kNameLabelFont [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define kNameLabelSize 15
#define kNameLabelTextColor RGB(46,134,189)

#define KLocationLabelFont [UIFont fontWithName:@"STHeitiSC-Light" size:13]
#define kLocationLabelSize 13
#define kLocationLabelTextColor RGB(46,134,189)

#define kRadius 0.5

@interface StatusCellHeadView ()

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIImageView *headView;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) User *user;
@end

@implementation StatusCellHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CAGradientLayer *shadow = [CAGradientLayer layer];
        
        [shadow setStartPoint:CGPointMake(0.5, 1.0)];
        [shadow setEndPoint:CGPointMake(0.5, 0.0)];
        
        shadow.frame = CGRectMake(0, self.bounds.size.height - kRadius, self.bounds.size.width, kRadius);
        
        shadow.colors = [NSArray arrayWithObjects:(id)[RGB(46,134,189) CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [self.layer insertSublayer:shadow atIndex:0];
        
        [self createViews];
    }
    return self;
}

- (void)dealloc
{
    [_nameLabel release];
    [_headView release];
    [_locationLabel release];
    [_user release];
    
    [super dealloc];
}

- (void)createViews
{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setAlpha:0.85];
    
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake((self.height - kHeadViewSize)*0.5, (self.height - kHeadViewSize)*0.5, kHeadViewSize, kHeadViewSize)];
//    [self.headView setAlpha:1.0];
    [self addSubview:self.headView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.right + 5, 0, 0, kNameLabelSize)];
    self.nameLabel.font = kNameLabelFont;
    self.nameLabel.textColor = kNameLabelTextColor;
//    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.centerY = self.height * 0.5;
    [self addSubview:self.nameLabel];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - kLocationLabelSize)/2.0, 0, kLocationLabelSize)];
    self.locationLabel.textColor = kLocationLabelTextColor;
//    self.locationLabel.textColor = [UIColor whiteColor];
    self.locationLabel.font = KLocationLabelFont;
    self.locationLabel.right = self.width - 5;
    [self addSubview:self.locationLabel];

}


- (void)setDatasOnView:(User *)user
{
    if (_user == user)
    {
        return;
    }
    else
    {
        [_user release];
        _user = [user retain];
        
        [self.headView setImageWithURL:[NSURL URLWithString:user.avatar_large]];
        [self addSubview:self.headView];
        
        float width = [user.name boundingRectWithSize:CGSizeMake(MAXFLOAT, kNameLabelSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kNameLabelFont} context:nil].size.width;
        self.nameLabel.width = width;
        [self.nameLabel setText:user.name];
        
        width = [user.location boundingRectWithSize:CGSizeMake(MAXFLOAT, kLocationLabelSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: KLocationLabelFont} context:nil].size.width;
        self.locationLabel.width = width;
        [self.locationLabel setText:user.location];
        self.locationLabel.right = self.width - 5;
    }
}

@end
