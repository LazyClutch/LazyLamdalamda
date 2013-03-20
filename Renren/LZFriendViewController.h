//
//  LZFriendViewController.h
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZFriendViewController : UIViewController <RenrenDelegate,UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) ROUserResponseItem *friendsArray;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *friendsList;
@property (nonatomic, retain) NSMutableArray *friendsDictionary;
@property (nonatomic, retain) NSMutableDictionary *friendKeys;
@property (nonatomic, retain) NSArray *keys;

@end
