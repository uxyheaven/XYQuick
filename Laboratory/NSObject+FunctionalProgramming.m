//
//  NSObject+FunctionalProgramming.m
//  JoinShow
//
//  Created by XingYao on 15/10/13.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "NSObject+FunctionalProgramming.h"

#undef $
#define $ NSObject

// Block internals.
typedef NS_OPTIONS(int, XYBlockFlags) {
    XYBlockFlagsHasCopyDisposeHelpers = (1 << 25),
    XYBlockFlagsHasSignature          = (1 << 30)
};
typedef struct _XYBlockRef {
    __unused Class isa;
    XYBlockFlags flags;
    __unused int reserved;
    void (__unused *invoke)(struct _XYBlockRef *block, ...);
    struct {
        unsigned long int reserved;
        unsigned long int size;
        // requires AspectBlockFlagsHasCopyDisposeHelpers
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        // requires AspectBlockFlagsHasSignature
        const char *signature;
        const char *layout;
    } *descriptor;
    // imported variables
} *XYBlockRef;

static NSMethodSignature *uxy_blockMethodSignature(id block)
{
    if (!block)
    {
        return nil;
    }
    
    XYBlockRef layout = (__bridge void *)block;
    if (!(layout->flags & XYBlockFlagsHasSignature))
    {
        // The block %@ doesn't contain a type signature.
        return nil;
    }
    void *desc = layout->descriptor;
    desc += 2 * sizeof(unsigned long int);
    if (layout->flags & XYBlockFlagsHasCopyDisposeHelpers) {
        desc += 2 * sizeof(void *);
    }
    if (!desc)
    {
        // The block %@ doesn't has a type signature.
        return nil;
    }
    const char *signature = (*(const char **)desc);
    return [NSMethodSignature signatureWithObjCTypes:signature];
}

INLINE static BOOL and(id spec, ...)
{
    va_list args;
    va_start( args, spec );

    for ( ;; )
    {
        id tempSpec = va_arg( args,  id );
        if (tempSpec == nil)
            break;
    }
    va_end( args );
    
    return YES;
}

static BOOL testaa(id spec)
{
    NSLog(@"%@", spec);
    
    return YES;
}

@implementation NSObject (FunctionalProgramming)

+ (BOOL)AND:(id)spec, ...
{
    va_list args;
    va_start( args, spec );
    
    for ( ;; )
    {
        id tempSpec = va_arg( args, id );
        if (tempSpec == nil)
            break;
    }
    va_end( args );
    
    return YES;
}

+ (BOOL (^)())$blockAnd
{
    BOOL (^block)() = ^ BOOL (){
        return YES;
    };
    return block;
}


+ (int (^)())blockTest
{
    int (^block)() = ^ int (){
        NSMethodSignature *sig = uxy_blockMethodSignature(block);
        return 3;
    };
    return block;
}

+ (void)showBlock:(id)block
{
    NSMethodSignature *sig = uxy_blockMethodSignature(block);
}
@end

/*
#pragma mark -
// ----------------------------------
// Unit test
// ----------------------------------
#if (1 == __XY_DEBUG_UNITTESTING__)
#import "XYUnitTest.h"

UXY_TEST_CASE( Test, FP )
{
}

UXY_DESCRIBE( test_1 )
{
    NSObject *objc = [[NSObject alloc] init];
   // [NSObject AND:objc];
   // [NSObject AND:objc];
  //  [$ AND:objc];
}

UXY_DESCRIBE( test_2 )
{
    NSObject *objc = [[NSObject alloc] init];
    NSObject.$blockAnd(objc, objc);
    NSObject.blockTest(objc);
    NSObject.blockTest(objc, objc);
}

UXY_DESCRIBE( test_3 )
{
    NSObject *objc = [[NSObject alloc] init];
//  and(objc);
//  testaa(objc);
}

UXY_DESCRIBE( test_4 )
{
    NSObject *objc = [[NSObject alloc] init];
    //    $and(objc);
    BOOL (^block)() = ^ BOOL (){
        return YES;
    };
    [NSObject showBlock:block];
    
    BOOL (^block2)(id, id) = ^ BOOL (id a, id b){
        return YES;
    };
    
    [NSObject showBlock:block2];
}

UXY_TEST_CASE_END
 
#endif
*/

