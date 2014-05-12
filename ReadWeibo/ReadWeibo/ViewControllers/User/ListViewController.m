//
//  ListViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-30.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "ListViewController.h"
#import "LoadingView.h"
#import "WeiboSDK.h"
#import "AccountManager.h"
#import "User.h"
#import "UIImageView+WebCache.h"

#define kLoadingViewWidth 50
#define kLoadingViewHeight 10
#define kLoadingViewBottom -10

#define kRequest @"kRequest"
#define kMoreRequest @"kMoreRequest"

#define kPadding 12
#define kAvatarSize 40
#define kLabelSizeWidth 180
#define kLabelSizeHeight 20
#define kButtonSizeWidth 50
#define kButtonSizeHeight 30

@interface TableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *headView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIButton *buttonOfFollow;

@end

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, (self.height - kAvatarSize) / 2, kAvatarSize, kAvatarSize)];
        [self addSubview:_headView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.left + self.headView.width + kPadding, 7, kLabelSizeWidth, kLabelSizeHeight)];
        [_nameLabel setTextColor:RGB(46,134,189)];
        [self addSubview:self.nameLabel];
        
        self.buttonOfFollow = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buttonOfFollow.left = self.nameLabel.width + self.nameLabel.left + kPadding;
        self.buttonOfFollow.top = (self.height - kButtonSizeHeight)/2;
        self.buttonOfFollow.width = kButtonSizeWidth;
        self.buttonOfFollow.height = kButtonSizeHeight;
        [self.buttonOfFollow setBackgroundColor:RGB(46,134,189)];
        self.buttonOfFollow.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.buttonOfFollow];
    }

    return self;
}

- (void)dealloc
{
    [_headView release];
    [_nameLabel release];
    [_buttonOfFollow release];
    
    [super dealloc];
}

- (void)setData:(User *)user
{
    [self.headView setImageWithURL:[NSURL URLWithString:user.avatar_large]];
    [self.nameLabel setText:user.screen_name];
    
    if (user.following)
    {
        [self.buttonOfFollow setTitle:@"已关注" forState:UIControlStateNormal];
    }
    
    else
    {
        [self.buttonOfFollow setTitle:@"关注" forState:UIControlStateNormal];
    }
}

@end

@interface ListViewController () <UITableViewDataSource,UITableViewDelegate,WBHttpRequestDelegate>

@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, retain) NSMutableArray *data;

@property (nonatomic, assign) BOOL isRefreshingData;
@property (nonatomic, assign) BOOL shouldRefreshData;
@property (nonatomic, retain) NSString *next_cursor;

@end

@implementation ListViewController

- (id)initWithUrlStr:(NSString *)urlStr
{
    self = [super init];
    if (self)
    {
        self.urlStr = urlStr;
    }
    return self;
}

- (void)dealloc
{
    [_loadingView removeObserver:self forKeyPath:@"isEndedAnimating"];
    
    [_urlStr release];
    [_tableView release];
    [_data release];
    [_next_cursor release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                          context:NULL];
    
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isEndedAnimating"])
    {
        if ( ![[change objectForKey:@"old"] boolValue]  &&
            [[change objectForKey:@"new"] boolValue] )
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            } completion:^(BOOL finished) {
                
                self.isRefreshingData = NO;
                self.shouldRefreshData = NO;
                [self.tableView reloadData];
            }];
        }
    }
}


#pragma LoadingData

- (void)refreshData
{
    if (!self.isRefreshingData)
    {
        self.isRefreshingData = YES;
        
        AccountManager *account = [AccountManager sharedInstance];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",account.uid],@"uid", nil];
        
        [WBHttpRequest requestWithAccessToken:account.token url:self.urlStr httpMethod:@"GET" params:params delegate:self withTag:kRequest];
        
        [self enableRefreshAnimation:YES];
    }
}

- (void)loadMoreData
{
    if (!self.isRefreshingData)
    {
        self.isRefreshingData = YES;
        
        AccountManager *account = [AccountManager sharedInstance];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",account.uid],@"uid",self.next_cursor,@"cursor", nil];
        
        [WBHttpRequest requestWithAccessToken:account.token url:self.urlStr httpMethod:@"GET" params:params delegate:self withTag:kMoreRequest];
    }
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL = @"CELL";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if (cell == nil)
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else
    {
        [cell.headView setImage:nil];
        [cell.nameLabel setText:nil];
        [cell.buttonOfFollow setTitle:nil forState:UIControlStateNormal];
    }
    
    [cell setData:self.data[indexPath.row]];
    return cell;
}

#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (!self.data)
    {
        self.data = [NSMutableArray array];
    }
    
    if ([request.tag isEqualToString:kRequest])
    {
        //guanzhu
        [self.data removeAllObjects];
        
        NSArray *userArray = [dictionary objectForKey:@"users"];
        
        self.next_cursor = [[dictionary objectForKey:@"next_cursor"] stringValue];
        
        for (NSDictionary *userDic in userArray)
        {
            User *user = [User createWithDic:userDic];
            [self.data addObject:user];
        }
        
        [self enableRefreshAnimation:NO];
    }
    
    if ([request.tag isEqualToString:kMoreRequest])
    {
        if ([self.next_cursor integerValue] != 0)
        {
            NSArray *userArray = [dictionary objectForKey:@"users"];
                
            for (NSDictionary *userDic in userArray)
            {
                User *user = [User createWithDic:userDic];
                [self.data addObject:user];
            }
            
            self.next_cursor = [[dictionary objectForKey:@"next_cursor"] stringValue];
            
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
    else
    {
        contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    
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
        
//        NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
//        NSLog(@"%f",scrollView.contentSize.height);
        
        if (scrollView.contentOffset.y + scrollView.contentSize.height * 0.7 >= scrollView.contentSize.height)
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

@end
