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

@implementation XYGCD __DEF_SINGLETON

- (id)init
{
	self = [super init];
	if ( self )
	{
        _foreQueue       = dispatch_get_main_queue();
        // 串行队列
        _backQueue       = dispatch_queue_create( "com.XY.taskQueue", DISPATCH_QUEUE_SERIAL );
        // todo dispatch_barrier_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
        _backIOFileQueue = dispatch_queue_create( "com.XY.ioTaskQueue", DISPATCH_QUEUE_SERIAL );
	}
	
	return self;
}

#pragma mark-Foreground


#pragma mark-Background

@end

