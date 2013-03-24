//
//  LZEventCell.h
//  Renren
//
//  Created by lazy on 13-3-22.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTwitterCoreTextView.h"
#define IMAGE_VIEW_HEIGHT 80.0f
#define PADDING_TOP 8.0
#define PADDING_LEFT 8.0
#define FONT_SIZE 15.0
#define FONT @"Helvetica"

@interface LZEventCell : UITableViewCell <JSCoreTextViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (retain, nonatomic) IBOutlet UITextView *userNameText;
@property (retain, nonatomic) IBOutlet UIButton *statusOptionButton;
@property (retain, nonatomic) IBOutlet UITextView *userStatusText;
@property (retain, nonatomic) IBOutlet UITextView *userStatusTimeText;

- (void)setProperty;
+ (CGRect)adjustHeightInTextView:(CGRect)rect WithText:(NSString *)text;

@end
