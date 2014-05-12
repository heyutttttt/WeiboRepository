//
//  HomeViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "StatusTableViewController.h"
#import "AccountManager.h"
#import "StatusCell.h"

#import "StatusCellHeadView.h"
#import "UIView+Screenshot.h"
#import "DetailViewController.h"
#import "Status+Database.h"

#define kLoadingViewWidth 50
#define kLoadingViewHeight 10
#define kLoadingViewBottom -10

#define RefreshDataOfStatus @"RefreshDataOfStatus"
#define LoadMoreDataOfStatus @"LoadMoreDataOfStatus"

#define kStatusCount @"10"
#define kStatusMoreDataCount @"5"

#define kHeadViewHeight 40

#define kNav_BarFinallyTopWhenStateChanage -34

#define kContextOfStatusTableViewController @"kContextOfStatusTableViewController"

#define kLatestData @"kLatestData"


@interface StatusTableViewController ()

@property (nonatomic, retain) NSMutableArray *data;

@property (nonatomic, retain) NSMutableArray *dataOfCellHeight;

@property (nonatomic, retain) NSString *max_id;


@property (nonatomic, assign) BOOL shouldRefreshData;
@property (nonatomic, assign) BOOL isRefreshingData;

@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, assign) NSInteger pageOfCollection;
@property (nonatomic, assign) BOOL isCollectionUrlStr;
@property (nonatomic, assign) BOOL isStatusUrlStr;
@property (nonatomic, assign) BOOL isPersonalStatusUrlStr;

@property (nonatomic, retain) NSMutableArray *latestData;

@end

@implementation StatusTableViewController

- (id)initWithUrlStr:(NSString *)urlStr
{
    self = [super init];
    if (self)
    {
        self.urlStr = urlStr;
        
        NSMutableArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:kLatestData];
        
        if (array)
        {
            self.latestData = array;
        }
        
        else
        {
            self.latestData = [NSMutableArray array];
        }
    }
    return self;
}

- (void)dealloc
{
    [_loadingView removeObserver:self forKeyPath:@"isEndedAnimating"];
    
    [_panGestureRecognizer release];
    [_tableView release];
    [_data release];
    [_dataOfCellHeight release];
    [_loadingView release];
    [_urlStr release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isNavHidden = NO;
    
    _isCollectionUrlStr = [self.urlStr isEqualToString:kURLStrOfCollection];
    _isStatusUrlStr = [self.urlStr isEqualToString:kURLStrOfStatus];
    _isPersonalStatusUrlStr = [self.urlStr isEqualToString:kURLStrOfPersonalStatus];
    _pageOfCollection = 1;
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleForGesture:)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setScrollsToTop:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, kLoadingViewWidth, kLoadingViewHeight)];
    _loadingView.centerX = SCREEN_WIDTH/2.0;
    _loadingView.bottom = kLoadingViewBottom;
    [self.tableView addSubview:_loadingView];
    
    [self.loadingView addObserver:self forKeyPath:@"isEndedAnimating"
                          options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                          context:kContextOfStatusTableViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isEndedAnimating"] && [((NSString *)context) isEqualToString:kContextOfStatusTableViewController] )
    {
        if ( ![[change objectForKey:@"old"] boolValue]  &&
             [[change objectForKey:@"new"] boolValue] )
        {
            if (self.tableView.contentOffset.y <= -94)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
                    
                } completion:^(BOOL finished) {

                    self.isRefreshingData = NO;
                    self.shouldRefreshData = NO;
                    [self.tableView reloadData];
                }];
            }
            
            else
            {
                [self.delegate showNavigationBar];
                
                self.isRefreshingData = NO;
                self.shouldRefreshData = NO;
                [self.tableView reloadData];
            }
        }
    }
}

#pragma RefreshData_Delay

- (void)refreshDataWithDelayDuration:(float)duration
{
//    if (self.data == nil)
//    {
//        self.data = [NSMutableArray array];
//    }
//
//    else
//    {
//        [self.data removeAllObjects];
//    }
//
//    for (NSString *idString in self.latestData)
//    {
//        long long statusID = [idString longLongValue];
//        
//        [self.data addObject:[Status getStatusByID:statusID]];
//    }
//
//    [self.tableView reloadData];

    [self performSelector:@selector(refreshData) withObject:nil afterDelay:duration];
    
}

#pragma Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleForGesture:(UIPanGestureRecognizer *)recoginzer
{
    [self.delegate handleOfPanGesture:recoginzer];
}

#pragma RefreshData&LoadMoreData

- (void)loadMoreData
{
    if (!self.isRefreshingData)
    {
        self.isRefreshingData = YES;
        
        AccountManager *account = [AccountManager sharedInstance];
        NSDictionary *params = nil;
        
        if (self.isCollectionUrlStr)
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:kStatusCount,@"count",[NSString stringWithFormat:@"%d",self.pageOfCollection],@"page", nil];
        }
        
        if (self.isStatusUrlStr || self.isPersonalStatusUrlStr)
        {
            params = [NSDictionary dictionaryWithObjectsAndKeys:kStatusMoreDataCount,@"count",self.max_id,@"max_id", nil];
        }
        
        [WBHttpRequest requestWithAccessToken:account.token url:self.urlStr httpMethod:@"GET" params:params delegate:self withTag:LoadMoreDataOfStatus];

    }
}

- (void)refreshData
{
    if (!self.isRefreshingData)
    {
        self.isRefreshingData = YES;
        
        AccountManager *account = [AccountManager sharedInstance];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:kStatusCount,@"count", nil];
        [WBHttpRequest requestWithAccessToken:account.token url:self.urlStr httpMethod:@"GET" params:params delegate:self withTag:RefreshDataOfStatus];
        
        [self enableRefreshAnimation:YES];
    }
}


- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (self.data == nil)
    {
        self.data = [NSMutableArray array];
    }
    
    if (self.dataOfCellHeight == nil)
    {
        self.dataOfCellHeight = [NSMutableArray array];
    }
    
    NSArray *array_Status = nil;
    
    if (self.isCollectionUrlStr)
    {
        NSArray *array = [dictionary objectForKey:@"favorites"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (int i=0; i<array.count; i++)
        {
            [mutableArray addObject:[array[i] objectForKey:@"status"]];
        }
        array_Status = [mutableArray retain];
    }
    
    if (self.isStatusUrlStr || self.isPersonalStatusUrlStr)
    {
         array_Status = [dictionary objectForKey:@"statuses"];
    }
    
    if ([request.tag isEqualToString:RefreshDataOfStatus])
    {
        [self.dataOfCellHeight removeAllObjects];
        [self.data removeAllObjects];
        
//        [self.latestData removeAllObjects];
        
        for (NSDictionary *dic_Status in array_Status)
        {
            if (dic_Status == [array_Status lastObject] && (self.isStatusUrlStr || self.isPersonalStatusUrlStr))
            {
                self.max_id = [dic_Status objectForKey:@"mid"];
            }
            
            else if (self.isCollectionUrlStr)
            {
                self.pageOfCollection = 2;
            }
            
            Status *status = [Status createWithDic:dic_Status];
            [self.data addObject:status];
            
//            [self.latestData addObject:[NSString stringWithFormat:@"%lld",status.statusId]];
        }
        
//        [[NSUserDefaults standardUserDefaults] setObject:self.latestData forKey:kLatestData];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [Status saveArray:self.data];
        [self enableRefreshAnimation:NO];
        
        //KVO 调[self.tableView reloadData];
    }
    
    if ([request.tag isEqualToString:LoadMoreDataOfStatus])
    {
        if ([array_Status count] == 1 && self.isStatusUrlStr)
        {
            //最后一个
        }
        
        else
        {
            for (int i=0; i<array_Status.count; i++)
            {
                if (i == array_Status.count - 1 && (self.isStatusUrlStr || self.isPersonalStatusUrlStr))
                {
                    self.max_id = [array_Status[i] objectForKey:@"mid"];
                }
                
                if (i != 0 || self.isCollectionUrlStr)
                {
                    Status *status = [Status createWithDic:array_Status[i]];
                    [self.data addObject:status];
                }
            }
            
            if (self.isCollectionUrlStr)
            {
                self.pageOfCollection++;
            }
            
            [self.tableView reloadData];
            self.isRefreshingData = NO;
        }
    }

}

#pragma ScrollView

- (void)enableRefreshAnimation:(BOOL)enable
{
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    
    if (enable)
    {
        contentInset = UIEdgeInsetsMake(64.0 + kLoadingViewHeight + 2*(-kLoadingViewBottom), 0, 0, 0);
    }
//    else
//    {
//        contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    }
    
    if (enable)
    {
        [self.loadingView startAnimation];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            if ( self.tableView.contentOffset.y >= -64)
            {
                self.tableView.contentOffset = CGPointMake(0, -94);
                self.tableView.contentInset = contentInset;
            }
            
            else
            {
                self.tableView.contentInset = contentInset;
            }
        }];
    }
    else
    {
        [self.loadingView stopAnimation];
    }
}

- (void)setAnimationOfLoadingViewWithNormal:(BOOL)isNormal
                                  WithIndex:(NSInteger)index
{
    if (isNormal)
    {
        [UIView animateWithDuration:0.5 animations:^{
               [self.loadingView setDotNormalWithIndex:index];
        } completion:^(BOOL finished) {
            self.shouldRefreshData = NO;
        }];
    }
    
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [self.loadingView setDotHightLightedWithIndex:index];
        } completion:^(BOOL finished) {
            if (index == 2)
            {
                self.shouldRefreshData = YES;
            }
            else
            {
                self.shouldRefreshData = NO;
            }
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"cur_f:%f",scrollView.contentOffset.y);
//    NSLog(@"pre:%f",scrollView.contentOffset.y);
    
    static float previousOffSet_y = -64.0;
    BOOL directDown;
    
    if (previousOffSet_y > scrollView.contentOffset.y)
    {
        directDown = YES;
    }
    
    else
    {
        directDown = NO;
    }
    
    previousOffSet_y = scrollView.contentOffset.y;
    
    if (!self.isRefreshingData)
    {
        if (scrollView.contentOffset.y <= -110 && directDown )
        {
            [self setAnimationOfLoadingViewWithNormal:NO WithIndex:0];
        }
        
        if(scrollView.contentOffset.y <= -115 && directDown )
        {
            [self setAnimationOfLoadingViewWithNormal:NO WithIndex:1];
        }
        
        if(scrollView.contentOffset.y <= -120 && directDown )
        {
            [self setAnimationOfLoadingViewWithNormal:NO WithIndex:2];
        }
        //
        if(scrollView.contentOffset.y >= -120 && !directDown )
        {
            [self setAnimationOfLoadingViewWithNormal:YES WithIndex:2];
        }
        
        if(scrollView.contentOffset.y >= -115 && !directDown )
        {
            [self setAnimationOfLoadingViewWithNormal:YES WithIndex:1];
        }
        
        if(scrollView.contentOffset.y >= -110 && !directDown )
        {
            [self setAnimationOfLoadingViewWithNormal:YES WithIndex:0];
        }
        
        if (scrollView.contentOffset.y + scrollView.contentSize.height * 0.2 >= scrollView.contentSize.height)
        {
            [self loadMoreData];
        }

    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.shouldRefreshData)
    {
        [self refreshData];
    }

}

#pragma TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL =@"StatusCell";
    StatusCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if (tableViewCell == nil)
    {
        tableViewCell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
//        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleOfLongGesture:)];
        longRecognizer.minimumPressDuration = 1.5f;
        [tableViewCell addGestureRecognizer:longRecognizer];
        [longRecognizer release];
        
    }
    tableViewCell.status = [self.data objectAtIndex:indexPath.section];
    return tableViewCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataOfCellHeight != nil)
    {
        [self.dataOfCellHeight addObject:[NSNumber numberWithFloat:[StatusCell getHeightOfCell:[self.data objectAtIndex:indexPath.section]]]];
    }
    
    return [StatusCell getHeightOfCell:[self.data objectAtIndex:indexPath.section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StatusCellHeadView *headView = (StatusCellHeadView *)[tableView headerViewForSection:section];
    if (headView == nil)
    {
        headView = [[StatusCellHeadView alloc] initWithFrame:CGRectMake(0, 0, 320, kHeadViewHeight)];
    }
    
    User *user = ((Status *)[self.data objectAtIndex:section]).sender;
    [headView setDatasOnView:user];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeadViewHeight;
}

#pragma UILongPressGestureRecognizer

- (void)handleOfLongGesture:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"begin");
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[recognizer locationInView:self.tableView]];
        
        if (indexPath != nil)
        {
            [[self.tableView cellForRowAtIndexPath:indexPath] setHighlighted:NO];
            
            UIImage *image = [[UIApplication sharedApplication].keyWindow convertViewToImage];
            
            DetailViewController *detailVC = [[DetailViewController alloc] initWithImage:image WithStatus:self.data[indexPath.section]];
            
            [detailVC.view setFrame:self.view.bounds];
            
            [self.delegate setNavigationBarHidden:YES];
            [self.delegate setTabBarHidden:YES];
            
            detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:detailVC animated:NO completion:^{
                
            }];
            
            [detailVC release];
        }
    }
}

@end
