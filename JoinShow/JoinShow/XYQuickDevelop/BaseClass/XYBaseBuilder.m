//
//  XYBaseBuilder.m
//  JoinShow
//
//  Created by heaven on 14/12/4.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYBaseBuilder.h"

@interface XYBaseBuilder ()

//@property (nonatomic, copy) NSString *clazzName;
@property (nonatomic, strong) Class clazz;

@end


@implementation XYBaseBuilder

+ (id)builderWithClass:(Class)clazz
{
    XYBaseBuilder *builder = [[self alloc] init];
    builder.clazz = clazz;
    
    return builder;
}

+ (id)builderWithClassName:(NSString *)clazzName
{
    XYBaseBuilder *builder = [[self alloc] init];
    builder.clazz = NSClassFromString(clazzName);
    
    return builder;
}


- (id)build
{
    if (_clazz == nil)
        return nil;
    
    id anObject = [[_clazz alloc] init];
    [self buildAnObject:anObject];
    
    return anObject;
}

- (id)buildAnObject:(id)anObject
{
    return anObject;
}

@end
