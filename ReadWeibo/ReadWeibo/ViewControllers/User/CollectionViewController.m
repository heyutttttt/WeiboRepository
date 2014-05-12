//
//  CollectionViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-30.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "CollectionViewController.h"
#import "StatusTableViewController.h"

@interface CollectionViewController ()

@property (nonatomic, retain) StatusTableViewController *statusTVC;
@property (nonatomic, retain) UIView *overLay;

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_statusTVC release];
    [_overLay release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _overLay = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    [_overLay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    _overLay.alpha = 0;
    [self.navigationController.navigationBar addSubview:_overLay];
    
    _statusTVC = [[StatusTableViewController alloc] initWithUrlStr:kURLStrOfCollection];
//    _statusTVC.delegate = self;
    [_statusTVC.view setFrame:self.view.bounds];
    [self.view addSubview:_statusTVC.view];
    
    [_statusTVC refreshDataWithDelayDuration:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
