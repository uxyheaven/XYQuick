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

#import "XYDebugToy.h"
#import "XYRuntime.h"
#import <execinfo.h>
#import <objc/runtime.h>

#undef	XYDebug_key_hookDealloc
#define XYDebug_key_hookDealloc	"XYDebug.hookDealloc"

#pragma mark - XYDebugToy
@interface XYWatcher : NSObject
@property (nonatomic ,copy) NSString *stringDealloc;
@end

@implementation XYWatcher
- (void)dealloc
{
    NSLog(@"%@", _stringDealloc);
}
@end

@implementation XYDebugToy

+ (void)hookObject:(id)anObject whenDeallocLogString:(NSString *)string
{
    XYWatcher *watcher = [[XYWatcher alloc] init];
    watcher.stringDealloc = string;
    objc_setAssociatedObject(anObject, XYDebug_key_hookDealloc, watcher, OBJC_ASSOCIATION_RETAIN);
}

// Recursively travel down the view tree, increasing the indentation level for children
+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring
{
    for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
    
    [outstring appendFormat:@"[%2d] %@\n tag:%ld frame:%@\n", indent, [[aView class] description], (long)aView.tag, NSStringFromCGRect(aView.frame)];
    
    for (UIView *view in [aView subviews]) [self dumpView:view atIndent:indent + 1 into:outstring];
}
// Start the tree recursion at level 0 with the root view
+ (NSString *)displayViews:(UIView *)aView
{
    NSMutableString *outstring = [[NSMutableString alloc] init];
    [self dumpView:aView atIndent:0 into:outstring];
    return outstring;
}
@end



#pragma mark - XYDebug

#define UXY_KB	(1024)
#define UXY_MB	(UXY_KB * 1024)
#define UXY_GB	(UXY_MB * 1024)
#define XYDebug_memory_step 20

#undef	MAX_CALLSTACK_DEPTH
#define MAX_CALLSTACK_DEPTH	(64)

@interface XYDebug()

@property (nonatomic, readonly) int64_t manualBytes;
@property (nonatomic, strong) NSMutableArray * manualBlocks;
@end

@implementation XYDebug uxy_def_singleton

+ (void)printCallstack:(NSUInteger)depth
{
    NSArray *callstack = [self callstack:depth];
    if ( callstack && callstack.count )
    {
        NSLog(@"%@", callstack);
    }
}

+ (NSArray *)callstack:(NSUInteger)depth
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    void *stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    
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

+ (void)breakPoint
{
#if defined(__ppc__)
    asm("trap");
#elif defined(__i386__) ||  defined(__amd64__)
    asm("int3");
#endif
}

+ (void)breakPointOnDebug
{
#ifdef DEBUG
    [self breakPoint];
#endif
}
- (void)allocAllMemory
{
    NSProcessInfo *progress  = [NSProcessInfo processInfo];
    unsigned long long total = [progress physicalMemory];
    //	NSUInteger			total = NSRealMemoryAvailable();
    
    for ( ;; )
    {
        if ( _manualBytes + XYDebug_memory_step * UXY_MB >= total )
            break;
        
        void *block = malloc(XYDebug_memory_step * UXY_MB);
        
        if ( block )
        {
            _manualBytes += XYDebug_memory_step * UXY_MB;
            [self.manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
        }
        else
        {
            break;
        }
    }
}

- (void)freeAllMemory
{
    for ( NSNumber *block in self.manualBlocks )
    {
        void *ptr = (void *)[block unsignedLongLongValue];
        free(ptr);
    }
    
    [self.manualBlocks removeAllObjects];
}

- (void)allocMemory:(NSInteger)MB
{
    void *block = malloc(MB * UXY_MB);
    if ( block )
    {
        _manualBytes += MB * UXY_MB;
        [self.manualBlocks addObject:[NSNumber numberWithUnsignedLongLong:(unsigned long long)block]];
    }
}

- (void)freeLastMemory
{
    NSNumber *block = [self.manualBlocks lastObject];
    if ( block )
    {
        void *ptr = (void *)[block unsignedLongLongValue];
        free(ptr);
        
        [self.manualBlocks removeLastObject];
    }
}

#pragma mark - get set
- (NSMutableArray *)manualBlocks
{
    return _manualBlocks ?: (_manualBlocks = [@[] mutableCopy], _manualBlocks);
}

@end

#pragma mark - BorderView
#if (1 == __XY_DEBUG_SHOWBORDER__)
@interface UIWindow(XYDebugPrivate)
- (void)__uxy_sendEvent:(UIEvent *)event;
@end

@implementation UIWindow(XYDebug)

+ (void)load
{
    [XYRuntime swizzleInstanceMethodWithClass:[UIWindow class] originalSel:@selector(sendEvent:) replacementSel:@selector(__uxy_sendEvent:)];
}

- (void)__uxy_sendEvent:(UIEvent *)event
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ( self == keyWindow && UIEventTypeTouches == event.type)
    {
        NSSet *allTouches = [event allTouches];
        if ( 1 == [allTouches count] )
        {
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            if ( 1 == [touch tapCount] && UITouchPhaseBegan == touch.phase )
            {
                // NSLog(@"view '%@', touch began\n%@", [[touch.view class] description], [touch.view description]);
                BorderView *border = [[BorderView alloc] initWithFrame:touch.view.bounds];
                [touch.view addSubview:border];
                [border startAnimation];
            }
        }
    }
    [self __uxy_sendEvent:event];
}

@end


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

#endif




