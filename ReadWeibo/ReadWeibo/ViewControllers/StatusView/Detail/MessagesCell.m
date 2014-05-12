

#import "MessagesCell.h"
#define kTextLabelWidth (_size.width - 110)
#define kbuttonOfReplyHeight 15

#define kTextToBottom 10
#define kNameLabelHeight 15
#define kNameLabelTop 10

@interface MessagesCell ()

@property (nonatomic, assign) CGSize size;

@end

@implementation MessagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithSize:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.size = size;
        
        _cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width , size.height)];
        
        self.underLineView = [self createUnderlineView];
        self.underLineView.bottom = self.height;
        self.underLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.cellView addSubview:self.underLineView];
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headView.clipsToBounds = YES;
        [self.cellView addSubview:self.headView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.right + 10, kNameLabelTop, 0, kNameLabelHeight)];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [self.cellView addSubview:self.nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headView.top, 0, 0)];
        _timeLabel.right = self.cellView.width - 10;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = [UIColor grayColor];
        [self.cellView addSubview:self.timeLabel];
        
        _textLabelOnCell = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 2, kTextLabelWidth, 0)];
        _textLabelOnCell.font = [UIFont systemFontOfSize:15];
        _textLabelOnCell.numberOfLines = 0;
        _textLabelOnCell.lineBreakMode = NSLineBreakByClipping;
        [_textLabelOnCell setTextColor:[UIColor colorWithRed:41/255.0 green:36/255.0 blue:33/255.0 alpha:1.0]];
        [self.cellView addSubview:self.textLabelOnCell];
        
        [self addSubview:self.cellView];
    }
    return self;
}

- (void)dealloc
{
    [_cellView release];
    [_headView release];
    [_textLabelOnCell release];
    [_timeLabel release];
    [_nameLabel release];
    [_underLineView release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UIImageView *)createUnderlineView
{
    UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 2)] autorelease];
    UIGraphicsBeginImageContext(view.frame.size);
    [view.image drawInRect:CGRectMake(0, 0, view.width, view.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0f);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 46/255.0, 134/255.0, 189/255.0, 1.0);
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 60, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), view.width - 10, 0);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    view.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return view;
}



@end
