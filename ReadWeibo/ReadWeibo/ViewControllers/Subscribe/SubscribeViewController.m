//
//  SubscribeViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SetTagsViewController.h"

#define kStyleDic @"kStyleDic"
#define kCustomizedTagNames @"kCustomizedTagNames"
#define kSystemTagNames @"kSystemTagNames"

@interface SubscribeViewController () <SetTagsVCDelegate>

@property (nonatomic, retain) NSMutableDictionary *selectedDic;

@end

@implementation SubscribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        [label setText:@"订阅"];
        [label setTextColor:[UIColor whiteColor]];
        self.navigationItem.titleView = label;
        [label release];
    }
    return self;
}

- (void)dealloc
{
    [_selectedDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(showSelectTagsView)];
    self.navigationItem.rightBarButtonItem = leftItem;
    [leftItem release];
    
    
    [self readData];
}

- (void)readData
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kStyleDic];
    
    if (data == nil)
    {
        self.selectedDic = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *systemArray = [NSMutableArray array];
        [self.selectedDic setObject:systemArray forKey:kSystemTagNames];
        
        NSMutableArray *customizedArray = [NSMutableArray array];
        [self.selectedDic setObject:customizedArray forKey:kCustomizedTagNames];
        
    }
    
    else
    {
        self.selectedDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.selectedDic];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kStyleDic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showSelectTagsView
{
    SetTagsViewController *vc = [[SetTagsViewController alloc] initwithDic:self.selectedDic];
    [vc.view setFrame:self.view.bounds];
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SetTagsVCDelegate

- (void)savaSelectedDicData
{
    [self saveData];
}

@end
