//
//  XYObserve.h
//  JoinShow
//
//  Created by Heaven on 13-11-6.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYObserve : NSObject

+(instancetype) observerWithObject:(id)object keyPath:(NSString *)keyPath target:(id)target selector:(SEL)selector;

-(id) initWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector;

@end
