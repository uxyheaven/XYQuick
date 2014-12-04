//
//  XYBaseBuilder.h
//  JoinShow
//
//  Created by heaven on 14/12/4.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

// 生成器基类
@interface XYBaseBuilder : NSObject

// 生成生成器
+ (id)builderWithClass:(Class)clazz;
+ (id)builderWithClassName:(NSString *)clazzName;

// 生成对象
- (id)build;

// 此方法在build中被调用, 重写此方法实现对象属性的赋值,细节的调整
- (id)buildAnObject:(id)anObject;

@end
