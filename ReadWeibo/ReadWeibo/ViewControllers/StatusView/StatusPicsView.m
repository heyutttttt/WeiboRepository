//
//  StatusPicsView.m
//  ReadWeibo
//
//  Created by ryan on 14-3-8.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "StatusPicsView.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"
#import "PhotoBrowser.h"

#define Cell @"Cell"
#define kViewHeight 300

#define kItemSizeWidth (SCREEN_WIDTH  - kInsetLeft - kInsetRight)
#define kItemSizeHeight (kViewHeight  - kInsetTop - kInsetBottom)

#define kInsetTop 5
#define kInsetBottom 5
#define kInsetLeft 5
#define kInsetRight 5


@interface StatusPicsView () <PhotoBrowserDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSArray* arrayOfPics;

@end

@implementation StatusPicsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        flowLayout.itemSize=CGSizeMake(kItemSizeWidth,kItemSizeHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(kInsetTop,kInsetLeft,kInsetBottom,kInsetRight);
        flowLayout.minimumInteritemSpacing = 5;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, kViewHeight) collectionViewLayout:flowLayout] autorelease];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        [self.collectionView setScrollsToTop:NO];
        
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:Cell];
        
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)dealloc
{
    [_collectionView release];
    [super dealloc];
}

- (void)loadForStatusPics:(NSArray *)arrayOfPics
{
    if (_arrayOfPics == arrayOfPics)
    {
        return;
    }
    
    self.arrayOfPics = arrayOfPics;
    [self.collectionView reloadData];
}

+ (float)getHeightOfStatusPics
{
    return kViewHeight;
}

#pragma UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayOfPics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    
    NSString *urlStr = self.arrayOfPics[indexPath.item];
    [cell.imageView setFrame:CGRectMake(0, 0, kItemSizeWidth,kItemSizeHeight)];
    [cell.imageView setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        if (image.size.height < kViewHeight)
        {
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
        {
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }

    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PhotoBrowser *browser = [[PhotoBrowser alloc] initWithBigImageInfos:self.arrayOfPics smallImageInfos:self.arrayOfPics imageIndex:indexPath.item delegate:self];
    [browser show];
    [browser release];
}

- (UIImageView*)photoBrowser:(PhotoBrowser *)browser animationImageViewAtIndex:(NSInteger)imageIndex
{
    CollectionViewCell* cell = (CollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:imageIndex inSection:0]];
    return cell.imageView;
}

- (void)photoBrowser:(PhotoBrowser*)browser didChangeToImageIndex:(NSInteger)imageIndex
{
    NSLog(@"111");
}


@end
