//
//  MessagesCell.h
//  ReadWeibo
//
//  Created by ryan on 14-4-9.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesCell : UITableViewCell

@property (nonatomic, retain) UIView *cellView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIImageView *headView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *textLabelOnCell;
@property (nonatomic, retain) UIImageView *underLineView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithSize:(CGSize)size;


@end
