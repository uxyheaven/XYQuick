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

@property (nonatomic, strong) dispatch_queue_t foreQueue;
@property (nonatomic, strong) dispatch_queue_t backQueue;
@property (nonatomic, strong) dispatch_queue_t backIOFileQueue;

@end

@implementation XYGCD

DEF_SINGLETON( XYGCD )

- (id)init
{
	self = [super init];
	if ( self )
	{
        _foreQueue       = dispatch_get_main_queue();
        // 串行队列
        _backQueue       = dispatch_queue_create( "com.XY.taskQueue", DISPATCH_QUEUE_SERIAL );
        // todo dispatch_barrier_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
        _backIOFileQueue = dispatch_queue_create( "com.XY.taskQueue", DISPATCH_QUEUE_SERIAL );
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

+ (dispatch_queue_t)backIOFileQueue
{
    return [[XYGCD sharedInstance] backIOFileQueue];
}

- (dispatch_queue_t)backIOFileQueue
{
    return _backIOFileQueue;
}

#pragma mark-Foreground
+ (void)enqueueForeground:(dispatch_block_t)block
{
	return [[XYGCD sharedInstance] enqueueForeground:block];
}

- (void)enqueueForeground:(dispatch_block_t)block
{
	dispatch_async( _foreQueue, block );
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

#pragma mark-Background
+ (void)enqueueBackground:(dispatch_block_t)block
{
	return [[XYGCD sharedInstance] enqueueBackground:block];
}

- (void)enqueueBackground:(dispatch_block_t)block
{
	dispatch_async( _backQueue, block );
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

#pragma mark-BackgroundIOFile
+ (void)enqueueBackgroundIOFile:(dispatch_block_t)block
{
    return [[XYGCD sharedInstance] enqueueBackgroundIOFile:block];
}

- (void)enqueueBackgroundIOFile:(dispatch_block_t)block
{
    dispatch_async( _backIOFileQueue, block );
}

+ (void)enqueueBackgroundIOFileWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    [[XYGCD sharedInstance] enqueueBackgroundIOFileWithDelay:ms block:block];
}

- (void)enqueueBackgroundIOFileWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
    dispatch_after( time, _backIOFileQueue, block );
}

#pragma mark-
- (XY_GCD_block)MAIN
{
    XY_GCD_block block = ^XYGCD * ( dispatch_block_t block )
    {
        [self enqueueForeground:block];
        return self;
    };
    
    return block;
}

- (XY_GCD_block)FORK
{
    XY_GCD_block block = ^XYGCD * ( dispatch_block_t block )
    {
        [self enqueueBackground:block];
        return self;
    };
    
    return block;
}

- (XY_GCD_block)FORK_IO_FILE
{
    XY_GCD_block block = ^XYGCD * ( dispatch_block_t block )
    {
        [self enqueueBackgroundIOFile:block];
        return self;
    };
    
    return block;
}

@end

