//
//  LZEventCell.m
//  Renren
//
//  Created by lazy on 13-3-22.
//  Copyright (c) 2013年 lazy. All rights reserved.
//

#import "LZEventCell.h"

@implementation LZEventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setProperty{
    self.userStatusText.editable = NO;
    self.userNameText.editable = NO;
    self.userStatusTimeText.editable = NO;
    
    //self.userStatusText.backgroundColor = [UIColor grayColor];
    self.userNameText.scrollEnabled = NO;
    self.userStatusText.scrollEnabled = NO;
    self.userStatusTimeText.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_userHeadImage release];
    [_userNameText release];
    [_statusOptionButton release];
    [_userStatusText release];
    [_userStatusTimeText release];
    [super dealloc];
}

+ (CGRect)adjustHeightInTextView:(CGRect)rect WithText:(NSString *)text{
    UITextView *noteTextView = [[UITextView alloc] initWithFrame:rect];
    CGSize size = [text sizeWithFont:noteTextView.font
                                constrainedToSize:CGSizeMake(100, 100)
                                    lineBreakMode:NSLineBreakByTruncatingTail];
    rect.size.height = size.height > 1 ? size.height + 20 : 64;
    return rect;
}
@end
