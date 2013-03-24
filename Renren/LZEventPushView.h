//
//  LZEventPushView.h
//  Renren
//
//  Created by lazy on 13-3-24.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZEventPushView : UIView <RenrenDelegate>
@property (retain, nonatomic) UITextView *eventToPushTextView;
@property (retain, nonatomic) UIButton *sendButton;

- (IBAction)sendMessage:(id)sender;
@end
