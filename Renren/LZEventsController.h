//
//  LZEventsController.h
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZEventsController : UIViewController <RenrenDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *statusList;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)refreshButtonTapped:(id)sender;

@end
