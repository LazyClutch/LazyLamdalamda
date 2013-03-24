//
//  LZEventsController.m
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZEventsController.h"
#import "LZEventCell.h"
#import "PopoverView.h"
#import "LZEventPushView.h"
#import "EGORefreshTableHeaderView.h"

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
    isLoding = NO;
    
    //initial pull refresh
    if (self.pullRefreshTableView == nil) {
		CGRect rect = CGRectMake(0, -35, 320, 34);
		EGORefreshTableHeaderView *view = [[[EGORefreshTableHeaderView alloc] initWithFrame:rect] autorelease];
		view.delegate = self;
		[self.tableView addSubview:view];
        self.pullRefreshTableView = view;
	}
    
    
    //set UI
    self.navigationItem.title = @"新鲜事";
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshButtonTapped:)] autorelease];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
//    [self.segmentControl addGestureRecognizer:tapRecognizer];
    
    //load data
    [self.pullRefreshTableView refreshLastUpdatedDate];
    [self getFeed];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    [_eventPushButton release];
    [_tableView release];
    [_eventPushButton release];
    [super dealloc];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    NSMutableArray *statusArray = (NSMutableArray *)response.rootObject;
//    for (NSMutableDictionary *dict in statusArray) {
//        CGRect constFrame = CGRectMake(52, 47, 248, 100);
//        CGRect frame = [LZEventCell adjustHeightInTextView:constFrame WithText:[dict objectForKey:@"message"]];
//        NSString *textHeightStr = [NSString stringWithFormat:@"%f",frame.size.height];
//        [dict setObject:textHeightStr forKey:@"textHeight"];
//        NSInteger currHeight = frame.size.height;
//        NSInteger deltaHeight = currHeight + 96;
//        NSString *heightStr = [NSString stringWithFormat:@"%d",deltaHeight];
//        [dict setObject:heightStr forKey:@"height"];
//        NSLog(@"%@suppose:%@",[dict objectForKey:@"message"],textHeightStr);
//        //NSLog(@"%@",heightStr);
//    }
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
    [cell setProperty];
    NSMutableDictionary *oneStatus = [self.statusList objectAtIndex:[indexPath row]];
    [self updateCell:cell withStatus:oneStatus];
    //CGRect newRect = CGRectMake(0, 0, 320, 195 + currHeight);
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableDictionary *oneStatus = [self.statusList objectAtIndex:[indexPath row]];
//    NSString *heightStr = [oneStatus objectForKey:@"height"];
//    NSInteger height = [heightStr integerValue];
    return 195;
}

- (IBAction)refreshButtonTapped:(id)sender{
    
}

- (IBAction)pushEvent:(id)sender {
    CGPoint point = CGPointMake(155, 25);
    CGRect rect = CGRectMake(155, 25, 240, 120);

    LZEventPushView *pushView = [[LZEventPushView alloc] initWithFrame:rect];
    [PopoverView showPopoverAtPoint:point inView:self.view withTitle:@"发条新鲜事" withContentView:pushView delegate:self];

}


- (void)updateCell:(LZEventCell *)cell withStatus:(NSDictionary *)oneStatus{
    
    //set head image
    NSURL *headUrl = [NSURL URLWithString:[oneStatus objectForKey:@"headurl"]];
    NSData *data = [NSData dataWithContentsOfURL:headUrl];
    UIImage *headImage = [UIImage imageWithData:data];
    cell.userHeadImage.image = headImage;
    
    //set text
    cell.userNameText.text = [oneStatus objectForKey:@"name"];
    cell.userStatusText.text = [oneStatus objectForKey:@"prefix"];
    cell.userStatusTimeText.text = [oneStatus objectForKey:@"update_time"];
    
//    //adjust height
//    NSString *textStrHeight = [oneStatus objectForKey:@"textHeight"];
//    NSInteger textHeight = [textStrHeight integerValue];
//    CGRect textRect = CGRectMake(52, 47, 248, textHeight);
//    //NSLog(@"%f",cell.userStatusText.frame.size.height);
//    [cell.userStatusText setFrame:textRect];
//    NSLog(@"%@actually:%f",[oneStatus objectForKey:@"message"],cell.userStatusText.frame.size.height);
//    
//    NSString *heightStr = [oneStatus objectForKey:@"height"];
//    NSInteger height = [heightStr integerValue];
//    
//    CGRect textTimeRect = CGRectMake(52, height - 12, cell.userStatusTimeText.frame.size.width, cell.userStatusTimeText.frame.size.height);
//    [cell.userStatusTimeText setFrame:textTimeRect];

}


- (void)viewDidUnload {
    [self setEventPushButton:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	isLoding = YES;
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];

	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	isLoding = NO;
	[self.pullRefreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

- (void)doInBackground{
    [self getFeed];
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[self.pullRefreshTableView egoRefreshScrollViewDidScroll:scrollView];    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[self.pullRefreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [NSThread sleepForTimeInterval:1];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isLoding; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
