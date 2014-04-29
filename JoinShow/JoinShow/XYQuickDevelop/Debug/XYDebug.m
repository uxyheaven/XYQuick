//
//  XYDebug.m
//  JoinShow
//
//  Created by Heaven on 13-12-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYDebug.h"
#import "XYFoundation.h"

#undef	MAX_CALLSTACK_DEPTH
#define MAX_CALLSTACK_DEPTH	(64)


static void (*__sendEvent)( id, SEL, UIEvent * );

@interface UIWindow(XYDebugPrivate)
- (void)mySendEvent:(UIEvent *)event;
@end

@implementation UIWindow(XYDebug)
+(void) load{
#if (1 == __XYDEBUG__showborder__)
    [UIWindow hookSendEvent];
#endif
}

+(void) hookSendEvent
{
#if (1 == __XYDEBUG__showborder__)
	static BOOL __swizzled = NO;
	if ( NO == __swizzled )
	{
        Method method = XY_swizzleInstanceMethod([UIWindow class], @selector(sendEvent:), @selector(mySendEvent:));
        __sendEvent = (void *)method_getImplementation( method );
        
        __swizzled = YES;
	}
#endif
}

-(void) mySendEvent:(UIEvent *)event
{
	UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
	if ( self == keyWindow )
	{
		if ( UIEventTypeTouches == event.type )
		{
			NSSet * allTouches = [event allTouches];
			if ( 1 == [allTouches count] )
			{
				UITouch * touch = [[allTouches allObjects] objectAtIndex:0];
				if ( 1 == [touch tapCount] )
				{
					if ( UITouchPhaseBegan == touch.phase )
					{
                       // NSLog(@"view '%@', touch began\n%@", [[touch.view class] description], [touch.view description]);
						BorderView * border = [[BorderView alloc] initWithFrame:touch.view.bounds];
						[touch.view addSubview:border];
						[border startAnimation];
					}
				}
			}
		}
	}
    
    if ( __sendEvent )
    {
        __sendEvent( self, _cmd, event );
    }
}

@end

@implementation XYDebug

+ (void)printCallstack:(NSUInteger)depth
{
	NSArray * callstack = [self callstack:depth];
	if ( callstack && callstack.count )
	{
		NSLog(@"%@", callstack);
	}
}
+ (NSArray *)callstack:(NSUInteger)depth
{
	NSMutableArray * array = [[NSMutableArray alloc] init];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    
	depth = backtrace( stacks, (int)((depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth) );
	if ( depth )
	{
		char ** symbols = backtrace_symbols( stacks, (int)depth );
		if ( symbols )
		{
			for ( int i = 0; i < depth; ++i )
			{
				NSString * symbol = [NSString stringWithUTF8String:(const char *)symbols[i]];
				if ( 0 == [symbol length] )
					continue;
                
				NSRange range1 = [symbol rangeOfString:@"["];
				NSRange range2 = [symbol rangeOfString:@"]"];
                
				if ( range1.length > 0 && range2.length > 0 )
				{
					NSRange range3;
					range3.location = range1.location;
					range3.length = range2.location + range2.length - range1.location;
					[array addObject:[symbol substringWithRange:range3]];
				}
				else
				{
					[array addObject:symbol];
				}
			}
            
			free( symbols );
		}
	}
	
	return array;
}
+(void) breakPoint
{
#if __XY_DEVELOPMENT__
#if defined(__ppc__)
	asm("trap");
#elif defined(__i386__)
	asm("int3");
#endif	// #elif defined(__i386__)
#endif	// #if __BEE_DEVELOPMENT__
}
@end


#pragma mark - BorderView
@implementation BorderView
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.layer.borderWidth = 2.0f;
		self.layer.borderColor = [UIColor redColor].CGColor;
        //		self.textColor = [UIColor redColor];
        //		self.textAlignment = UITextAlignmentCenter;
        //		self.font = [UIFont boldSystemFontOfSize:12.0f];
	}
	return self;
}

- (void)didMoveToSuperview
{
	self.layer.cornerRadius = self.superview.layer.cornerRadius;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:.75f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
    
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

- (void)dealloc
{
}

@end

@implementation NSObject (XYDebug)
/* // 消息转发
// 将选择器转发给一个真正实现了该消息的对象, invocation 保存原始的选择器和被请求的参数
- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    
    if ([self.carInfo respondsToSelector:selector])
    {
        [invocation invokeWithTarget:self.carInfo];
    }
}

// 为另一个类实现的消息创建一个有效的方法签名
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    
    if (!signature)
        signature = [self.carInfo methodSignatureForSelector:selector];
    
    return signature;
}
*/
@end



