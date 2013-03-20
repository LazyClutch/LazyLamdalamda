//
//  LZOptionViewController.h
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZOptionViewController : UIViewController <RenrenDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *optionArray;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *viewController;


@end
