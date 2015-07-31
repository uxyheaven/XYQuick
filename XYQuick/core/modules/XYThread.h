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

#import "XYQuick_Predefine.h"

#pragma mark -
// 主队列
#undef	dispatch_async_foreground
#define dispatch_async_foreground( block ) \
        dispatch_async( dispatch_get_main_queue(), block )

#undef	dispatch_after_foreground
#define dispatch_after_foreground( seconds, block ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, dispatch_get_main_queue(), block ); \
        }

// 自己建的后台并行队列
#undef	dispatch_async_background
#define dispatch_async_background( block )      dispatch_async_background_concurrent( block )

#undef	dispatch_async_background_concurrent
#define dispatch_async_background_concurrent( block ) \
        dispatch_async( [XYGCD sharedInstance].backConcurrentQueue, block )

#undef	dispatch_after_background_concurrent
#define dispatch_after_background_concurrent( seconds, block ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, [XYGCD sharedInstance].backConcurrentQueue, block ); \
        }

// 自己建的后台串行队列
#undef	dispatch_async_background_serial
#define dispatch_async_background_serial( block ) \
        dispatch_async( [XYGCD sharedInstance].backSerialQueue, block )

#undef	dispatch_after_background_serial
#define dispatch_after_background_serial( seconds, block ) \
        { \
            dispatch_time_t __time = dispatch_time( DISPATCH_TIME_NOW, seconds * 1ull * NSEC_PER_SEC ); \
            dispatch_after( __time, [XYGCD sharedInstance].backSerialQueue, block ); \
        }

// 自己建写的文件用的串行队列
#undef	dispatch_async_background_writeFile
#define dispatch_async_background_writeFile( block ) \
        dispatch_async( [XYGCD sharedInstance].writeFileQueue, block )


// barrier
#undef	dispatch_barrier_async_foreground
#define dispatch_barrier_async_foreground( seconds, block ) \
        dispatch_barrier_async( [XYGCD sharedInstance].backConcurrentQueue, ^{   \
            dispatch_async_foreground( block );   \
        });

#undef	dispatch_barrier_async_background_concurrent
#define dispatch_barrier_async_background_concurrent( seconds, block ) \
        dispatch_barrier_async( [XYGCD sharedInstance].backConcurrentQueue, block )

#pragma mark -

@interface XYGCD : NSObject uxy_as_singleton

// dispatch_get_main_queue()
@property (nonatomic, strong, readonly) dispatch_queue_t foreQueue;
// "com.XY.backSerialQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backSerialQueue;
// "com.XY.backConcurrentQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t backConcurrentQueue;
// 写文件用 "com.XY.writeFileQueue", DISPATCH_QUEUE_SERIAL
@property (nonatomic, strong, readonly) dispatch_queue_t writeFileQueue;

@end
