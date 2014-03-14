//
//  UIImage+XY.h
//  JoinShow
//
//  Created by Heaven on 13-9-30.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import <UIKit/UIKit.h>
/**************************************************************/
// UIImage
#define LoadImage_cache(_pointer) [UIImage image:_pointer]
#define LoadImage_nocache(file, ext) [UIImage imageWithFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
    
@interface UIImage (XY)

// 加载图片
// used: imageNamed
+(UIImage *) image:(NSString *)resourceName;
// used: imageWithContentsOfFile
+(UIImage *) imageWithFile:(NSString *)path;

+(UIImage *) imageWithString:(NSString *)str;

// 压缩转换
-(UIImage *) transprent;

// 圆形
-(UIImage *) rounded;
// 变成 尺寸circleRect的圆形
-(UIImage *) rounded:(CGRect)circleRect;

// 拉伸
-(UIImage *) stretched;
-(UIImage *) stretched:(UIEdgeInsets)capInsets;

// 灰度
-(UIImage *) grayscale;

//截取部分图像
-(UIImage*) getSubImage:(CGRect)rect;
//等比例缩放
-(UIImage*) scaleToSize:(CGSize)size;

-(UIColor *) patternColor;

// 叠加合并
-(UIImage *) merge:(UIImage *)image;

// 圆角
typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3
} UIImageRoundedCorner;

-(UIImage *) roundedRectWith:(float)radius;
-(UIImage *) roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask;

#pragma mark - 待完善
-(void) saveAsPngWithPath:(NSString *)path;
// compression is 0(most)..1(least)
-(void) saveAsJpgWithPath:(NSString *)path compressionQuality:(CGFloat)quality;
-(void) saveAsPhotoWithPath:(NSString *)path;

// 高斯模糊
-(UIImage*) stackBlur:(NSUInteger)radius;

// 修复方向
-(UIImage *) fixOrientation;

// 改变图片颜色, Gradient带灰度
-(UIImage *) imageWithTintColor:(UIColor *)tintColor;
-(UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
@end
