//
//  NSObject+Model.m
//  Runtime
//
//  Created by YZ Y on 17/3/29.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)
+ (instancetype)modelFromDictionaryByRuntime:(NSDictionary *)dict
{
    //思路：遍历模型的所有属性->使用允许时
    //0.创建对应的对象
    id obj = [[self alloc] init];
    //1.使用runtime给对象的成员属性赋值
    //class_copyIvarList:获取类中的所有成员属性
    //Ivar:成员属性
    //第一个参数:获取哪个类中的成员属性
    //第二个参数:表示这个类有多少成员属性,传入一个Int变量地址,会自动给这个变量赋值
    //返回值Ivar *:指的是一个成员属性数组，通过这个数组可以获取所有的成员属性
    /* 类似以下写法
     
     Ivar var1;
     Ivar var2;
     Ivar var3;
     //定义一个ivar数组a
     Ivar a[] = {var1, var2, var3};
     //用Ivar *指针指向数组第一个元素
     Ivar *ivarList = a;
     //根据指针访问数组第一个元素
     ivarList[0];
     */
    unsigned int count;
    //获取类中的所有成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    //遍历所有成员属性
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        //获取成员属性的名称
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //成员属性名称->字典中的key，从第一个角标截取
        NSString *key = [name substringFromIndex:1];
        //根据key获取对应的value
        id value = dict[key];
        //二级转换：如果字典中还有字典，也需要转换成模型
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 字典转模型
            // 获取模型的类对象，调用modelWithDict
            // 模型的类名已知，就是成员属性的类型
            
            // 获取成员属性的类别
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            // 生成的是这种@"@\"User\"" 类型 -> @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
            // 截取类型字符串
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            // 截取到角标，不包含角标
            type = [type substringToIndex:range.location];
            // 根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            if (modelClass) {//有对应的模型才转换
                //字典转模型
                value = [modelClass modelFromDictionaryByRuntime:value];
            }
        }
        
        //三级转换：如果有数组，也要转换成模型
        if ([value isKindOfClass:[NSArray class]]) {
            //判断对应类有没有字典数组转换成模型数组的协议
            if ([self instancesRespondToSelector:@selector(arrayContainModelClass)]) {
                // 转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                
                // 获取数组中字典对应的模型
                NSString *type =  [idSelf arrayContainModelClass][key];
                
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (NSDictionary *dict in value) {
                    // 字典转模型
                    id model =  [classModel modelFromDictionaryByRuntime:dict];
                    [arrM addObject:model];
                }
                
                // 把模型数组赋值给value
                value = arrM;
            }
        }
        if (value) {//有值时给属性赋值
            // 利用KVC给模型中的属性赋值
            [obj setValue:value forKey:key];
        }
    }
    
    return obj;
}

- (NSDictionary *)arrayContainModelClass
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    return [dictM copy];
}

@end
