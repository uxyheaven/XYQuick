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
//  This file Copy from Samurai.

#import "XYThread.h"

#pragma mark -

@interface XYGCD()

@property (nonatomic, strong) dispatch_queue_t foreQueue;
@property (nonatomic, strong) dispatch_queue_t backSerialQueue;
@property (nonatomic, strong) dispatch_queue_t backConcurrentQueue;
@property (nonatomic, strong) dispatch_queue_t writeFileQueue;

@end

@implementation XYGCD

static id __singleton__objc__token;
static dispatch_once_t __singleton__token__token;
+ (instancetype)sharedInstance
{
    dispatch_once(&__singleton__token__token, ^{ __singleton__objc__token = [[self alloc] init]; });
    return __singleton__objc__token;
}

+ (void)purgeSharedInstance
{
    __singleton__objc__token  = nil;
    __singleton__token__token = 0;
}

- (id)init
{
	self = [super init];
	if ( self )
	{
        _foreQueue           = dispatch_get_main_queue();
        _backSerialQueue     = dispatch_queue_create( "com.XY.backSerialQueue", DISPATCH_QUEUE_SERIAL );
        _backConcurrentQueue = dispatch_queue_create( "com.XY.backConcurrentQueue", DISPATCH_QUEUE_CONCURRENT );
        _writeFileQueue      = dispatch_queue_create( "com.XY.writeFileQueue", DISPATCH_QUEUE_SERIAL );
	}
	
	return self;
}

+ (dispatch_time_t)seconds:(CGFloat)f
{
    return dispatch_time( DISPATCH_TIME_NOW, f * 1ull * NSEC_PER_SEC );
}
@end


