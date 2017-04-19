//
//  ViewController.m
//  Runtime
//
//  Created by YZ Y on 17/3/8.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#define win_width [UIScreen mainScreen].bounds.size.width
#define win_height [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "UIButton+YYButton.h"
#import "NSObject+Property.h"
#import "CustomModel.h"
#import "NSObject+Log.h"
#import "NSObject+Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *msgButton = [UIButton buttonWithTitle:@"发送消息" target:self action:@selector(msgSend) frame:CGRectMake(50, 80, win_width - 100, 60)];
    [self.view addSubview:msgButton];
    
    UIButton *exchangeButton = [UIButton buttonWithTitle:@"交换方法" target:self action:@selector(exchangeMethod) frame:CGRectMake(50, 200, win_width - 100, 60)];
    [self.view addSubview:exchangeButton];
    
    UIButton *addMethodButton = [UIButton buttonWithTitle:@"添加方法" target:self action:@selector(addMethod) frame:CGRectMake(50, 300, win_width - 100, 60)];
    [self.view addSubview:addMethodButton];
    
    UIButton *addPropertyButton = [UIButton buttonWithTitle:@"添加属性" target:self action:@selector(addProperty) frame:CGRectMake(50, 400, win_width - 100, 60)];
    [self.view addSubview:addPropertyButton];
    
    UIButton *modelButton = [UIButton buttonWithTitle:@"字典转模型" target:self action:@selector(dictionaryToModel) frame:CGRectMake(50, 500, win_width - 100, 60)];
    [self.view addSubview:modelButton];
}


- (void)msgSend
{
    Person *p = [Person new];
    //调用对象方法
    [p eat1];
    //本质是让对象发送消息
    objc_msgSend(p, @selector(eat1));

    //通过类名调用
    [Person eat2];
    //通过类对象调用
    [[Person class] eat2];
    //使用类名调用时，底层会自动转换成类对象调用
    //本质是让类对象发送消息
    objc_msgSend([Person class], @selector(eat2));
}

- (void)exchangeMethod
{
    //给UIImage的imageNamed添加一个新的功能，在加载图片时，都判断图片是否加载成功
    //1.定义一个分类，实现一个既可以加载图片也可以打印信息的方法imageWithName:(NSString *)name
    //2.交换imageNamed和imageWithName的实现，在调用imageNamed时间接调用imageWithName的实现
    UIImage *image = [UIImage imageNamed:@"123"];
    
}

- (void)addMethod
{
    Person *p = [Person new];
    [p performSelector:@selector(play)];
}

- (void)addProperty
{
    NSObject *obj = [NSObject new];
    obj.name = @"yyz";
    NSLog(@"%@", obj.name);
}

- (void)dictionaryToModel
{
    NSDictionary *employeeDict = @{@"name": @"yyz", @"age": @"28"};
    CustomModel *employeeModel = [CustomModel modelWithDictionaryByKVC:employeeDict];
    [CustomModel resolveDict:employeeDict];
    NSLog(@"name:%@ age:%@", employeeModel.name, employeeModel.age);
    NSDictionary *managerDict = @{@"name": @"Lb", @"age": @"39"};
    CustomModel *managerModel = [CustomModel modelFromDictionaryByRuntime:managerDict];
    NSLog(@"name:%@ age:%@", managerModel.name, managerModel.age);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

/**交换方法*/
@implementation UIImage (Image)
//加载分类到内存时调用
+ (void)load
{
    //交换方法
    //获取imageWithName方法的地址
    Method imageWithName = class_getClassMethod(self, @selector(imageWithName:));
    //获取imageName方法的地址
    Method imageName = class_getClassMethod(self, @selector(imageNamed:));
    //交换方法的地址，相当于交换实现方式
    method_exchangeImplementations(imageWithName, imageName);
}

//不能在分类中重写系统方法imageNamed,因为会把系统方法覆盖掉,而且分类中也不能调用super
//加载图片并打印信息
+ (instancetype)imageWithName:(NSString *)name
{
    //这里调用imageWithName，相当于调用imageNamed
    UIImage *image = [self imageWithName:name];
    if (image == nil) {
        NSLog(@"加载空图片");
    }
    return image;
}

@end


