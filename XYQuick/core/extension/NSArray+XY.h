//
//  NSArray+XY.h
//  JoinShow
//
//  Created by Heaven on 13-10-14.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//
//  Copy from bee Framework http://www.bee-framework.com

#pragma mark -
#import <Foundation/Foundation.h>

typedef NSMutableArray *	(^NSArrayAppendBlock)( id obj );
typedef NSMutableArray *	(^NSMutableArrayAppendBlock)( id obj );

#pragma mark -

@interface NSArray(XY)

- (NSArray *)uxy_head:(NSUInteger)count;
- (NSArray *)uxy_tail:(NSUInteger)count;

- (id)uxy_safeObjectAtIndex:(NSInteger)index;
- (NSArray *)uxy_safeSubarrayWithRange:(NSRange)range;
- (NSArray *)uxy_safeSubarrayFromIndex:(NSUInteger)index;
- (NSArray *)uxy_safeSubarrayWithCount:(NSUInteger)count;

- (NSInteger)uxy_indexOfString:(NSString *)string;

@end

#pragma mark -

@interface NSMutableArray(XY)

- (void)uxy_safeAddObject:(id)anObject;

+ (NSMutableArray *)uxy_nonRetainingArray;

- (NSMutableArray *)uxy_pushHead:(NSObject *)obj;
- (NSMutableArray *)uxy_pushHeadN:(NSArray *)all;
- (NSMutableArray *)uxy_popTail;
- (NSMutableArray *)uxy_popTailN:(NSUInteger)n;

- (NSMutableArray *)uxy_pushTail:(NSObject *)obj;
- (NSMutableArray *)uxy_pushTailN:(NSArray *)all;
- (NSMutableArray *)uxy_popHead;
- (NSMutableArray *)uxy_popHeadN:(NSUInteger)n;

- (NSMutableArray *)uxy_keepHead:(NSUInteger)n;
- (NSMutableArray *)uxy_keepTail:(NSUInteger)n;

// 把自己转变成不可变的(可能有bug)
- (NSArray *)uxy_immutable;

@end
