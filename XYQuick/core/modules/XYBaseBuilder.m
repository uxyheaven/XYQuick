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





