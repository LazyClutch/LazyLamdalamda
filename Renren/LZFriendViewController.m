//
//  LZFriendViewController.m
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZFriendViewController.h"
#import "pinyin.h"
#import "NSDictionary+MutableDeepCopy.h"

@interface LZFriendViewController ()

@end

@implementation LZFriendViewController

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
    self.navigationItem.title = @"好友列表";
    [self getFriendsList];
    //[self.tableView setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    [self.tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    [self.tableView reloadData];
//    NSString *name = self.friendsArray.name;
//    self.navigationController.title = name;
//    NSURL *headUrl = [NSURL URLWithString:self.friendsArray.headUrl];
//    NSData *data = [NSData dataWithContentsOfURL:headUrl];
//    UIImage *headImage = [UIImage imageWithData:data];
//    self.imageView.image = headImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.friendsDictionary = nil;
    self.friendsList = nil;
    self.tableView = nil;
    self.friendKeys = nil;
    self.friendsArray = nil;
    self.searchBar = nil;
    self.names = nil;
    self.keys = nil;
    [super dealloc];
}

- (void)getFriendsList{
    if ([[Renren sharedRenren] isSessionValid]) {
        ROGetFriendsInfoRequestParam *requestParam = [[[ROGetFriendsInfoRequestParam alloc] init] autorelease];
        requestParam.count = @"1000";
        requestParam.page = @"1";
        requestParam.fields = @"name";
        [[Renren sharedRenren] getFriendsInfo:requestParam andDelegate:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"认证失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    self.friendsList = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *friendsArray = (NSMutableArray *)response.rootObject;
    NSMutableDictionary *keyDic = [[[NSMutableDictionary alloc] init] autorelease];
    self.friendsDictionary = friendsArray;
    for (ROUserResponseItem *item in friendsArray) {
        [self.friendsList addObject:item.name];
        char firstLetter = pinyinFirstLetter([item.name characterAtIndex:0]);
        NSString *firstLetterStr = [NSString stringWithFormat:@"%c",firstLetter];
        [keyDic setObject:item forKey:firstLetterStr];
    }
    self.friendKeys = keyDic;
    [self processData];
    [self.tableView reloadData];
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"认证失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)processData{
    NSArray *array = [[self.friendKeys allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.keys = array;
    self.keysForSearch = [array mutableCopy];
    [self.friendKeys removeAllObjects];
    NSMutableDictionary *friendKeys = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *key in self.keys) {
        NSMutableArray *nilArray = [[[NSMutableArray alloc] init] autorelease];
        [friendKeys setObject:nilArray forKey:key];
    }
    for (ROUserResponseItem* item in self.friendsDictionary) {
        //Get the first letter of the name
        char firstLetter = pinyinFirstLetter([item.name characterAtIndex:0]);
        NSString *firstLetterStr = [NSString stringWithFormat:@"%c",firstLetter];
        NSMutableArray *keyArray = [friendKeys objectForKey:firstLetterStr];
        [keyArray addObject:item];
        [friendKeys removeObjectForKey:firstLetterStr];
        [friendKeys setObject:keyArray forKey:firstLetterStr];
    }
    self.friendKeys = friendKeys;
    [self resetSearch];

}

#pragma mark-
#pragma mark Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.names == nil) {
        return 0;
    }
    NSArray* array = [self.names objectForKey:[self.keysForSearch objectAtIndex:section]];
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.keysForSearch == nil) {
        return 1;
    }
    return [self.keysForSearch count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.keysForSearch == nil) {
        return nil;
    }
    return [self.keysForSearch objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.keysForSearch == nil) {
        return nil;
    }
    return self.keysForSearch;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FriendsListCellIdentifier = @"FriendsListCellIdentifier";
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [self.keysForSearch objectAtIndex:section];
    NSArray *names = [self.names objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendsListCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendsListCellIdentifier]autorelease];
    }
    cell.textLabel.text = [[names objectAtIndex:row] name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    return indexPath;
}

#pragma mark SearchBar Methods

- (void)resetSearch{
    self.names = [self.friendKeys mutableDeepCopy];
    NSArray *array = [[self.friendKeys allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.keysForSearch = [array mutableCopy];
}

- (void)handleSearchForItem:(NSString *)item{
    NSMutableArray *sectionsToRemove = [[[NSMutableArray alloc] init] autorelease];
    [self resetSearch];
    
    for (NSString *key in self.keysForSearch) {
        NSMutableArray *array = [self.names valueForKey:key];
        NSMutableArray *toRemove = [[[NSMutableArray alloc] init] autorelease];
        for (ROFriendResponseItem *friendItem in array) {
            NSString *name = friendItem.name;
            if ([name rangeOfString:item options:NSCaseInsensitiveSearch].location == NSNotFound) {
                [toRemove addObject:friendItem];
            }
        }
        if ([array count] == [toRemove count]) {
            [sectionsToRemove addObject:key];
        }
        [array removeObjectsInArray:toRemove];
    }
    [self.keysForSearch removeObjectsInArray:sectionsToRemove];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",[searchBar text]);
    NSString *searchTerm = [self.searchBar text];
    [self handleSearchForItem:searchTerm];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",self.searchBar.text);

    if ([searchText length] == 0) {
        [self resetSearch];
        [self.tableView reloadData];
        return;
    }
    [self handleSearchForItem:searchText];
}

@end
