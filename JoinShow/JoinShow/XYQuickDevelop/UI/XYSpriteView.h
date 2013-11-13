//  Created by Heaven on 13-5-16.
//

#import "XYPrecompile.h"
#import "XYFoundation.h"

// 帧间隔
#define XYSpriteView_aniFrames 12
// 图片资起始编号
#define XYSpriteView_imgStatr 0

typedef enum{
    SpriteStateUndefine = 0,
    SpriteStatePlaying = 1,
    SpriteStatePause = 3,
    SpriteStateStop = 4,
    SpriteStateFinished = 9,
    SpriteStateFailed = 2,
} SpriteState;

@class SpriteInfo;

@protocol XYSpriteDelegate;

@interface XYSpriteView : UIImageView
{
    NSInteger      oneImgTurnCount;      // 一个循环(仅动画)的帧数
    
    NSTimeInterval      curPlayTime;
    NSTimeInterval      curRepeatCount;
    
    int                 allCount;       // 累计总帧数
    NSInteger           fromIndex;
    NSInteger           toIndex;
    
    SpriteState         state;
    
    NSTimeInterval      allTime;    // 持续时间+间隔
    NSTimeInterval      animInterval;      // 帧间隔
    BOOL                isDelayed;
    int                 lastImgIndex;       // 上一张编号,用于优化

}
@property (nonatomic, retain) SpriteInfo *model;

@property (nonatomic, assign) BOOL isTransformLR;       // 左右翻转
@property (nonatomic, assign) BOOL isTransformUD;       // 上下翻转
@property (nonatomic, assign) BOOL isAutoPlay;      // 设置完成后自动播放
@property (nonatomic, assign) BOOL isReverseOrder;  // 反转播放顺序
@property (nonatomic, assign) BOOL isPlayAudio;  // 播放生效

@property (nonatomic, assign) id<XYSpriteDelegate> delegate;
#pragma mark -暂不修改 interval delay
@property (nonatomic, assign, readonly) NSTimeInterval        interval;  // 间隔
@property (nonatomic, assign, readonly) NSTimeInterval        delay;         // 延时

@property (nonatomic, assign) NSTimeInterval        curTime;        // 当前时间
@property (nonatomic, assign) NSTimeInterval        duration;      // 持续时间
@property (nonatomic, assign) NSInteger             repeatCount;        // 重复次数 repeat forever if 0
@property (nonatomic, assign) NSInteger             curImageIndex;
@property (nonatomic, retain) NSMutableArray        *imageNameArray;
@property (nonatomic, copy)   NSString              *aniPath;
@property (nonatomic, assign) int                   firstImgIndex;      // 默认从0开始

// play all asc顺序, if (from == -1) && (to == 0); play all dec降序, if (from == 0) && (to == -1)
#pragma -mark to do  排序
// 蓝色文件夹
/*
- (void) imagesPath:(NSString *)imagesPath repeatCount:(NSUInteger)count fromIndex:(int)from toIndex:(int)to;
- (void) imagesPath:(NSString *)imagesPath repeatCount:(NSUInteger)count;
*/
// if copy 黄色文件夹
-(void) formatImg:(NSString *)format count:(int)count2 repeatCount:(NSUInteger)count;

-(void) showImgWithIndex:(int)index;
-(BOOL) setFromIndex:(int)from toindex:(int)to;

//- (void)duration:(NSTimeInterval)dur interval:(NSTimeInterval)i delay:(NSTimeInterval)d;

#pragma mark - todo
// 更新下一张图片
-(void) updateImage;
 
// 每到时间点刷一次
-(void) updateTimer:(NSTimeInterval)time;

-(void) start;
-(void) pause;
-(void) reset;
-(void) stop;
@end


@protocol XYSpriteDelegate <NSObject>

@optional

-(void) spriteFinished:(XYSpriteView *)aSprite;
//-(void) spriteFailed:(XYSpriteView *)aSprite;
-(void) spriteWillStart:(XYSpriteView *)aSprite;
-(void) spriteDidStop:(XYSpriteView *)aSprite;
-(void) spriteOnIndex:(int)aIndex sprite:(XYSpriteView *)aSprite;

@end


