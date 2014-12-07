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


#pragma mark - XYBlackMagic
@interface XYBlackMagic : NSObject

@end
