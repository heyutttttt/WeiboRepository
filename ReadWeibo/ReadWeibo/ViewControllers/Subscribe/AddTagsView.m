//
//  AddTagsView.m
//  ReadWeibo
//
//  Created by ryan on 14-3-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "AddTagsView.h"
#import "Tag.h"

#define kCustomizedTagNames @"kCustomizedTagNames"
#define kSystemTagNames @"kSystemTagNames"

#define kCountOfTags (int)[self.tagsArray count]

@interface ButtonForAddView : UIButton

@property (nonatomic, assign) NSInteger indexOfTagsArray;

@end

@implementation ButtonForAddView

@end
//////////////////

@interface AddTagsView ()

@property (nonatomic, retain) NSArray *tagsArray;

@property (nonatomic, retain) NSMutableDictionary *selectedDic;

@property (nonatomic, retain) NSMutableArray *buttonsArray;

@end

@implementation AddTagsView

- (id)initWithFrame:(CGRect)frame WithTags:(NSArray *)array WithDic:(NSMutableDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.shouldRemoveFromSuperView = NO;
        
        self.tagsArray = array;
        
        self.selectedDic = dic;
        
        self.buttonsArray = [NSMutableArray arrayWithCapacity:10];
        
        [self setTitleOnButtons];
        
    }
    return self;
}

- (void)dealloc
{
    [_tagsArray release];
    [_selectedDic release];
    [_buttonsArray release];
    
    [super dealloc];
}

- (void)methodForButton:(ButtonForAddView *)button
{
    NSInteger indexOfTagsArray = button.indexOfTagsArray;
    Tag *tag = [self.tagsArray objectAtIndex:indexOfTagsArray];
    tag.isSelected = YES;
    tag.isOnAddView = NO;
    
    NSMutableArray *array = [self.selectedDic objectForKey:kCustomizedTagNames];
    [array addObject:tag];
    
    NSInteger index = 0;
    while (index < self.tagsArray.count)
    {
//        NSInteger index = [self getRandomNumber:0 to:(kCountOfTags - 1)];
        tag = [self.tagsArray objectAtIndex:index];
        
        if (tag.isSelected == NO && tag.isOnAddView == NO)
        {
            [button setTitle:tag.name forState:UIControlStateNormal];
            button.indexOfTagsArray = index;
            tag.isOnAddView = YES;
            break;
        }
        index++;
    }
    
    if (index == self.tagsArray.count)
    {
        [self.buttonsArray removeObject:button];
        button.hidden = YES;
        
        for (int i = indexOfTagsArray; i < self.buttonsArray.count; i++)
        {
            ButtonForAddView *button = [self.buttonsArray objectAtIndex:i];
            NSInteger tag =  button.tag--;
            if ((tag+1)%2 == 0)
            {
                button.left = 170;
                button.top = (tag-1)/2*(30+5) + 30;
            }
            
            else
            {
                button.left = 25;
                button.top = (tag/2)*(30+5) + 30;
            }

        }
    }
}


- (void)setTitleOnButtons
{
    NSInteger count = 0;
    NSInteger index = 0;
    while (index < [_tagsArray count] && count < 10)
    {
        Tag *tag = _tagsArray[index];
        
        if (tag.isSelected == NO && tag.isOnAddView == NO)
        {
            ButtonForAddView *button = [self setButtonOnView:count];
            button.indexOfTagsArray = index;
            [button setTitle:tag.name forState:UIControlStateNormal];
            [self addSubview:button];
            
            tag.isOnAddView = YES;
            count++;
            
            [self.buttonsArray addObject:button];
        }
        
        index++;
    }
}

//-(int)getRandomNumber:(int)fromNumber to:(int)toNumber
//{
//    return (int)(fromNumber + (arc4random() % (toNumber - fromNumber + 1)));
//}

- (ButtonForAddView *)setButtonOnView:(NSInteger)index
{
    ButtonForAddView *button = [ButtonForAddView buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 125, 30)];
    [button setBackgroundColor:RGB(46,134,189)];
    button.tag = index;
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button addTarget:self action:@selector(methodForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125 - 30, 0, 30, 30)];
    [label setText:@"+"];
    [label setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:23.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [button addSubview:label];
    [label release];
    
    if ((index+1)%2 == 0)
    {
        button.left = 170;
        button.top = (index-1)/2*(30+5) + 30;
    }
    
    else
    {
        button.left = 25;
        button.top = (index/2)*(30+5) + 30;
    }

    return button;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (self.shouldRemoveFromSuperView)
    {
        for (Tag *tag in self.tagsArray)
        {
            if (tag.isOnAddView)
            {
                tag.isOnAddView = NO;
            }
        }
    }
}

@end
