//
//  XYBlackMagic.h
//  JoinShow
//
//  Created by Heaven on 14/11/14.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
// 黑魔法

#pragma mark - others
static void blockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}

// 当当前作用域结束时自动执行{}里面的方法
#define BM_ON_EXIT \
    __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^


#define keypath2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

// 判断宏参数个数
#define COUNT_PARMS2(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _, ...) _
#define COUNT_PARMS(...) COUNT_PARMS2(__VA_ARGS__, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)


#pragma mark - XYBlackMagic
@interface XYBlackMagic : NSObject

@end
