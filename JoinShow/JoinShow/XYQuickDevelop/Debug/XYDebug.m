//
//  XYDebug.m
//  JoinShow
//
//  Created by Heaven on 13-12-9.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "XYDebug.h"
#import "XYFoundation.h"

static void (*__sendEvent)( id, SEL, UIEvent * );

@interface UIWindow(XYDebugPrivate)
- (void)mySendEvent:(UIEvent *)event;
@end

@implementation UIWindow(XYDebug)
+(void) load{
#if (1 == __XYDEBUG__showborder__)
    [UIWindow hook];
#endif
}

+(void) hook
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
						[border release];
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
	[super dealloc];
}

@end





