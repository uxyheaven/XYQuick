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
@property (nonatomic, strong) id object;

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

+ (id)productWithClass:(Class)clazz builder:(void(^)(id builder))block
{
    NSParameterAssert(clazz);
    NSParameterAssert(block);
    
    XYBaseBuilder *builder = [[self alloc] init];
    builder.clazz = clazz;
    block(builder);
    
    return [builder build];
}

+ (id)productWithBuilder:(id(^)(id builder))block
{
    NSParameterAssert(block);
    
    XYBaseBuilder *builder = [[self alloc] init];
    builder.object = block(builder);
    
    return [builder build];
}
- (id)build
{
    id anObject = _object ?: [[_clazz alloc] init];
    
    return anObject;
}


@end

/*
 @implementation NSObject (UXYBuilder)
 
 + (id)objectWithUXYBuilder:(void(^)(id builder))block
 {
 XYBaseBuilder *builder = [[self alloc] init];
 builder.clazz = self;
 block(builder);
 
 return [builder build];
 }
 @end
 */





