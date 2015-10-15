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

#import "NSArray+XY.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

static const void *__XYRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void __XYReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

@implementation NSArray(XYExtension)

- (NSArray *)uxy_head:(NSUInteger)count
{
	if ( [self count] < count )
	{
		return self;
	}
    else
	{
		NSMutableArray * tempFeeds = [NSMutableArray array];
		for ( NSObject * elem in self )
		{
			[tempFeeds addObject:elem];
			if ( [tempFeeds count] >= count )
				break;
		}
        
		return tempFeeds;
	}
}

- (NSArray *)uxy_tail:(NSUInteger)count
{
	return [self subarrayWithRange:NSMakeRange( self.count - count, count )];
}

- (id)uxy_safeObjectAtIndex:(NSInteger)index
{
	if ( index < 0 )
		return nil;
	
	if ( index >= self.count )
		return nil;

	return [self objectAtIndex:index];
}

- (NSArray *)uxy_safeSubarrayWithRange:(NSRange)range
{
	if ( 0 == self.count )
		return nil;

	if ( range.location >= self.count )
		return nil;

	if ( range.location + range.length > self.count )
		return nil;
	
	return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSArray *)uxy_safeSubarrayFromIndex:(NSUInteger)index
{
    if ( 0 == self.count )
        return [NSArray array];
    
    if ( index >= self.count )
        return [NSArray array];
    
    return [self uxy_safeSubarrayWithRange:NSMakeRange(index, self.count - index)];
}

- (NSArray *)uxy_safeSubarrayWithCount:(NSUInteger)count
{
    if ( 0 == self.count )
        return [NSArray array];
    
    return [self uxy_safeSubarrayWithRange:NSMakeRange(0, count)];
}

- (NSInteger)uxy_indexOfString:(NSString *)string
{
    if (string == nil || string.length < 1)
    {
        return NSNotFound;
    }
    if (self.count == 0)
    {
        return NSNotFound;
    }
    
    for (int i = 0; i < self.count; i++)
    {
        if ([string isEqualToString:self[i]])
        {
            return i;
        }
    }
    
    return NSNotFound;
}

@end


#pragma mark -

@implementation NSMutableArray(XYExtension)

- (void)uxy_safeAddObject:(id)anObject
{
    if ( anObject )
    {
        [self addObject:anObject];
    }
}

+ (NSMutableArray *)uxy_nonRetainingArray
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain           = __XYRetainNoOp;
    callbacks.release          = __XYReleaseNoOp;
    
    return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, &callbacks);
}

- (NSMutableArray *)uxy_pushHead:(NSObject *)obj
{
	if ( obj )
	{
		[self insertObject:obj atIndex:0];
	}
	
	return self;
}

- (NSMutableArray *)uxy_pushHeadN:(NSArray *)all
{
	if ( [all count] )
	{	
		for ( NSUInteger i = [all count]; i > 0; --i )
		{
			[self insertObject:[all objectAtIndex:i - 1] atIndex:0];
		}
	}
	
	return self;
}

- (NSMutableArray *)uxy_popTail
{
	if ( [self count] > 0 )
	{
		[self removeObjectAtIndex:[self count] - 1];
	}
	
	return self;
}

- (NSMutableArray *)uxy_popTailN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = n;
			range.length = [self count] - n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)uxy_pushTail:(NSObject *)obj
{
	if ( obj )
	{
		[self addObject:obj];		
	}
	
	return self;
}

- (NSMutableArray *)uxy_pushTailN:(NSArray *)all
{
	if ( [all count] )
	{
		[self addObjectsFromArray:all];		
	}
	
	return self;
}

- (NSMutableArray *)uxy_popHead
{
	if ( [self count] )
	{
		[self removeLastObject];
	}
	
	return self;
}

- (NSMutableArray *)uxy_popHeadN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = 0;
			range.length = n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)uxy_keepHead:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = n;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (NSMutableArray *)uxy_keepTail:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = 0;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

@end

