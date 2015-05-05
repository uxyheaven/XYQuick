//
//  XYBaseBuilder.h
//  JoinShow
//
//  Created by heaven on 14/12/4.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

// 建造者模式
#import <Foundation/Foundation.h>

/*
@protocol XYBaseBuilder <NSObject>
// 返回对象是否成功构建,在这里做条件判断
- (BOOL)isBuildRight;
@end
*/

// 建造者基类, 抽象的建造者
@interface XYBaseBuilder : NSObject

/**
 * @brief 生成产品
 * @param clazz 产品的类
 * @param block builder构造的block
 * @return 返回产品
 */
+ (id)productWithClass:(Class)clazz builder:(void(^)(id builder))block;

/**
 * @brief 生成产品
 * @param block builder构造的block, 需要在这里返回产品的实例
 * @return 返回产品
 */
+ (id)productWithBuilder:(id(^)(id builder))block;


// 生成产品, 请override这个方法做验证
- (id)build;

@end


/* 待解决id问题再实现
@interface NSObject (UXYBuilder)
+ (id)objectWithUXYBuilder:(void(^)(id builder))block;
@end
*/