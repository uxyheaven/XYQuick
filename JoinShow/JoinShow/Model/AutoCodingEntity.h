//
//  AutoCodingEntity.h
//  JoinShow
//
//  Created by Heaven on 14/10/31.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AutoCodingEntityOther;

@interface AutoCodingEntityList : NSObject

@property (nonatomic, strong) NSMutableArray *array;

@end


@interface AutoCodingEntityBase : NSObject

@property (nonatomic, copy) NSString *str;
@property (nonatomic, assign) float f;

@end


@interface AutoCodingEntity : AutoCodingEntityBase

@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, assign) int i;
@property (nonatomic, assign) BOOL b;

@property (nonatomic, strong) AutoCodingEntityOther *objc;

@end


@interface AutoCodingEntityOther : NSObject

@property (nonatomic, assign) int i;

@end

