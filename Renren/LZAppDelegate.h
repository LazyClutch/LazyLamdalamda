//
//  LZAppDelegate.h
//  Renren
//
//  Created by lazy on 13-3-17.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZViewController;

@interface LZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LZViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
