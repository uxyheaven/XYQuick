//  Created by Heaven on 13-4-3.
//
//

#pragma mark -todo 整理后废弃

#define XYAnimationView_state_start 1
#define XYAnimationView_state_pause 2
#define XYAnimationView_state_resume 4
#define XYAnimationView_state_reset 2
#define XYAnimationView_state_stop 5


#import <UIKit/UIKit.h>
#import "XYPrecompile.h"

@interface XYAnimationView : UIImageView<UIGestureRecognizerDelegate>{

}

@property (nonatomic, retain) NSMutableArray    *imagesNameArray;      //图片路径
@property (nonatomic, assign) int               currentImageIndex;             //  当前帧数
@property (nonatomic, assign) int               repeatcount;            //  循环次数
@property (nonatomic, assign) int               currentRepeatCount;     // 当前循环次数
@property (nonatomic, assign) NSTimeInterval    durationTime;           // 持续时间
@property (nonatomic, assign) int               continueFrames;             // 当前总帧数
@property (nonatomic, assign) int               timerCount;             // 定时器数
@property (nonatomic, assign) int               state;                  //  状态
@property (nonatomic, assign) int               type;                   // 动画类型
@property (nonatomic, assign) BOOL              isLRTransform;           // 左右反转
@property (nonatomic ,assign) BOOL              isTBTransform;            // 上下反转
@property (nonatomic, assign) int               frequency;    // 频率   暂保留
@property (nonatomic, assign) UIView            *master;       // supview
@property (nonatomic, assign) NSTimeInterval    delay;          // 延时
@property (nonatomic, assign) NSTimeInterval    wait;           // 等待



- (void)imagesPath:(NSString *)imagesPath repeatCount:(NSUInteger)repeatCount;
- (void)imagesPath:(NSString *)imagesPath repeatCount:(NSUInteger)repeatCount delay:(NSTimeInterval)d wait:(NSTimeInterval)w;

// 更新下一张图片
- (void)updateImage;
// 待 拆分
- (void)setState:(int)s;

// 手势
#pragma mark -todo, 手势
// 轻击手势
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
-(void)addGestureTap;

// 捏合手势
@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGesture;
-(void)addGesturePinch;

// 平移手势
@property (nonatomic, retain) UIPanGestureRecognizer *panGesture;
-(void)addGesturePan;

// 长按手势
@property (nonatomic, retain) UILongPressGestureRecognizer *longGesture;
-(void)addGestureLong;

// 轻扫手势
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGesture;
-(void)addGestureSwipe;

// 转动手势
@property (nonatomic, retain) UIRotationGestureRecognizer *rotationGesture;
-(void)addGestureRotation;



@end
