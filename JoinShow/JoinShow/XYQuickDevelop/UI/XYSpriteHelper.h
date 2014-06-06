//
//  SpriteHelper.h
//
//  Created by Heaven on 13-5-15.
//
//

#define XYSpriteHelper_interval      1.0/12.0
#define XYSpriteHelper_timer         @"XYSprite"


#import "XYPrecompile.h"
#import "XYUI.h"
#import "XYFoundation.h"

@interface XYSpriteHelper : NSObject{
}

AS_SINGLETON(XYSpriteHelper)

// 采用统一的定时器来刷新 sprite
@property (nonatomic, readonly, strong) NSTimer                     *timer;
@property (nonatomic, assign) NSTimeInterval                        interval;       // 定时器间隔
@property (nonatomic, readonly, strong) NSMutableDictionary         *sprites;       // 精灵

-(void) startTimer;      // 开期定时器
-(void) pauseTimer;
-(void) stopTimer;


-(void) startAllSprites;
-(void) stopAllSprites;
-(void) clearAllSprites;    // 从画面上移除所有的精灵, 清空sprites.
@end
