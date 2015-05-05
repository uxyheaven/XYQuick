//
//  EntityModel.m
//  JoinShow
//
//  Created by Heaven on 13-12-10.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "EntityBaseModel.h"
#import "XYQuickDevelop.h"
#import "XYExternal.h"

@interface EntityBaseModel ()

@property (nonatomic, strong) NSMutableArray *array;                            // array
@property (nonatomic, strong) NSMutableDictionary *dic;                         // dic

@end

@implementation EntityBaseModel

//DEF_SINGLETON(EntityModel)

- (id)init
{
    self = [super init];
    if (self) {
        self.dbHelper = [[self class] getUsingLKDBHelper];

        self.array = [NSMutableArray array];
        self.dic = [NSMutableDictionary dictionary];
    }
    return self;
}
+(id) modelWithClass:(Class)aClass{
    EntityBaseModel *aModel = [[[self class] alloc] init];
    
    aModel.dataClass = aClass;
    aModel.dbHelper = [[aClass class] getUsingLKDBHelper];
    //      [dbHelper dropAllTable];
    [aModel.dbHelper createTableWithModelClass:[aClass class]];
    
    return aModel;
}


- (void)dealloc
{
    NSLogDD
    [self.requestHelper cancelAllOperations];
}




#pragma mark - 子类重载下面的方法

- (void)addObject:(id)anObject{
    [anObject saveToDB];
    
    [self willChangeValueForKey:@"array" ];
    [self.array addObject:anObject];
    [self didChangeValueForKey:@"array"];
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [anObject saveToDB];
    
    [self willChangeValueForKey:@"array"];
    [self.array insertObject:anObject atIndex:index];
    [self didChangeValueForKey:@"array"];
}
- (void)removeLastObject{
    id anObject = [self.array lastObject];
    [anObject deleteToDB];
    
    [self willChangeValueForKey:@"array"];
    [self.array removeLastObject];
    [self didChangeValueForKey:@"array"];
}
- (void)removeObjectAtIndex:(NSUInteger)index{
    id anObject = [self.array objectAtIndex:index];
    [anObject deleteToDB];
    
    [self willChangeValueForKey:@"array"];
    [self.array removeObjectAtIndex:index];
    [self didChangeValueForKey:@"array"];
}

@end







