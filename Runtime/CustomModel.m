//
//  CustomModel.m
//  Runtime
//
//  Created by YZ Y on 17/3/29.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import "CustomModel.h"

@implementation CustomModel
+ (instancetype)modelWithDictionaryByKVC:(NSDictionary *)dict
{
    CustomModel *model = [[self alloc] init];
    //kvc方式进行字典到模型的转换
    //如果模型中的属性和字典的key不一一对应，系统就会调用setValue:forUndefinedKey:报错。
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //重写对象的setValue:forUndefinedKey:,把系统的方法覆盖，就能继续使用KVC，字典转模型了。
}

@end
