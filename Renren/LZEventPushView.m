//
//  LZEventPushView.m
//  Renren
//
//  Created by lazy on 13-3-24.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZEventPushView.h"

@implementation LZEventPushView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect textFrame = CGRectMake(0, 0, 240, 80);
        self.eventToPushTextView = [[UITextView alloc] initWithFrame:textFrame];
        self.eventToPushTextView.text = @"请在此输入";
        [self addSubview:self.eventToPushTextView];
        CGRect sendButtonFrame = CGRectMake(190, 85, 40, 30);
        self.sendButton = [[UIButton alloc] initWithFrame:sendButtonFrame];
        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.sendButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_eventToPushTextView release];
    [_sendButton release];
    [super dealloc];
}


- (IBAction)sendMessage:(id)sender {
    NSString *message = [self.eventToPushTextView text];
    if ([[Renren sharedRenren] isSessionValid]) {
        NSMutableDictionary *feedDic = [[[NSMutableDictionary alloc] init] autorelease];
        [feedDic setObject:@"status.set" forKey:@"method"];
        [feedDic setObject:message forKey:@"status"];
        
        [[Renren sharedRenren] requestWithParams:feedDic andDelegate:self];
    }
    
}

/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response {
    NSString *message = @"通知";
    NSString *status = @"发送成功";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:status delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

/**
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error {
    NSString *message = @"通知";
    NSString *status = @"发送失败";
    NSString *reason = [error.userInfo valueForKey:@"error_msg"];
    NSString *outcome = [NSString stringWithFormat:@"%@:%@",status,reason];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:outcome delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
