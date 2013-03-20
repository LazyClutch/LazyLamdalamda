//
//  LZFriendViewController.h
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZFriendViewController : UIViewController <RenrenDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (retain, nonatomic) ROUserResponseItem *friendsArray;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableArray *friendsList;
@property (nonatomic, retain) NSMutableArray *friendsDictionary;
@property (nonatomic, retain) NSMutableDictionary *friendKeys;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *keysForSearch;
@property (nonatomic, strong) NSMutableDictionary *names;

- (void)resetSearch;
- (void)handleSearchForItem:(NSString *)item;

@end
