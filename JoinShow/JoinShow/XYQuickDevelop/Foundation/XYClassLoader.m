//
//  XYClassLoader.m
//  JoinShow
//
//  Created by heaven on 15/4/22.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#import "XYClassLoader.h"

@implementation NSObject(XYClassLoader)

+ (void)classAutoLoad
{
}

@end

@implementation XYClassLoader

+ (instancetype)classLoader
{
    return [[self alloc] init];
}

- (void)loadClasses:(NSArray *)classNames
{
    for ( NSString * className in classNames )
    {
        Class classType = NSClassFromString( className );
        if ( classType )
        {
            fprintf( stderr, "  Loading class '%s'\n", [[classType description] UTF8String] );
            
            NSMethodSignature * signature = [classType methodSignatureForSelector:@selector(classAutoLoad)];
            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            [invocation setTarget:classType];
            [invocation setSelector:@selector(classAutoLoad)];
            [invocation invoke];
            
            //			[classType classAutoLoad];
        }
    }
    
    fprintf( stderr, "\n" );
}


@end
