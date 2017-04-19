//
//  Person.h
//  Runtime
//
//  Created by YZ Y on 17/3/27.
//  Copyright © 2017年 YYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
- (void)eat1;
+ (void)eat2;

@end

@interface Person (addMethod)
- (void)play;

@end
