//
//  LZFriendViewController.m
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZFriendViewController.h"
#import "pinyin.h"

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

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSString *name = self.friendsArray.name;
//    self.navigationController.title = name;
//    NSURL *headUrl = [NSURL URLWithString:self.friendsArray.headUrl];
//    NSData *data = [NSData dataWithContentsOfURL:headUrl];
//    UIImage *headImage = [UIImage imageWithData:data];
//    self.imageView.image = headImage;
}

- (void)getFriendsList{
    if ([[Renren sharedRenren] isSessionValid]) {
        ROGetFriendsInfoRequestParam *requestParam = [[[ROGetFriendsInfoRequestParam alloc] init] autorelease];
        requestParam.count = @"500";
        requestParam.page = @"1";
        requestParam.fields = @"name";
        [[Renren sharedRenren] getFriendsInfo:requestParam andDelegate:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"认证失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)dealloc {
    [_imageView release];
    self.friendsDictionary = nil;
    self.friendsList = nil;
    self.tableView = nil;
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.friendKeys == nil) {
        return 0;
    }
    NSArray* array = [self.friendKeys objectForKey:[self.keys objectAtIndex:section]];
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.keys == nil) {
        return 0;
    }
    return [self.keys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.keys == nil) {
        return nil;
    }
    return [self.keys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.keys == nil) {
        return nil;
    }
    return self.keys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FriendsListCellIdentifier = @"FriendsListCellIdentifier";
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *names = [self.friendKeys objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendsListCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendsListCellIdentifier]autorelease];
    }
    cell.textLabel.text = [[names objectAtIndex:row] name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

@end
