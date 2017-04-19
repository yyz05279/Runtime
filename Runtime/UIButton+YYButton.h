//
//  UIButton+YYButton.h
//  Runtime
//
//  Created by YZ Y on 17/3/27.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YYButton)
+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action frame:(CGRect)frame;

@end
