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

#import "XYUnitTest.h"
#import "XYRuntime.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	MAX_UNITTEST_LOGS
#define	MAX_UNITTEST_LOGS	(100)

#pragma mark -

@implementation XYTestFailure


+ (XYTestFailure *)expr:(const char *)expr file:(const char *)file line:(int)line
{
    XYTestFailure *failure = [[XYTestFailure alloc] initWithName:@"XYUnitTest" reason:@(expr) userInfo:nil];
    failure.expr = @(expr);
    failure.file = [@(file) lastPathComponent];
    failure.line = line;
    return failure;
}

@end

#pragma mark -

@implementation XYTestCase
@end

#pragma mark -

@interface XYUnitTest ()
@property (nonatomic, strong) NSMutableArray *logs;
@end

@implementation XYUnitTest uxy_def_singleton(XYUnitTest)


#if (1 == __XY_DEBUG_UNITTESTING__)
/*
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:[XYUnitTest sharedInstance]
                                                 selector:@selector(__after_application_didFinishLaunchingWithOptions)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    });
}
 */

/*
 * 1. 调用所有的Framework中的初始化方法
 * 2. 调用所有的+load方法, runtime调用 +(void)load的时候, 程序还没有建立其autorelease pool
 * 3. 调用C++的静态初始化方及C/C++中的__attribute__(constructor)函数
 * 4. 调用所有链接到目标文件的framework中的初始化方法
 */
__attribute__((constructor)) static void registerUnitTestStart()
{
    [[NSNotificationCenter defaultCenter] addObserver:[XYUnitTest sharedInstance]
                                             selector:@selector(__handleApplicationDidFinishLaunchingWithOptions)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}
#endif

- (id)init
{
    self = [super init];
    if ( self )
    {
        _logs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    _logs = nil;
}

- (void)run
{
    fprintf( stderr, "  //  __  __          ____           _          _\n" );
    fprintf( stderr, "  //  \\ \\/ / /\\_/\\   /___ \\  _   _  (_)   ___  | | __\n" );
    fprintf( stderr, "  //   \\  /  \\_ _/  //  / / | | | | | |  / __| | |/ /\n" );
    fprintf( stderr, "  //   /  \\   / \\  / \\_/ /  | |_| | | | | (__  |   <\n" );
    fprintf( stderr, "  //  /_/\\_\\  \\_/  \\___,_\\   \\__,_| |_|  \\___| |_|\\_\\\n" );
    fprintf( stderr, "  //\n" );
    fprintf( stderr, "  //  Verson: %s. Copyright (C) Heaven.\n", __XYQUICK_VERSION__ );
    fprintf( stderr, "  //  https://github.com/uxyheaven/XYQuick\n" );
    fprintf( stderr, "  \n" );
    fprintf( stderr, "  =============================================================\n" );
    fprintf( stderr, "   Unit testing ...\n" );
    fprintf( stderr, "  -------------------------------------------------------------\n" );
    
    NSArray *	classes = [XYTestCase uxy_subClasses];

    CFTimeInterval beginTime = CACurrentMediaTime();
    
    for ( NSString * className in classes )
    {
        Class classType = NSClassFromString( className );
        
        if ( nil == classType )
            continue;
        
        NSString * testCaseName;
        testCaseName = [classType description];
        testCaseName = [testCaseName stringByReplacingOccurrencesOfString:@"__TestCase__" withString:@"  TEST_CASE( "];
        testCaseName = [testCaseName stringByAppendingString:@" )"];
        
        NSString * formattedName = [testCaseName stringByPaddingToLength:48 withString:@" " startingAtIndex:0];
        
        
        fprintf( stderr, "%s", [formattedName UTF8String] );
        
        CFTimeInterval time1 = CACurrentMediaTime();
        
        BOOL testCasePassed = YES;
        
        //	@autoreleasepool
        {
            @try
            {
                XYTestCase * testCase = [[classType alloc] init];
                
                NSArray * selectorNames = [classType uxy_methodsWithPrefix:@"runTest_"];
                
                if ( selectorNames && [selectorNames count] )
                {
                    for ( NSString * selectorName in selectorNames )
                    {
                        SEL selector = NSSelectorFromString( selectorName );
                        if ( selector && [testCase respondsToSelector:selector] )
                        {
                            NSMethodSignature * signature = [testCase methodSignatureForSelector:selector];
                            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                            
                            [invocation setTarget:testCase];
                            [invocation setSelector:selector];
                            [invocation invoke];
                        }
                    }
                }
            }
            @catch ( NSException * e )
            {
                if ( [e isKindOfClass:[XYTestFailure class]] )
                {
                    XYTestFailure * failure = (XYTestFailure *)e;
                    [self writeLog:@"%@ @ %@ (#%d)", failure.expr, failure.file, failure.line];
                }
                else
                {
                    [self writeLog:@"Unknown exception '%@'", e.reason];
                    [self writeLog:@"%@", e.callStackSymbols];
                }
                
                testCasePassed = NO;
            }
            @finally
            {
            }
        };
        
        CFTimeInterval time2 = CACurrentMediaTime();
        CFTimeInterval time = time2 - time1;
        
        
        if ( testCasePassed )
        {
            _succeedCount += 1;
            
            fprintf( stderr, "[ OK ]   %.003fs\n", time );
        }
        else
        {
            _failedCount += 1;
            
            fprintf( stderr, "[FAIL]   %.003fs\n", time );
        }
        
        [self flushLog];
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    float passRate = (_succeedCount * 1.0f) / ((_succeedCount + _failedCount) * 1.0f) * 100.0f;
    
    fprintf( stderr, "  -------------------------------------------------------------\n" );
    fprintf( stderr, "  Total %lu cases                               [%.0f%%]   %.003fs\n", (unsigned long)[classes count], passRate, totalTime );
    fprintf( stderr, "  =============================================================\n" );
    fprintf( stderr, "\n" );
}

- (void)writeLog:(NSString *)format, ...
{
    if ( _logs.count >= MAX_UNITTEST_LOGS )
    {
        return;
    }
    
    if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
        return;
    
    va_list args;
    va_start( args, format );
    
    @autoreleasepool
    {
        NSMutableString * content = [[NSMutableString alloc] initWithFormat:(NSString *)format arguments:args];
        [_logs addObject:content];
    };
    
    va_end( args );
}

- (void)flushLog
{
    if ( _logs.count )
    {
        for ( NSString * log in _logs )
        {
            fprintf( stderr, "       %s\n", [log UTF8String] );
        }
        
        if ( _logs.count >= MAX_UNITTEST_LOGS )
        {
            fprintf( stderr, "       ...\n" );
        }
        
        fprintf( stderr, "\n" );
    }
    
    [_logs removeAllObjects];
}

#if (1 == __XY_DEBUG_UNITTESTING__)
- (void)__handleApplicationDidFinishLaunchingWithOptions
{
    [[XYUnitTest sharedInstance] run];
}
#endif
@end

#pragma mark -
#if (1 == __XY_DEBUG_UNITTESTING__)
// ----------------------------------
// Unit test
// ----------------------------------
#import "XYUnitTest.h"

UXY_TEST_CASE( Core, UnitTest )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test1 )
{
  //  UXY_EXPECTED( 1 == 1 );
  //  UXY_EXPECTED( [@"123" isEqualToString:@"123"] );
}

UXY_DESCRIBE( test2 )
{
  //  UXY_EXPECTED( 1 == 1 );
  //  UXY_EXPECTED( [@"123" isEqualToString:@"123"] );
}

UXY_DESCRIBE( test3 )
{
   // UXY_EXPECTED( [@"123" isEqualToString:@"123456"] );
}

UXY_TEST_CASE_END
#endif
