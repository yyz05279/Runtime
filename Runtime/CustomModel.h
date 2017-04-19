//
//  CustomModel.h
//  Runtime
//
//  Created by YZ Y on 17/3/29.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject
+ (instancetype)modelWithDictionaryByKVC:(NSDictionary *)dict;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;

@end
