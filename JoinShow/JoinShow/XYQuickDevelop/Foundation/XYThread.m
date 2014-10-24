//
//  XYThread.m
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-10.
//
//

#import "XYCommonDefine.h"
#import "XYThread.h"

#pragma mark -

@interface XYGCD()
{
	dispatch_queue_t _foreQueue;
	dispatch_queue_t _backQueue;
}

AS_SINGLETON( XYGCD )

@end

@implementation XYGCD

DEF_SINGLETON( XYGCD )

- (id)init
{
	self = [super init];
	if ( self )
	{
		_foreQueue = dispatch_get_main_queue();
        // 串行队列
		_backQueue = dispatch_queue_create( "com.XY.taskQueue", nil );
	}
	
	return self;
}

+ (dispatch_queue_t)foreQueue
{
	return [[XYGCD sharedInstance] foreQueue];
}

- (dispatch_queue_t)foreQueue
{
	return _foreQueue;
}

+ (dispatch_queue_t)backQueue
{
	return [[XYGCD sharedInstance] backQueue];
}

- (dispatch_queue_t)backQueue
{
	return _backQueue;
}

- (void)dealloc
{
}

+ (void)enqueueForeground:(dispatch_block_t)block
{
	return [[XYGCD sharedInstance] enqueueForeground:block];
}

- (void)enqueueForeground:(dispatch_block_t)block
{
	dispatch_async( _foreQueue, block );
}

+ (void)enqueueBackground:(dispatch_block_t)block
{
	return [[XYGCD sharedInstance] enqueueBackground:block];
}

- (void)enqueueBackground:(dispatch_block_t)block
{
	dispatch_async( _backQueue, block );
}

+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	[[XYGCD sharedInstance] enqueueForegroundWithDelay:ms block:block];
}

- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _foreQueue, block );
}

+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	[[XYGCD sharedInstance] enqueueBackgroundWithDelay:ms block:block];
}

- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
	dispatch_after( time, _backQueue, block );
}

@end

