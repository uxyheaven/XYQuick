//
//  XYThread.h
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-10.
//  Copy from bee Framework
//
//////////////////////////////////////////////////////////////////
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "XYCommonDefine.h"

#pragma mark -

#define FOREGROUND_BEGIN		[XYGCD enqueueForeground:^{
#define FOREGROUND_BEGIN_(x)	[XYGCD enqueueForegroundWithDelay:(dispatch_time_t)x block:^{
#define FOREGROUND_COMMIT		}];

#define BACKGROUND_BEGIN		[XYGCD enqueueBackground:^{
#define BACKGROUND_BEGIN_(x)	[XYGCD enqueueBackgroundWithDelay:(dispatch_time_t)x block:^{
#define BACKGROUND_COMMIT		}];

#define BACKGROUND_IOFILE_BEGIN         [XYGCD enqueueBackgroundIOFile:^{
#define BACKGROUND_IOFILE_BEGIN_(x)     [XYGCD enqueueBackgroundIOFileWithDelay:(dispatch_time_t)x block:^{
#define BACKGROUND_IOFILE_COMMIT        }];

#pragma mark -

@class XYGCD;
typedef XYGCD * (^XY_GCD_block)( dispatch_block_t block );

@interface XYGCD : NSObject

AS_SINGLETON( XYGCD )

@property (nonatomic, readonly) XY_GCD_block	MAIN;
@property (nonatomic, readonly) XY_GCD_block	FORK;
@property (nonatomic, readonly) XY_GCD_block	FORK_IO_FILE;

+ (dispatch_queue_t)foreQueue;
+ (dispatch_queue_t)backQueue;
+ (dispatch_queue_t)backIOFileQueue;

+ (void)enqueueForeground:(dispatch_block_t)block;
+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

+ (void)enqueueBackground:(dispatch_block_t)block;
+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

+ (void)enqueueBackgroundIOFile:(dispatch_block_t)block;
+ (void)enqueueBackgroundIOFileWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

@end
