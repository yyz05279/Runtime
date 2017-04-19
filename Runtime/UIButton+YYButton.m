//
//  UIButton+YYButton.m
//  Runtime
//
//  Created by YZ Y on 17/3/27.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import "UIButton+YYButton.h"

@implementation UIButton (YYButton)
+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    return button;
}

@end
