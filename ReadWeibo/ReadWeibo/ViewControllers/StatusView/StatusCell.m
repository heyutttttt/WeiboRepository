//
//  CustomCell.m
//  Weibo
//
//  Created by ryan on 14-1-27.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "StatusCell.h"
#import "RetweededStatusView.h"
#import "StatusPicsView.h"

#define kHeadImageWidth_Height 40

#define kTextFont [UIFont fontWithName:@"STHeitiSC-Light" size:13]
#define kBgViewToText 5
#define kTextLabelWidth 310
#define kTextToTime 5

#define kbgViewWidth SCREEN_WIDTH
#define kTextHeight 15

#define kTextColor RGB(46,134,189)
#define kImageViewsToText 5

#define kCountToRetView 5

#define kDotSize (self.buttonOfCell.width - kDotPadding*2 - kDotEdge*2)/3.0
#define kDotPadding 5
#define kDotEdge 7

@interface StatusCell ()

@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *textLabelOfCell;
@property (nonatomic, retain) UILabel *sourceLabel;
@property (nonatomic, retain) UILabel *countLabel;

@property (nonatomic, retain) StatusPicsView *statusPicsView;

@property (nonatomic, retain) RetweededStatusView *ret_StatusView;

@property (nonatomic, retain) UIButton *buttonOfCell;

@end

@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createViewsOnCell];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc
{
    [_timeLabel release];
    [_textLabelOfCell release];
    [_sourceLabel release];
    [_countLabel release];
    [_ret_StatusView release];
    [_statusPicsView release];
    [_buttonOfCell release];
    
    [super dealloc];
}

- (void)createViewsOnCell
{
    _textLabelOfCell = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kTextLabelWidth, 10)];
    self.textLabelOfCell.font = kTextFont;
    self.textLabelOfCell.backgroundColor = [UIColor clearColor];
    self.textLabelOfCell.lineBreakMode = NSLineBreakByClipping;
    self.textLabelOfCell.numberOfLines = 0;
    [self addSubview:self.textLabelOfCell];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.textLabelOfCell.bottom + kTextToTime, 0, kTextHeight)];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.timeLabel setTextColor:kTextColor];
    [self addSubview:self.timeLabel];
    
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.timeLabel.top, 0, kTextHeight)];
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    [self.sourceLabel setTextColor:kTextColor];
    self.sourceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.sourceLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.timeLabel.bottom + 5, 10, kTextHeight)];
    self.countLabel.right = kbgViewWidth - 5;
    self.countLabel.font = [UIFont systemFontOfSize:10];
    [self.countLabel setTextColor:kTextColor];
    self.countLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.countLabel];
}

- (void)setStatus:(Status *)status
{
    if (_status != status)
    {
        [_status release];
        _status = [status retain];
    }
    
    if (self.status.bmiddlePics.count > 0)
    {
        if (self.statusPicsView == nil)
        {
            _statusPicsView = [[StatusPicsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [StatusPicsView getHeightOfStatusPics])];
            _statusPicsView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        }
        
        [self addSubview:self.statusPicsView];
        [self.statusPicsView loadForStatusPics:self.status.bmiddlePics];
        self.textLabelOfCell.top = self.statusPicsView.bottom + kImageViewsToText;
    }
    else if (self.statusPicsView != nil)
    {
        [self.statusPicsView removeFromSuperview];
        self.textLabelOfCell.top = 5;
    }

    self.textLabelOfCell.height = [self getSizeOfString:self.status.text WithFont:kTextFont WithSize:CGSizeMake(kTextLabelWidth, MAXFLOAT)].height;
    self.textLabelOfCell.width = kTextLabelWidth;
    [self.textLabelOfCell setText:self.status.text];
    [self.textLabelOfCell sizeToFit];

    self.timeLabel.width = [self getSizeOfString:self.status.create_at WithFont:self.timeLabel.font WithSize:CGSizeMake(MAXFLOAT, self.timeLabel.height)].width;
    [self.timeLabel setText:self.status.create_at];
    [self.timeLabel sizeToFit];
    self.timeLabel.top  = self.textLabelOfCell.bottom + kTextToTime;

    self.sourceLabel.width = [self getSizeOfString:self.status.source WithFont:self.sourceLabel.font WithSize:CGSizeMake(MAXFLOAT, self.sourceLabel.height)].width;
    [self.sourceLabel setText:self.status.source];
    [self.sourceLabel sizeToFit];
    self.sourceLabel.top = self.timeLabel.top;
    
    self.timeLabel.left = self.sourceLabel.right + 5;

    NSString *countText = [NSString stringWithFormat:@"赞:%d|转发:%d|评论:%d",status.attitudes_count,self.status.reposts_count,self.status.comments_count];
    self.countLabel.width = [self getSizeOfString:countText WithFont:self.countLabel.font WithSize:CGSizeMake(MAXFLOAT, self.countLabel.height)].width;
    [self.countLabel setText:countText];
    [self.countLabel sizeToFit];
    self.countLabel.top = self.timeLabel.bottom + 5;
    self.countLabel.left = self.sourceLabel.left;
    
    self.buttonOfCell.right = self.width - 20;
    self.buttonOfCell.top = self.sourceLabel.top;
    
    if (status.retweeted_status)
    {
        if (self.ret_StatusView == nil)
        {
            _ret_StatusView = [[RetweededStatusView alloc] initWithFrame:CGRectMake(0, self.countLabel.bottom + kCountToRetView, self.width, [RetweededStatusView getHeightOfRetweededStatusView:status.retweeted_status])];
            [self.ret_StatusView setDatasOfCell:status.retweeted_status];
            [self addSubview:_ret_StatusView];
        }
        else
        {
            self.ret_StatusView.hidden = NO;
            self.ret_StatusView.height = [RetweededStatusView getHeightOfRetweededStatusView:status.retweeted_status];
            self.ret_StatusView.top = self.countLabel.bottom + kCountToRetView;
            [self.ret_StatusView setDatasOfCell:status.retweeted_status];
        }
    }
    
    else if (self.ret_StatusView != nil)
    {
        self.ret_StatusView.hidden = YES;
    }
}

- (CGSize )getSizeOfString:(NSString *)string
                  WithFont:(UIFont *)font
                  WithSize:(CGSize )sizeOfLabel
{
    CGSize size = [string boundingRectWithSize:sizeOfLabel options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return size;
}

+ (CGFloat)getHeightOfCell:(Status *)status
{
    CGFloat height = 0;
    height = height + 5 + [status.text boundingRectWithSize:CGSizeMake(kTextLabelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kTextFont} context:nil].size.height;//text.height
    height = height + kTextToTime + kTextHeight;//time.height and source
    height = height + kTextHeight + 5;
    
    if (status.bmiddlePics.count > 0)
    {
        height = height + [StatusPicsView getHeightOfStatusPics] + kImageViewsToText;        //imageViewsHeight
    }
    
    else if(status.retweeted_status)
    {
        height = height + [RetweededStatusView getHeightOfRetweededStatusView:status.retweeted_status] + kCountToRetView;
    }
    height = height + 5;//to_bottom

    return height;
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//    _headerMaskView.highlighted = self.isHighlighted || self.isSelected;
//    _bgView.backgroundColor = _headerMaskView.highlighted ? RGB(208, 208, 208) : [UIColor whiteColor];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    _headerMaskView.highlighted = self.isHighlighted || self.isSelected;
//    _bgView.backgroundColor = _headerMaskView.highlighted ? RGB(208, 208, 208) : [UIColor whiteColor];
//}

@end
