//
//  LZEventsController.h
//  Renren
//
//  Created by lazy on 13-3-21.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZEventsController : UIViewController <RenrenDelegate>

@property (nonatomic, strong) NSArray *statusList;

- (IBAction)refreshButtonTapped:(id)sender;

@end
