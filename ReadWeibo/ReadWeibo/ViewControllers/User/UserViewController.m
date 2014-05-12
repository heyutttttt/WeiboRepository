//
//  UserViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-6.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import "AccountManager.h"
#import "PersonalView.h"
#import "Status.h"
#import "UIImageView+WebCache.h"

#import "CollectionViewController.h"
#import "PersonalStatusViewController.h"
#import "ListViewController.h"
#import "MessagesViewController.h"

#define kTitleViewWidth 50
#define kTitleViewHeight 30

#define kPersonalViewHeight 160
#define kLoginVCModal @"kLoginVCModal"
#define kGetPhotos @"kGetPhotos"
#define kGetMorePhotos @"kGetMorePhotos"

#define kItemSize (SCREEN_WIDTH-kInsetLeft*3)/2.0
#define kInsetTop 15
#define kInsetBottom 15
#define kInsetLeft 15
#define kInsetRight 15

#define kPhoto @"PHOTO"
#define kTime @"TIME"

@interface PhotoVieCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, retain) UILabel *timeLabel;


@end

@implementation PhotoVieCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _photoView.bottom + 5, self.width, 20)];
        [_timeLabel setTextColor:RGB(46,134,189)];
        [_timeLabel setFont:[UIFont systemFontOfSize:15]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_timeLabel];
        
    }
    return self;
}

- (void)dealloc
{
    [_photoView release];
    [_timeLabel release];
    
    [super dealloc];
}

@end

@interface UserViewController () <PersonalViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UILabel *nameLabelOfTitleView;
@property (nonatomic, retain) PersonalView *personalView;

@property (nonatomic, retain) UICollectionView *photosView;
@property (nonatomic, retain) NSMutableArray *photoData;
@property (nonatomic, retain) NSString *maxID_Photo;

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.navigationController.navigationBar setTranslucent:NO];
        
        AccountManager *account = [AccountManager sharedInstance];
        if ([account isLogin])
        {
            [account updateUser:^{
                [self updateUser];
            }];
        }
    }
    return self;
}

- (void)dealloc
{
    [_user release];
    [_nameLabelOfTitleView release];
    [_personalView release];
    [_photosView release];
    [_photoData release];
    [_maxID_Photo release];
    
    [super dealloc];
}

- (void)updateUser
{
    self.user = [AccountManager sharedInstance].user;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nameLabelOfTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTitleViewWidth, kTitleViewHeight)];
    [_nameLabelOfTitleView setText:self.user.name];
    [_nameLabelOfTitleView setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = _nameLabelOfTitleView;
    
    UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    flowLayout.itemSize=CGSizeMake(kItemSize,kItemSize);
    flowLayout.sectionInset = UIEdgeInsetsMake(kInsetTop,kInsetLeft,kInsetBottom,kInsetRight);
    //        flowLayout.minimumInteritemSpacing = 5;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _photosView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _photosView.height -= 49;
    _photosView.delegate = self;
    _photosView.dataSource = self;
    [_photosView setBackgroundColor:[UIColor whiteColor]];
    _photosView.contentInset = UIEdgeInsetsMake(kPersonalViewHeight, 0, 0, 0);
    [_photosView registerClass:[PhotoVieCell class] forCellWithReuseIdentifier:@"CELL"];
    [self.view addSubview:_photosView];
    
    _personalView = [[PersonalView alloc] initWithUser:self.user WithFrame:CGRectMake(0, -kPersonalViewHeight , SCREEN_WIDTH, kPersonalViewHeight)];
    _personalView.delegate = self;
    [_personalView updateData:_user];
    [self.photosView addSubview:_personalView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(methodForLogOut)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    [self refreshPhotoData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshCollectionData
{
    AccountManager *account = [AccountManager sharedInstance];
    NSString *urlStr = @"https://api.weibo.com/2/statuses/user_timeline.json";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"feature", nil];
    
    [WBHttpRequest requestWithAccessToken:account.token url:urlStr httpMethod:@"GET" params:params delegate:self withTag:kGetPhotos];

}

#pragma LogOut

- (void)methodForLogOut
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        AccountManager *account = [AccountManager sharedInstance];
        [account logout:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginVCModal object:nil];
        }];
    }
}

#pragma PhotoData_Method

- (void)refreshPhotoData
{
    AccountManager *account = [AccountManager sharedInstance];
    
    NSString *urlStr = @"https://api.weibo.com/2/statuses/user_timeline.json";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"feature", nil];
    
    [WBHttpRequest requestWithAccessToken:account.token url:urlStr httpMethod:@"GET" params:params delegate:self withTag:kGetPhotos];
}

- (void)loadMorePhotoData
{
    AccountManager *account = [AccountManager sharedInstance];
    
    NSString *urlStr = @"https://api.weibo.com/2/statuses/user_timeline.json";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"feature",self.maxID_Photo,@"max_id", nil];
    
    [WBHttpRequest requestWithAccessToken:account.token url:urlStr httpMethod:@"GET" params:params delegate:self withTag:kGetMorePhotos];
}

- (void)updatePhotosView:(NSDictionary *)dic
       WithIsLoadingMore:(BOOL)isLoadingMoreData
{
    BOOL shouldReloadData = YES;
    
    if (!isLoadingMoreData)
    {
        if (!self.photoData)
        {
            self.photoData = [NSMutableArray array];
        }
        
        else
        {
            [self.photoData removeAllObjects];
        }
    }
    
    NSArray *statusArray = [dic objectForKey:@"statuses"];
    for (NSDictionary *statusDic in statusArray)
    {
        if (statusDic == [statusArray objectAtIndex:0] && isLoadingMoreData)
        {
            if ([statusArray count] == 1)
            {
                shouldReloadData = NO;
                break;
            }
            
            continue;
        }
        
        Status *status = [Status createWithDic:statusDic];
        
        if (statusDic == [statusArray lastObject])
        {
            if ( self.maxID_Photo != [statusDic objectForKey:@"mid"])
            {
                self.maxID_Photo = [statusDic objectForKey:@"mid"];
                shouldReloadData = YES;
            }
            
            else
            {
                shouldReloadData = NO;
                break;
            }
        }
        
        if (status.bmiddlePics)
        {
            NSString *subStr = [status.create_at substringToIndex:10];
            
            for (NSString *str in status.bmiddlePics)
            {
                NSDictionary *dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:str,kPhoto,subStr,kTime,nil] autorelease];
                [self.photoData addObject:dictionary];
            }
        }
    }
    
    if (shouldReloadData)
    {
        [self.photosView reloadData];
    }
}

#pragma WBHttpRequestDelegate

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
    if([request.tag isEqualToString:kGetPhotos])
    {
        [self updatePhotosView:dictionary WithIsLoadingMore:NO];
    }
    
    else if([request.tag isEqualToString:kGetMorePhotos])
    {
        [self updatePhotosView:dictionary WithIsLoadingMore:YES];
    }
}

#pragma PersonalViewDelegate

- (void)methodForPhotoButton
{
    [self refreshPhotoData];
}

- (void)methodForCollectionButton
{
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    [collectionVC.view setFrame:self.view.bounds];
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
    [collectionVC release];
}

- (void)methodForMessageButton
{
    MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
    [messagesVC.view setFrame:self.view.bounds];
    messagesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messagesVC animated:YES];
    [messagesVC release];
}

- (void)methodForStatusCountButton
{
    PersonalStatusViewController *psVC = [[PersonalStatusViewController alloc] init];
    [psVC.view setFrame:self.view.bounds];
    psVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:psVC animated:YES];
    [psVC release];
}

- (void)methodForFollowersCountButton
{
    ListViewController *listVC = [[ListViewController alloc] initWithUrlStr:kURLStrOfFollowers];
    [listVC.view setFrame:self.view.bounds];
    listVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}

- (void)methodForFollowingsCountButton
{
    ListViewController *listVC = [[ListViewController alloc] initWithUrlStr:kURLStrOfFriends];
    [listVC.view setFrame:self.view.bounds];
    listVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}

#pragma UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ([self.photoData count] + 1)/2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL = @"CELL";
    PhotoVieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL forIndexPath:indexPath];
    [cell.photoView setImage:nil];
    [cell.timeLabel setText:nil];
    
    if (indexPath.section*2 + indexPath.item < [self.photoData count])
    {
        [cell.photoView setImageWithURL:[NSURL URLWithString:[self.photoData[indexPath.section*2 + indexPath.item] objectForKey:kPhoto]]];
        [cell.timeLabel setText:[self.photoData[indexPath.section*2 + indexPath.item] objectForKey:kTime]];
    }
    return cell;
}

@end
