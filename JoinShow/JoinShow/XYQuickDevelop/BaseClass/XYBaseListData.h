//
//  XYBaseListData.h
//  JoinShow
//
//  Created by Heaven on 14-8-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#pragma mark - 未完成,暂别使用
/*
 说明：
 （1）对于“从服务器批量拉取数据并以列表的界面形式呈现数据”这种模式，本类的作用就是以数组形式管理数据，统一封装数据的拉取删除等一系列操作，使得界面模块可以完全不必处理这些繁琐细致的逻辑。
 （2）XYBaseListData作为基类，抽象地完成数据的管理工作，包括数据去重、拉取到指定数量的数据、检测本地数据与服务器数据是否同步，删除数据同步等等。XYBaseListData不关心数据的具体类型（因为根本就不需要关心），它总是以数组形式组织数据。也因此，实际的数据拉取删除操作需要委托给子类去实现，基类只定义了接口。
 （3）在使用XYBaseListData时，要注意操作的串行性，当前一个操作没有返回时，除非取消当前的操作，否则不要执行下一个操作，会直接返回失败的。实际的应用场景也是如此的，界面上的用户交互都是定义为串行的。
 */

#import <Foundation/Foundation.h>

//定义XYBaseListData执行操作的类型
typedef NS_ENUM(NSInteger, XYBaseListDataOperation) {
    XYBaseListDataOperationNone = 0,        // 标示目前没有执行中的操作
    XYBaseListDataOperationReload,          // 重新刷新加载
    XYBaseListDataOperationLoadMore,        // 加载更多
    XYBaseListDataOperationRemove,          // 删除
};

typedef void(^XYBaseListData_block_removeData)(NSArray *, NSArray *);

@protocol XYBaseListDataDelegate;

@interface XYBaseListData : NSObject


@property (nonatomic, readonly) BOOL isAvailable;       // 当XYBaseListDataOperation没有执行任何操作时，此值为YES
@property (nonatomic, readonly) BOOL isAllDataLoaded;   // 当前数据是否已经加载至底
@property (nonatomic, readonly) XYBaseListDataOperation currentOperation; // XYBaseListDataOperation当前执行的操作类型
@property (nonatomic, strong, readonly) NSArray *data;          // 通过data属性访问所有被管理的数据
@property (nonatomic, weak) id<XYBaseListDataDelegate> delegate;

// 请重写以下方法
// 单个数据的key, 要保证能够唯一的区分数据
-(NSString *) keyForObject:(id)anObject;
// 定义数据的排序规则
-(NSComparisonResult) compareObject:(id)firstObject withObject:(id)secendObject;
// 加载数据的实际操作
-(void) loadDataOperationWithRange:(NSRange)range;
// 删除数据的实际操作
-(void) removeDataOperation:(NSArray *)array;

// 此方法需要子类在重写的 loadDataWithRange:, removeData: 里主动调用,
// 数据实际操作完成时，通过该函数传递给 XYBaseListData 进行管理
-(void) finishOperationWithArray:(NSArray *)array;

//Public方法：
// 初始化
-(id) initWithDelegate:(id<XYBaseListDataDelegate>)delegate;
// 重新加载数据
-(BOOL) reloadDataWithCount:(NSInteger)count;
// 加载更多数据
-(BOOL) loadMoreDataWithCount:(NSInteger)count;
// 删除数据
-(BOOL) removeData:(NSArray *)data;
// 重置XYBaseListData，将已缓存的数据清除
-(void) resetCache;
// 取消当前的操作
-(void) stopCurrentOperation;

@end

@protocol XYBaseListDataDelegate <NSObject>
@required
-(void) listData:(XYBaseListData *)dataCache didFinishOperation:(XYBaseListDataOperation)operation data:(NSArray *)array;
-(void) listDataNeedReloadData:(XYBaseListData *)dataCache;
@end



