//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYQuick_Predefine.h"
#import <Foundation/Foundation.h>
#pragma mark -

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


/// 生成产品, 请override这个方法做验证
- (id)build;

@end


/* 待解决id问题再实现
@interface NSObject (UXYBuilder)
+ (id)objectWithUXYBuilder:(void(^)(id builder))block;
@end
*/