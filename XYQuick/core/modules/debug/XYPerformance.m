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
//  This file Copy from bee Framework.

#import "XYPerformance.h"

#pragma mark -

@interface XYPerformance()
{

}
@property (nonatomic, strong) NSMutableDictionary *tags;
@end

#pragma mark -

@implementation XYPerformance uxy_def_singleton(XYPerformance)

- (id)init
{
    self = [super init];
    if ( self )
    {
        _tags = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)enter:(NSString *)tag
{
    NSNumber * time = [NSNumber numberWithDouble:CACurrentMediaTime()];
    NSString * name = [NSString stringWithFormat:@"%@ enter", tag];
    
    [_tags setObject:time forKey:name];
}

- (void)leave:(NSString *)tag
{
    @autoreleasepool
    {
        NSString * name1 = [NSString stringWithFormat:@"%@ enter", tag];
        NSString * name2 = [NSString stringWithFormat:@"%@ leave", tag];
        
        CFTimeInterval time1 = [[_tags objectForKey:name1] doubleValue];
        CFTimeInterval time2 = CACurrentMediaTime();
        
        [_tags removeObjectForKey:name1];
        [_tags removeObjectForKey:name2];
        
        [self recordName:tag andTime:fabs(time2 - time1)];
    }
}

- (void)recordName:(NSString *)name andTime:(NSTimeInterval)time
{
	NSLog( @"Time '%@' = %.4f(s)", name, time );
}

@end