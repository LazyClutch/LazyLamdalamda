//
//  LZEventsController.h
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"


@interface LZEventsController : UIViewController <RenrenDelegate,UITableViewDataSource,UITableViewDelegate,PopoverViewDelegate>

@property (nonatomic, strong) NSArray *statusList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIButton *eventPushButton;


- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)pushEvent:(id)sender;

@end
