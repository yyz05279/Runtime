//
//  NSObject+Model.h
//  Runtime
//
//  Created by YZ Y on 17/3/29.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)
+ (instancetype)modelFromDictionaryByRuntime:(NSDictionary *)dict;

@end
