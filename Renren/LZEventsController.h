//
//  LZEventsController.h
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "EGORefreshTableHeaderView.h"


@interface LZEventsController : UIViewController <RenrenDelegate,UITableViewDataSource,UITableViewDelegate,PopoverViewDelegate,EGORefreshTableHeaderDelegate>{
    BOOL isLoding;
}

@property (nonatomic, strong) NSArray *statusList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIButton *eventPushButton;
@property (strong, nonatomic) EGORefreshTableHeaderView *pullRefreshTableView;


- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)pushEvent:(id)sender;

@end
