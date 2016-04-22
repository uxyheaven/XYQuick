//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "UILabel+XY.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define XY_TEXTSIZE(text, font) [text length] > 0 ? [text \
        sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define XY_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
        boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
        attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#endif


@implementation UILabel (XYExtension)

- (void)uxy_resize:(XYLabelResizeType)type
{
    CGSize size;
    if (type == XYLabelResizeType_constantHeight)
    {
        // 高不变
        size = [self uxy_estimateUISizeByHeight:self.bounds.size.height];
        if (!CGSizeEqualToSize(CGSizeZero, size))
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, self.bounds.size.height);
        }
    }
    else if (type == XYLabelResizeType_constantWidth)
    {
        // 宽不变
        size = [self uxy_estimateUISizeByWidth:self.bounds.size.width];
        if (!CGSizeEqualToSize(CGSizeZero, size))
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, size.height);
        }
        
    }
}

- (CGSize)uxy_estimateUISizeByBound:(CGSize)bound
{
    if ( nil == self.text || 0 == self.text.length )
    {
        return CGSizeZero;
    }
    
	return XY_MULTILINE_TEXTSIZE(self.text, self.font, bound, self.lineBreakMode);
}

- (CGSize)uxy_estimateUISizeByWidth:(CGFloat)width
{
	if ( nil == self.text || 0 == self.text.length )
    {
        return CGSizeMake( width, 0.0f );
    }
		
    
	if ( self.numberOfLines )
	{
		return XY_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(width, self.font.lineHeight * self.numberOfLines + 1), self.lineBreakMode);
	}
	else
	{
		return XY_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(width, 999999.0f), self.lineBreakMode);
	}
}

- (CGSize)uxy_estimateUISizeByHeight:(CGFloat)height
{
	if ( nil == self.text || 0 == self.text.length )
    {
        return CGSizeMake( 0.0f, height );
    }
    
	return XY_MULTILINE_TEXTSIZE(self.text, self.font, CGSizeMake(999999.0f, height), self.lineBreakMode);
}
@end
