//
//  LZEventsController.m
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZEventsController.h"

@interface LZEventsController ()

@end

@implementation LZEventsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"新鲜事";
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonTapped:)] autorelease];
//    rightButtonItem.style = UIBarButtonSystemItemRefresh;
//    rightButtonItem.action = @selector(refreshButtonTapped);
//    rightButtonItem.target = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self getFeed];
    // Do any additional setup after loading the view from its nib.
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    NSMutableArray *statusArray = (NSMutableArray *)response.rootObject;
    self.statusList = statusArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFeed{
    if ([[Renren sharedRenren] isSessionValid]) {
        NSMutableDictionary *feedDic = [[[NSMutableDictionary alloc] init] autorelease];
        [feedDic setObject:@"feed.get" forKey:@"method"];
        [feedDic setObject:@"10" forKey:@"type"];
        [feedDic setObject:@"50" forKey:@"count"];
        [feedDic setObject:@"1" forKey:@"page"];
        [[Renren sharedRenren] requestWithParams:feedDic andDelegate:self];
    }
}

- (IBAction)refreshButtonTapped:(id)sender{
    
}

@end
