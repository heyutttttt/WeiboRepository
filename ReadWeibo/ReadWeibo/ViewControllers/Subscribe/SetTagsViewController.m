//
//  SetTagsViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-21.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "SetTagsViewController.h"
#import "AddTagsView.h"
#import "Tag.h"
#import "ModTagsView.h"

#define kTagsData @"kTagsData"

@interface SetTagsViewController ()

@property (nonatomic, retain) NSMutableDictionary *selectedDic;

@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) UIButton *modButton;

@property (nonatomic, retain) NSArray *tagsArray;

@property (nonatomic, retain) AddTagsView *addView;
@property (nonatomic, retain) ModTagsView *modView;

@property (nonatomic, assign) BOOL isModViewOn;

@end

@implementation SetTagsViewController

- (id)initwithDic:(NSMutableDictionary *)dic
{
    self = [super init];
    if (self)
    {
        if (_selectedDic != dic)
        {
            self.selectedDic = dic;
        }
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kTagsData];
        
        if (data != nil)
        {
            self.tagsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
        else
        {
            self.tagsArray = [NSArray arrayWithObjects:[Tag TagWithName:@"sports"],[Tag TagWithName:@"fashion"],[Tag TagWithName:@"ent"],[Tag TagWithName:@"music"],[Tag TagWithName:@"art"],[Tag TagWithName:@"cartoon"],[Tag TagWithName:@"games"],[Tag TagWithName:@"trip"],[Tag TagWithName:@"food"],[Tag TagWithName:@"health"],[Tag TagWithName:@"literature"],[Tag TagWithName:@"stock"],[Tag TagWithName:@"business"],[Tag TagWithName:@"tech"],[Tag TagWithName:@"house"],[Tag TagWithName:@"fate"],[Tag TagWithName:@"govern"],[Tag TagWithName:@"medium"], nil];
        }
        
    }
    return self;
}

- (void)dealloc
{
    [_addView release];
    [_modView release];
    
    [_modButton release];
    [_addButton release];
    [_tagsArray release];
    [_selectedDic release];
    
    [super dealloc];
}

- (void)saveData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tagsArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kTagsData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, (SCREEN_WIDTH-30)/2, 30)];
    [_modButton setTitle:@"已选标签" forState:UIControlStateNormal];
    [_modButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:18]];
    [_modButton setBackgroundColor:RGB(46,134,189)];
    [_modButton addTarget:self action:@selector(methodForModButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_modButton];
    
    _modView = [[ModTagsView alloc] initWithFrame:CGRectMake(0, _modButton.bottom, SCREEN_WIDTH, SCREEN_HEIGH - _modButton.bottom) WithSelectedTags:self.selectedDic];
    [self.view addSubview:_modView];
    self.isModViewOn = YES;
    
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.modButton.right, self.modButton.top, self.modButton.width, self.modButton.height)];
    [_addButton setTitle:@"添加标签" forState:UIControlStateNormal];
    [_addButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:18]];
    [_addButton setBackgroundColor:[UIColor grayColor]];
    [_addButton addTarget:self action:@selector(methodForAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button setTitle:@"<" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [button addTarget:self action:@selector(methodForBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}

- (void)methodForBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //save data
    [self saveData];
    [self.delegate savaSelectedDicData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)methodForModButton
{
    if (!self.isModViewOn)
    {
        [_modButton setBackgroundColor:RGB(46,134,189)];
        [_addButton setBackgroundColor:[UIColor grayColor]];
        
        [self switchViewOfModBetweenAdd:YES];
    }
}

- (void)methodForAddButton
{
    if (self.isModViewOn)
    {
        [_addButton setBackgroundColor:RGB(46,134,189)];
        [_modButton setBackgroundColor:[UIColor grayColor]];
        
        [self switchViewOfModBetweenAdd:NO];
    }
}

- (void)switchViewOfModBetweenAdd:(BOOL)shouldModViewOn
{
    if (shouldModViewOn)
    {
        _modView = [[ModTagsView alloc] initWithFrame:CGRectMake(0, _modButton.bottom, SCREEN_WIDTH, SCREEN_HEIGH - _modButton.bottom) WithSelectedTags:self.selectedDic];
        [self.view addSubview:_modView];
        
        if (_addView != nil)
        {
            _addView.shouldRemoveFromSuperView = YES;
            [_addView removeFromSuperview];
            _addView = nil;
        }
        
        self.isModViewOn = YES;
    }
    
    else
    {
        _addView = [[AddTagsView alloc] initWithFrame:CGRectMake(0, _addButton.bottom, SCREEN_WIDTH, SCREEN_HEIGH - _addButton.bottom) WithTags:self.tagsArray WithDic:self.selectedDic];
        [self.view addSubview:_addView];
        
        if (_modView != nil)
        {
            [_modView removeFromSuperview];
            _modView = nil;
        }
        
        self.isModViewOn = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
