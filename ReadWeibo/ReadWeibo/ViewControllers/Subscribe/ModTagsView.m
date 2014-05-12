//
//  ModTagsView.m
//  ReadWeibo
//
//  Created by ryan on 14-3-22.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "ModTagsView.h"
#import "Tag.h"

#define kCustomizedTagNames @"kCustomizedTagNames"
#define kSystemTagNames @"kSystemTagNames"

@interface ModTagsView ()

@property (nonatomic, retain) NSMutableDictionary *selectedDic;
@property (nonatomic, retain) NSMutableArray *buttonsArray;

@end

@implementation ModTagsView

- (id)initWithFrame:(CGRect)frame WithSelectedTags:(NSMutableDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.selectedDic = dic;
        self.buttonsArray = [NSMutableArray array];
        
        [self setButtonsOnView];
    }
    return self;
}

- (void)dealloc
{
    [_selectedDic release];
    [_buttonsArray release];
    
    [super dealloc];
}

- (void)setButtonsOnView
{
    NSArray *cArray = [self.selectedDic objectForKey:kCustomizedTagNames];
    NSArray *sArray = [self.selectedDic objectForKey:kSystemTagNames];
    NSInteger i = 0;
    
    while (i < ([cArray count] + [sArray count]))
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 125, 30)];
        [button setBackgroundColor:RGB(46,134,189)];
        button.tag = i;
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [button addTarget:self action:@selector(methodForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125 - 30, 0, 30, 30)];
        [label setText:@"X"];
        [label setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:18.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [button addSubview:label];
        [label release];
        
        if ((i+1)%2 == 0)
        {
            button.left = 170;
            button.top = (i-1)/2*(30+5) + 30;
        }
        
        else
        {
            button.left = 25;
            button.top = (i/2)*(30 + 5) + 30;
        }
        
        if (i < [cArray count])
        {
            Tag *tag = cArray[i];
            [button setTitle:tag.name forState:UIControlStateNormal];
        }
        else
        {
            NSInteger index = i - [cArray count];
            Tag *tag = sArray[index];
            [button setTitle:tag.name forState:UIControlStateNormal];
        }
        i++;
        [self.buttonsArray addObject:button];
        [self addSubview:button];
    }
}

- (void)methodForButton:(UIButton *)button
{
    NSMutableArray *cArray = [self.selectedDic objectForKey:kCustomizedTagNames];
    NSMutableArray *sArray = [self.selectedDic objectForKey:kSystemTagNames];
    
    if (button.tag < [cArray count])
    {//customized
        Tag *tag = [cArray objectAtIndex:button.tag];
        tag.isSelected = NO;
        [cArray removeObject:tag];
    }
    
    else
    {
        NSInteger index = button.tag - [cArray count];
        Tag *tag = [sArray objectAtIndex:index];
        tag.isSelected = NO;
        [sArray removeObject:tag];
    }
    
    button.hidden = YES;
    [self.buttonsArray removeObject:button];
    [self adjustSequenceOfButtons:button.tag];
}

- (void)adjustSequenceOfButtons:(NSInteger)beginIndex
{
    for (int i = beginIndex; i < self.buttonsArray.count; i++)
    {
        UIButton *button = self.buttonsArray[i];
        button.tag --;
        
        if ((i+1)%2 == 0)
        {
            button.left = 170;
            button.top = (i-1)*(30+5) + 30;
        }
        
        else
        {
            button.left = 25;
            button.top = i*(30 + 5) + 30;
        }

    }
}



@end
