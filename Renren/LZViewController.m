//
//  LZViewController.m
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZViewController.h"
#import "LZOptionViewController.h"

@interface LZViewController ()

@property (strong, nonatomic) LZOptionViewController *optionViewController;

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[Renren sharedRenren] isSessionValid]) {
        self.loginLabel.text = @"Unlogined";
    } else {
        self.loginLabel.text = @"Logined";
        if (self.optionViewController == nil) {
            self.optionViewController = [[[LZOptionViewController alloc] init] autorelease];
            [self.navigationController pushViewController:self.optionViewController animated:YES];
        }
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userLogin:(id)sender{
    if (![[Renren sharedRenren] isSessionValid]) {
        [[Renren sharedRenren] authorizationInNavigationWithPermisson:nil andDelegate:self];
        if (self.optionViewController== nil){
            self.optionViewController = [[[LZOptionViewController alloc] init] autorelease];
            [self.navigationController pushViewController:self.optionViewController animated:YES];
        }
    } else {
        [[Renren sharedRenren] logout:self];
    }
}


- (void)dealloc{
    self.loginButton = nil;
    self.loginLabel = nil;

    [super dealloc];
}

- (void)renrenDidLogin:(Renren *)renren{
    self.loginLabel.text = @"Login Successful";
}

- (void)renrenDidLogout:(Renren *)renren{
    self.loginLabel.text = @"Please Login";
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"认证失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}



@end
