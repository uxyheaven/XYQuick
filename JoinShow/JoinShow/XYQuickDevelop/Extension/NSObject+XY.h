//
//  NSObject+XY.h
//  JoinShow
//
//  Created by Heaven on 13-7-31.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XY)
#pragma mark -todo 拆分参数
//@property (nonatomic, assign) BOOL isHookDealloc;

////////////////////////  perform  ////////////////////////
// 目前只支持添加一个随机时间执行
-(void) performSelector:(SEL)aSelector target:(id)target mark:(id)mark afterDelay:(NSTimeInterval(^)(void))aBlockTime loop:(BOOL)loop isRunNow:(BOOL)now;

-(void) performBlock:(void(^)(void))aBlock mark:(id)mark afterDelay:(NSTimeInterval(^)(void))aBlockTime loop:(BOOL)loop isRunNow:(BOOL)now;
//-(void) removePerformWithMark:(NSString *)mark;
-(void) removePerformRandomDelay;

////////////////////////  NSNotificationCenter  ////////////////////////
// source : 表示接收哪个发送者的通知，如果第为nil,接收所有发送者的通知
-(void) registerMessage:(NSString*)aMsg selector:(SEL)aSel source:(id)source;
-(void) unregisterMessage:(NSString*)aMsg;
-(void) unregisterAllMessage;
-(void) sendMessage:(NSString *)aMsg withObject:(NSObject *)object;

/*
 - (void) function: (NSNotification*) notification;
 */

////////////////////////  KVO  ////////////////////////
#pragma mark -todo

////////////////////////  property  ////////////////////////
// 属性列表
@property (nonatomic, readonly) NSArray                *attributeList;


////////////////////////  Conversion  ////////////////////////
- (NSInteger)asInteger;
- (float)asFloat;
- (BOOL)asBool;

- (NSNumber *)asNSNumber;
- (NSString *)asNSString;
- (NSDate *)asNSDate;
- (NSData *)asNSData;	// TODO
- (NSArray *)asNSArray;
//- (NSArray *)asNSArrayWithClass:(Class)clazz;
- (NSMutableArray *)asNSMutableArray;
- (NSMutableArray *)asNSMutableArrayWithClass:(Class)clazz;
- (NSDictionary *)asNSDictionary;
- (NSMutableDictionary *)asNSMutableDictionary;

@end
