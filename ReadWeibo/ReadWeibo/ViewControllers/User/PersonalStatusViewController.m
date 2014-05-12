//
//  PersonalStatusViewController.m
//  ReadWeibo
//
//  Created by ryan on 14-3-30.
//  Copyright (c) 2014年 ryan. All rights reserved.
//

#import "PersonalStatusViewController.h"
#import "StatusTableViewController.h"

@interface PersonalStatusViewController ()

@property (nonatomic, retain) StatusTableViewController *statusTVC;

@end

@implementation PersonalStatusViewController

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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _statusTVC = [[StatusTableViewController alloc] initWithUrlStr:kURLStrOfPersonalStatus];
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
