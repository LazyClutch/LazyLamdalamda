//
//  LZEventsController.m
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZEventsController.h"
#import "LZEventCell.h"

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
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self getFeed];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    [_tabBar release];
    [_tableView release];
    [super dealloc];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    NSMutableArray *statusArray = (NSMutableArray *)response.rootObject;
    self.statusList = statusArray;
    [self.tableView reloadData];

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

#pragma mark-
#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.statusList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *StatusCellIdentifier = @"StatusCellIdentifier";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LZEventCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:StatusCellIdentifier];
        nibsRegistered = YES;
    }
    LZEventCell *cell = [tableView dequeueReusableCellWithIdentifier:StatusCellIdentifier];
    NSDictionary *oneStatus = [self.statusList objectAtIndex:[indexPath row]];
    NSURL *headUrl = [NSURL URLWithString:[oneStatus objectForKey:@"headurl"]];
    NSData *data = [NSData dataWithContentsOfURL:headUrl];
    UIImage *headImage = [UIImage imageWithData:data];
    [cell setProperty];
    cell.userHeadImage.image = headImage;
    cell.userNameText.text = [oneStatus objectForKey:@"name"];
    cell.userStatusText.text = [oneStatus objectForKey:@"message"];
    cell.userStatusTimeText.text = [oneStatus objectForKey:@"update_time"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}

- (IBAction)refreshButtonTapped:(id)sender{
    
}




@end
