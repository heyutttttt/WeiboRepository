//
//  RetweededStatusView.m
//  ReadWeibo
//
//  Created by ryan on 14-3-9.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "RetweededStatusView.h"
#import "StatusPicsView.h"

#define kImageViewsToText 5
#define kImageViewsTop 3

#define kTextLabelTop 5
#define kTextLabelLeft 5
#define kTextToSource 5

#define kHeight 15

#define kTextFont [UIFont fontWithName:@"STHeitiSC-Light" size:13]
#define kTextLabelWidth (SCREEN_WIDTH - 10)

#define kTextColor RGB(46,134,189)
#define kRadius 3

#define kValidDirections [NSArray arrayWithObjects: @"top", @"bottom", @"left", @"right",nil]

@interface RetweededStatusView ()

@property (nonatomic, retain) UILabel *textLabelOnCell;
@property (nonatomic, retain) UILabel *sourceLabel;
@property (nonatomic, retain) UILabel *countLabel;

@property (nonatomic, retain) UIView *lineViewOnTop;
@property (nonatomic, retain) UIView *lineViewOnBottom;

@property (nonatomic, retain) StatusPicsView *statusPicsView;

@end

@implementation RetweededStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createViews];
    }
    return self;
}

- (void)dealloc
{
    [_textLabelOnCell release];
    [_sourceLabel release];
    [_countLabel release];
    [_statusPicsView release];
    
    [super dealloc];
}

- (void)createViews
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
    [backgroundView setImage:[UIImage imageNamed:@"Ret_StatusBg"]];
    [self addSubview:backgroundView];
    [backgroundView release];
    
    _textLabelOnCell = [[UILabel alloc] initWithFrame:CGRectMake(kTextLabelLeft, kTextLabelTop, kTextLabelWidth, kHeight)];
    self.textLabelOnCell.font = kTextFont;
    self.textLabelOnCell.backgroundColor = [UIColor clearColor];
    self.textLabelOnCell.lineBreakMode = NSLineBreakByClipping;
    self.textLabelOnCell.numberOfLines = 0;
    [self addSubview:self.textLabelOnCell];

    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTextLabelLeft,self.textLabelOnCell.bottom + kTextToSource, 0 , kHeight)];
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    [self.sourceLabel setTextColor:kTextColor];
    self.sourceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.sourceLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.sourceLabel.top, 0, kHeight)];
    self.countLabel.font = [UIFont systemFontOfSize:10];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.countLabel setTextColor:kTextColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.countLabel];
}

- (void)setDatasOfCell:(Status *)status
{
    if (status.bmiddlePics.count > 0)
    {
        if (self.statusPicsView == nil)
        {
            _statusPicsView = [[StatusPicsView alloc] initWithFrame:CGRectMake(0, kImageViewsTop, SCREEN_WIDTH, [StatusPicsView getHeightOfStatusPics])];
            
            _statusPicsView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            
        }
        
        [self addSubview:self.statusPicsView];
        [self.statusPicsView loadForStatusPics:status.bmiddlePics];
        self.textLabelOnCell.top = self.statusPicsView.bottom + kImageViewsToText;
    }
    
    else if(self.statusPicsView != nil)
    {
        [self.statusPicsView removeFromSuperview];
        self.textLabelOnCell.top = kTextToSource;
    }
    
    NSString *text = [NSString stringWithFormat:@"@%@: %@",status.sender.name,status.text];
    self.textLabelOnCell.height = [self getSizeOfString:text WithFont:kTextFont WithSize:CGSizeMake(kTextLabelWidth, MAXFLOAT)].height;
    self.textLabelOnCell.attributedText = [RetweededStatusView setMutableAttributedString:text];
    
    self.sourceLabel.width = [self getSizeOfString:status.source WithFont:self.sourceLabel.font WithSize:CGSizeMake(MAXFLOAT, kHeight)].width;
    [self.sourceLabel setText:status.source];
    self.sourceLabel.top = self.textLabelOnCell.bottom + 5;
    
    NSString *countText = [NSString stringWithFormat:@"赞:%d|转发:%d|评论:%d",status.attitudes_count,status.reposts_count,status.comments_count];
    self.countLabel.width = [self getSizeOfString:countText WithFont:self.countLabel.font WithSize:CGSizeMake(MAXFLOAT, self.countLabel.height)].width;
    [self.countLabel setText:countText];
    self.countLabel.right = self.width - 5;
    self.countLabel.top = self.sourceLabel.top;
}

- (CGSize )getSizeOfString:(NSString *)string
                  WithFont:(UIFont *)font
                  WithSize:(CGSize )sizeOfLabel
{
    CGSize size = [string boundingRectWithSize:sizeOfLabel options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return size;
}

+ (NSMutableAttributedString *)setMutableAttributedString:(NSString *)string
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:@":"];
    [str addAttribute:NSForegroundColorAttributeName value:kTextColor range:NSMakeRange(0, range.location)];
    return str;
}


+ (float)getHeightOfRetweededStatusView:(Status *)status
{
    float height = 0;
    if (status.bmiddlePics.count > 0)
    {
        height = height + kImageViewsTop + [StatusPicsView getHeightOfStatusPics] + kImageViewsToText;        //imageViewsHeight
    }
    
    NSString *text = [NSString stringWithFormat:@"@%@: %@",status.sender.name,status.text];
    
    height = height + [text boundingRectWithSize:CGSizeMake(kTextLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kTextFont} context:nil].size.height + kTextToSource;//text
    
    height = height + kHeight ;//source and count
    
    height = height + 5;//bottom
    return height;
}

@end
