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
#pragma mark -

typedef NSMutableArray *	(^NSArrayAppendBlock)( id obj );
typedef NSMutableArray *	(^NSMutableArrayAppendBlock)( id obj );

#pragma mark -

@interface NSArray(XYExtension)

- (NSArray *)uxy_head:(NSUInteger)count;
- (NSArray *)uxy_tail:(NSUInteger)count;

- (id)uxy_safeObjectAtIndex:(NSInteger)index;
- (NSArray *)uxy_safeSubarrayWithRange:(NSRange)range;
- (NSArray *)uxy_safeSubarrayFromIndex:(NSUInteger)index;
- (NSArray *)uxy_safeSubarrayWithCount:(NSUInteger)count;

- (NSInteger)uxy_indexOfString:(NSString *)string;

@end

#pragma mark -

@interface NSMutableArray(XYExtension)

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

@end
