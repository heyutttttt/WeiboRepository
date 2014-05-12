//
//  DetailViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-4-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "DetailViewController.h"
#import "MessagesHeaderView.h"
#import "MessagesCell.h"
#import "StatusTableViewController.h"

#import "UIView+Screenshot.h"

#define kHeaderViewHeight 40

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIImageView *bgView;
@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) UITableView *messagesView;

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) MessagesHeaderView *headerView;

@end

@implementation DetailViewController

- (id)initWithImage:(UIImage *)image WithStatus:(Status *)status
{
    self = [super init];
    if (self)
    {
        _bgView = [[UIImageView alloc] initWithImage:image];
        [_bgView setFrame:self.view.bounds];
        
        _status = [status retain];
    }
    return self;
}

- (void)dealloc
{
    [_bgView release];
    [_status release];
    [_messagesView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.bgView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOfTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showMessageVCWithAnimation];
}

- (void)showMessageVC
{
    _messagesView = [[UITableView alloc] initWithFrame:CGRectMake(150, (SCREEN_HEIGH - 20)/2.0, 20 , 20) style:UITableViewStylePlain];
    _messagesView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messagesView.delegate = self;
    _messagesView.dataSource = self;
    
    [self.view addSubview:_messagesView];
    
    [UIView beginAnimations:@"animation" context:NULL];
    
    [UIView setAnimationDuration:0.3f];
    
    [UIView setAnimationDelay:0.2f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.messagesView.frame = CGRectMake((SCREEN_WIDTH - self.bgView.width*3/4.0)/2.0, (SCREEN_HEIGH - self.bgView.height*3/4.0)/2.0, self.bgView.width*3/4.0, self.bgView.height*3/4.0);
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(refreshData)];
    
    [UIView commitAnimations];
    
}

- (void)showMessageVCWithAnimation
{
    [self.bgView setImage:[self.bgView convertViewToBlurryImageWithBlur:0.08f]];
    
    [UIView beginAnimations:@"ShowMessageVC_Animation" context:NULL];
    
    [UIView setAnimationDuration:0.3f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.bgView.transform = CGAffineTransformMakeScale(15/16.0, 15/16.0);
    
    [UIView commitAnimations];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma RefreshData

- (void)refreshData
{
    NSLog(@"%@",NSStringFromClass([UITableView class]));
}

#pragma UITapGestureRecognizer

- (void)handleOfTapGesture:(UITapGestureRecognizer *)recognizer
{
    [((StatusTableViewController *)[self presentingViewController]).delegate setTabBarHidden:NO];
    [((StatusTableViewController *)[self presentingViewController]).delegate setNavigationBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma UITableViewDelegate&DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.data count];
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL = @"CELL";
    
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    
    if (!cell)
    {
        cell = [[MessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL WithSize:CGSizeMake(self.messagesView.width, 100)];
    }
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headerView == nil)
    {
        _headerView = [[MessagesHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.messagesView.width, kHeaderViewHeight)];
    }
    
    return self.headerView;
}

@end
