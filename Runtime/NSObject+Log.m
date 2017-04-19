//
//  NSObject+Log.m
//  Runtime
//
//  Created by YZ Y on 17/3/29.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import "NSObject+Log.h"

@implementation NSObject (Log)
+ (void)resolveDict:(NSDictionary *)dict
{
    NSMutableString * strM = [NSMutableString string];
    // 1.遍历字典，把字典中的所有key取出来，生成对应的属性代码
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *type = @"";
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            type = @"NSString";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            type = @"NSArray";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            type = @"NSNumber";
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSDictionary")]) {
            type = @"NSDictionary";
        }
        // 属性字符串
        NSString *str = @"";
        if ([type containsString:@"NS"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@", type, key];
        } else {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@", type, key];
        }
        [strM appendFormat:@"\n%@\n", str];
    }];
    NSLog(@"%@", strM);
}
@end
