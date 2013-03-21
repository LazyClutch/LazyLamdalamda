//
//  LZOptionViewController.m
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZOptionViewController.h"
#import "LZFriendViewController.h"
#import "LZEventsController.h"

@interface LZOptionViewController ()

@end

@implementation LZOptionViewController

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
    self.navigationItem.title = @"主菜单";
    self.optionArray = @[@"好友列表",@"新鲜事"];
    
    NSMutableArray *controllers = [[[NSMutableArray alloc] init] autorelease];
    
    LZFriendViewController *friendsViewController = [[[LZFriendViewController alloc] initWithNibName:@"LZFriendViewController" bundle:nil]  autorelease];
    [controllers addObject:friendsViewController];
    
    LZEventsController *eventViewController = [[LZEventsController alloc] initWithNibName:@"LZEventsController" bundle:nil];
    [controllers addObject:eventViewController];
    
    self.viewControllers = controllers;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.tableView = nil;
    self.optionArray = nil;
    [super dealloc];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.optionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *OptionCellIdentifier = @"OptionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OptionCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OptionCellIdentifier] autorelease];
    }
    cell.textLabel.text = [self.optionArray objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.viewController = [self.viewControllers objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:self.viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.viewController = [self.viewControllers objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:self.viewController animated:YES];    
}




@end
