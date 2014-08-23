//
//  UIImage+XY.m
//  JoinShow
//
//  Created by Heaven on 13-9-30.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//


#import "UIImage+XY.h"
#import "XYPrecompile.h"
#import "NSString+XY.h"
#import "XYSystemInfo.h"

DUMMY_CLASS(UIImage_XY);

//UIKit坐标系统原点在左上角，y方向向下的（坐标系A），但在Quartz中坐标系原点在左下角，y方向向上的(坐标系B)。图片绘制也是颠倒的。
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCorner cornerMask)
{
    //原点在左下方，y方向向上。移动到线条2的起点。
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    //画出线条2, 目前画线的起始点已经移动到线条2的结束地方了。
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    
    //如果左上角需要画圆角，画出一个弧线出来。
    if (cornerMask & UIImageRoundedCornerTopLeft)
    {
        //已左上的正方形的右下脚为圆心，半径为radius， 180度到90度画一个弧线，
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                        radius, M_PI, M_PI / 2, 1);
    }
    else
    {
        //如果不需要画左上角的弧度。从线2终点，画到线3的终点，
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        
        //线3终点，画到线4的起点
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    //画线4的起始，到线4的终点
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    
    //画右上角
    if (cornerMask & UIImageRoundedCornerTopRight)
    {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                        rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    }
    else
    {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    //画右下角弧线
    if (cornerMask & UIImageRoundedCornerBottomRight)
    {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                        radius, 0.0f, -M_PI / 2, 1);
    }
    else
    {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    //画左下角弧线
    if (cornerMask & UIImageRoundedCornerBottomLeft)
    {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                        -M_PI / 2, M_PI, 1);
    }
    else
    {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
}

@implementation UIImage (XY)

+ (UIImage *)image:(NSString *)resourceName{
    UIImage *img = nil;
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
        img = [[UIImage imageNamed:resourceName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        img = [UIImage imageNamed:resourceName];
    }
    return img;
}

+ (UIImage *)imageWithFile:(NSString *)path{
    UIImage *img = nil;
    
    if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
        img = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        img = [UIImage imageWithContentsOfFile:path];
    }
    return img;
}

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (UIImage *)transprent
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );
	
	if ( kCGImageAlphaFirst == alpha ||
		kCGImageAlphaLast == alpha ||
		kCGImageAlphaPremultipliedFirst == alpha ||
		kCGImageAlphaPremultipliedLast == alpha )
	{
		return self;
	}
    
	CGImageRef	imageRef = self.CGImage;
	size_t		width = CGImageGetWidth(imageRef);
	size_t		height = CGImageGetHeight(imageRef);
    
	CGContextRef context = CGBitmapContextCreate( NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
	CGContextDrawImage( context, CGRectMake(0, 0, width, height), imageRef );
    
	CGImageRef	resultRef = CGBitmapContextCreateImage( context );
	UIImage *	result = [UIImage imageWithCGImage:resultRef];
    
	CGContextRelease( context );
	CGImageRelease( resultRef );
    
	return result;
}

- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, CGRectGetMinX(rect), CGRectGetMinY(rect) );
	CGContextSetShouldAntialias( context, true );
	CGContextSetAllowsAntialiasing( context, true );
	CGContextAddEllipseInRect( context, rect );
    CGContextClosePath( context );
    CGContextRestoreGState( context );
}
- (UIImage *)rounded
{
    UIImage * image = [self transprent];
	if ( nil == image )
		return nil;
	
	CGSize imageSize = image.size;
	imageSize.width = floorf( imageSize.width );
	imageSize.height = floorf( imageSize.height );
	
	CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
	CGFloat imageHeight = imageWidth;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate( NULL,
												 imageWidth,
												 imageHeight,
												 CGImageGetBitsPerComponent(image.CGImage),
												 imageWidth * 4,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast );
    
    CGContextBeginPath(context);
	CGRect circleRect;
	circleRect.origin.x = 0;
	circleRect.origin.y = 0;
	circleRect.size.width = imageWidth;
	circleRect.size.height = imageHeight;
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
	CGRect drawRect;
	drawRect.origin.x = 0;
	drawRect.origin.y = 0;
	drawRect.size.width = imageWidth;
	drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease( colorSpace );
	
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
	
    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
    UIImage * image = [self transprent];
	if ( nil == image )
		return nil;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate( NULL,
												 circleRect.size.width,
												 circleRect.size.height,
												 CGImageGetBitsPerComponent( image.CGImage ),
												 circleRect.size.width * 4,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast );
	
    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = circleRect.size.width;
	drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);
	
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}
- (UIImage *)stretched
{
    //	CGFloat x = floorf(self.size.width / 2.0f);
    //	CGFloat y = floorf(self.size.height / 2.0f);
    //	return [self resizableImageWithCapInsets:UIEdgeInsetsMake(x, y, x, y)];
    CGFloat leftCap = floorf(self.size.width / 2.0f);
	CGFloat topCap = floorf(self.size.height / 2.0f);
	return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)stretched:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets];
}

- (UIImage *)rotate:(CGFloat)angle
{
	UIImage *	result = nil;
	CGSize		imageSize = self.size;
	CGSize		canvasSize = CGSizeZero;
	
	angle = fmodf( angle, 360 );
    
	if ( 90 == angle || 270 == angle )
	{
		canvasSize.width = self.size.height;
		canvasSize.height = self.size.width;
	}
	else if ( 0 == angle || 180 == angle )
	{
		canvasSize.width = self.size.width;
		canvasSize.height = self.size.height;
	}
    
    UIGraphicsBeginImageContext( canvasSize );
	
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( bitmap, canvasSize.width / 2, canvasSize.height / 2 );
    CGContextRotateCTM( bitmap, M_PI / 180 * angle );
    
    CGContextScaleCTM( bitmap, 1.0, -1.0 );
    CGContextDrawImage( bitmap, CGRectMake( - (imageSize.width / 2), - (imageSize.height / 2), imageSize.width, imageSize.height), self.CGImage );
    
	result = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return result;
}

- (UIImage *)rotateCW90
{
	return [self rotate:270];
}

- (UIImage *)rotateCW180
{
	return [self rotate:180];
}

- (UIImage *)rotateCW270
{
	return [self rotate:90];
}

- (UIImage *)grayscale
{
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, rect, [self CGImage]);
	CGImageRef grayscale = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage * image = [UIImage imageWithCGImage:grayscale];
	CFRelease(grayscale);
	
	return image;
}

- (UIImage *)crop:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, rect);
	
    UIGraphicsBeginImageContext(rect.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextDrawImage(context, rect, newImageRef);
	
    UIImage * image = [UIImage imageWithCGImage:newImageRef];
	
    UIGraphicsEndImageContext();
	
    CGImageRelease(newImageRef);
	
    return image;
}

- (UIImage *)imageInRect:(CGRect)rect
{
	return [self crop:rect];
}

- (UIColor *)patternColor
{
	return [UIColor colorWithPatternImage:self];
}

+ (UIImage *)merge:(NSArray *)images
{
	UIImage * image = nil;
	
	for ( UIImage * otherImage in images )
	{
		if ( nil == image )
		{
			image = otherImage;
		}
		else
		{
			image = [image merge:otherImage];
		}
	}
	
	return image;
}
+ (UIImage *)imageFromString:(NSString *)name
{
	return [self imageFromString:name atPath:nil];
}

+ (UIImage *)imageFromString:(NSString *)name atPath:(NSString *)path
{
	NSArray *	array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *	imageName = [array objectAtIndex:0];
    
	imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
	imageName = imageName.unwrap.trim;
    
	if ( [imageName hasPrefix:@"url("] && [imageName hasSuffix:@")"] )
	{
		NSRange range = NSMakeRange( 4, imageName.length - 5 );
		imageName = [imageName substringWithRange:range].trim;
	}
    
	UIImage * image = nil;
	
	if ( nil == image && imageName )
	{
		if ( path )
		{
			NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, imageName];
            
			if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
			{
				image = [[UIImage alloc] initWithContentsOfFile:fullPath];
			}
		}
		
		if ( nil == image )
		{
			image = [UIImage imageNamed:imageName];
		}
	}
	
	if ( nil == image )
	{
		return nil;
	}
    
	BOOL grayed = NO;
	BOOL rounded = NO;
	BOOL streched = NO;
	
	if ( array.count > 1 )
	{
		for ( __strong NSString * attr in [array subarrayWithRange:NSMakeRange(1, array.count - 1)] )
		{
			attr = attr.trim.unwrap;
			
			if ( NSOrderedSame == [attr compare:@"stretch" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [attr compare:@"stretched" options:NSCaseInsensitiveSearch] )
			{
				streched = YES;
			}
			else if ( NSOrderedSame == [attr compare:@"round" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"rounded" options:NSCaseInsensitiveSearch] )
			{
				rounded = YES;
			}
			else if ( NSOrderedSame == [attr compare:@"gray" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"grayed" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"grayScale" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"gray-scale" options:NSCaseInsensitiveSearch] )
			{
				grayed = YES;
			}
		}
	}
	
	if ( image )
	{
		if ( rounded )
		{
			image = image.rounded;
		}
        
		if ( grayed )
		{
			image = image.grayscale;
		}
        
		if ( streched )
		{
			image = image.stretched;
		}
	}
    
	return image;
}

+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets
{
	UIImage * image = [self imageFromString:name];
	if ( nil == image )
		return nil;
    
	return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale
{
	AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator * generater = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    generater.appliesPreferredTrackTransform = YES;
	generater.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
	generater.maximumSize = [UIScreen mainScreen].bounds.size;
    NSError * error = nil;
    CGImageRef image = [generater copyCGImageAtTime:time actualTime:NULL error:&error];

    UIImage * thumb = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    return thumb;
}

- (UIImage *)merge:(UIImage *)image
{
	CGSize canvasSize;
	canvasSize.width = fmaxf( self.size.width, image.size.width );
	canvasSize.height = fmaxf( self.size.height, image.size.height );
	
    //	UIGraphicsBeginImageContext( canvasSize );
	UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );
    
	CGPoint offset1;
	offset1.x = (canvasSize.width - self.size.width) / 2.0f;
	offset1.y = (canvasSize.height - self.size.height) / 2.0f;
    
	CGPoint offset2;
	offset2.x = (canvasSize.width - image.size.width) / 2.0f;
	offset2.y = (canvasSize.height - image.size.height) / 2.0f;
    
	[self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
	[image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)roundedRectWith:(float)radius
{
    return [self roundedRectWith:radius cornerMask:UIImageRoundedCornerBottomLeft | UIImageRoundedCornerBottomRight | UIImageRoundedCornerTopLeft | UIImageRoundedCornerTopRight];
}

- (UIImage *)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask
{
    UIImageView *bkImageViewTmp = [[UIImageView alloc] initWithImage:self];
    
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context,bkImageViewTmp.frame, radius, cornerMask);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage    *newImage = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    
    return newImage;
}

- (void)saveAsPngWithPath:(NSString *)path{
    if ([UIImagePNGRepresentation(self) writeToFile:path atomically:YES]) {
    }
}
// compression is 0(most)..1(least)
- (void)saveAsJpgWithPath:(NSString *)path compressionQuality:(CGFloat)quality{
    if ([UIImageJPEGRepresentation(self, quality) writeToFile:path atomically:YES])
    {
    }
}
- (void)saveAsPhotoWithPath:(NSString *)path{
    UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil);
}

- (UIImage*) stackBlur:(NSUInteger)inradius
{
	if (inradius < 1){
		return self;
	}
    // Suggestion xidew to prevent crash if size is null
	if (CGSizeEqualToSize(self.size, CGSizeZero)) {
        return self;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
	// First get the image into your data buffer
    CGImageRef inImage = self.CGImage;
    int nbPerCompt = CGImageGetBitsPerPixel(inImage);
    if (nbPerCompt != 32)
    {
        UIImage *tmpImage = [self normalize];
        inImage = tmpImage.CGImage;
    }
    CFDataRef theData = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    CFMutableDataRef m_DataRef = CFDataCreateMutableCopy(0, 0, theData);
    CFRelease(theData);
    UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
											 CGImageGetWidth(inImage),
											 CGImageGetHeight(inImage),
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),
											 CGImageGetColorSpace(inImage),
											 CGImageGetBitmapInfo(inImage)
											 );
	
    // Apply stack blur
    const int imageWidth  = CGImageGetWidth(inImage);
	const int imageHeight = CGImageGetHeight(inImage);
    [self.class applyStackBlurToBuffer:m_PixelBuf
                                 width:imageWidth
                                height:imageHeight
                            withRadius:inradius];
    
    // Make new image
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
    free(m_PixelBuf);
    
	return finalImage;
}

#define SQUARE(i) ((i)*(i))
inline static void zeroClearInt(int* p, size_t count) { memset(p, 0, sizeof(int) * count); }
+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius
{
    // Constants
	const int radius = inradius; // Transform unsigned into signed for further operations
	const int wm = w - 1;
	const int hm = h - 1;
	const int wh = w*h;
	const int div = radius + radius + 1;
	const int r1 = radius + 1;
	const int divsum = SQUARE((div+1)>>1);
    
    // Small buffers
	int stack[div*3];
	zeroClearInt(stack, div*3);
    
	int vmin[MAX(w,h)];
	zeroClearInt(vmin, MAX(w,h));
    
    // Large buffers
	int *r = malloc(wh*sizeof(int));
	int *g = malloc(wh*sizeof(int));
	int *b = malloc(wh*sizeof(int));
	zeroClearInt(r, wh);
	zeroClearInt(g, wh);
	zeroClearInt(b, wh);
    
    const size_t dvcount = 256 * divsum;
    int *dv = malloc(sizeof(int) * dvcount);
	for (int i = 0;i < dvcount;i++)
    {
		dv[i] = (i / divsum);
	}
    
    // Variables
    int x, y;
	int *sir;
	int routsum,goutsum,boutsum;
	int rinsum,ginsum,binsum;
	int rsum, gsum, bsum, p, yp;
	int stackpointer;
	int stackstart;
	int rbs;
    
	int yw = 0, yi = 0;
	for (y = 0;y < h;y++)
    {
		rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
		
		for (int i = -radius;i <= radius;i++)
        {
			sir = &stack[(i + radius)*3];
			int offset = (yi + MIN(wm, MAX(i, 0)))*4;
			sir[0] = targetBuffer[offset];
			sir[1] = targetBuffer[offset + 1];
			sir[2] = targetBuffer[offset + 2];
			
			rbs = r1 - abs(i);
			rsum += sir[0] * rbs;
			gsum += sir[1] * rbs;
			bsum += sir[2] * rbs;
			if (i > 0)
            {
				rinsum += sir[0];
				ginsum += sir[1];
				binsum += sir[2];
			}
            else
            {
				routsum += sir[0];
				goutsum += sir[1];
				boutsum += sir[2];
			}
		}
		stackpointer = radius;
		
		for (x = 0;x < w;x++)
        {
			r[yi] = dv[rsum];
			g[yi] = dv[gsum];
			b[yi] = dv[bsum];
			
			rsum -= routsum;
			gsum -= goutsum;
			bsum -= boutsum;
			
			stackstart = stackpointer - radius + div;
			sir = &stack[(stackstart % div)*3];
			
			routsum -= sir[0];
			goutsum -= sir[1];
			boutsum -= sir[2];
			
			if (y == 0)
            {
				vmin[x] = MIN(x + radius + 1, wm);
			}
			
			int offset = (yw + vmin[x])*4;
			sir[0] = targetBuffer[offset];
			sir[1] = targetBuffer[offset + 1];
			sir[2] = targetBuffer[offset + 2];
			rinsum += sir[0];
			ginsum += sir[1];
			binsum += sir[2];
			
			rsum += rinsum;
			gsum += ginsum;
			bsum += binsum;
			
			stackpointer = (stackpointer + 1) % div;
			sir = &stack[(stackpointer % div)*3];
			
			routsum += sir[0];
			goutsum += sir[1];
			boutsum += sir[2];
			
			rinsum -= sir[0];
			ginsum -= sir[1];
			binsum -= sir[2];
			
			yi++;
		}
		yw += w;
	}
    
	for (x = 0;x < w;x++)
    {
		rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
		yp = -radius*w;
		for(int i = -radius;i <= radius;i++)
        {
			yi = MAX(0, yp) + x;
			
			sir = &stack[(i + radius)*3];
			
			sir[0] = r[yi];
			sir[1] = g[yi];
			sir[2] = b[yi];
			
			rbs = r1 - abs(i);
			
			rsum += r[yi]*rbs;
			gsum += g[yi]*rbs;
			bsum += b[yi]*rbs;
			
			if (i > 0) {
				rinsum += sir[0];
				ginsum += sir[1];
				binsum += sir[2];
			} else {
				routsum += sir[0];
				goutsum += sir[1];
				boutsum += sir[2];
			}
			
			if (i < hm)
            {
				yp += w;
			}
		}
		yi = x;
		stackpointer = radius;
		for (y = 0;y < h;y++)
        {
			int offset = yi*4;
			targetBuffer[offset]     = dv[rsum];
			targetBuffer[offset + 1] = dv[gsum];
			targetBuffer[offset + 2] = dv[bsum];
			rsum -= routsum;
			gsum -= goutsum;
			bsum -= boutsum;
			
			stackstart = stackpointer - radius + div;
			sir = &stack[(stackstart % div)*3];
			
			routsum -= sir[0];
			goutsum -= sir[1];
			boutsum -= sir[2];
			
			if (x == 0)
            {
				vmin[y] = MIN(y + r1, hm)*w;
			}
			p = x + vmin[y];
			
			sir[0] = r[p];
			sir[1] = g[p];
			sir[2] = b[p];
			
			rinsum += sir[0];
			ginsum += sir[1];
			binsum += sir[2];
			
			rsum += rinsum;
			gsum += ginsum;
			bsum += binsum;
			
			stackpointer = (stackpointer + 1) % div;
			sir = &stack[stackpointer*3];
			
			routsum += sir[0];
			goutsum += sir[1];
			boutsum += sir[2];
			
			rinsum -= sir[0];
			ginsum -= sir[1];
			binsum -= sir[2];
			
			yi += w;
		}
	}
    
	free(r);
	free(g);
	free(b);
    free(dv);
}

- (UIImage *)normalize {
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8, (4 * width),
                                                         genericColorSpace,
                                                         kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;
}

- (UIImage *)fixOrientation{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

- (UIImage *)imageTintedWithColor:(UIColor *)color
{
	// This method is designed for use with template images, i.e. solid-coloured mask-like images.
	return [self imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}


- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
	if (color)
    {
		// Construct new image the same size as this one.
		UIImage *image;
		
		if ([UIScreen instancesRespondToSelector:@selector(scale)])
        {
			UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
		} else {
			UIGraphicsBeginImageContext([self size]);
		}
		CGRect rect = CGRectZero;
		rect.size = [self size];
		
		// Composite tint color at its own opacity.
		[color set];
		UIRectFill(rect);
		
		// Mask tint color-swatch to this image's opaque mask.
		// We want behaviour like NSCompositeDestinationIn on Mac OS X.
		[self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
		
		// Finally, composite this image over the tinted mask at desired opacity.
		if (fraction > 0.0)
        {
			// We want behaviour like NSCompositeSourceOver on Mac OS X.
			[self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
		}
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return image;
	}
	
	return self;
}
- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
