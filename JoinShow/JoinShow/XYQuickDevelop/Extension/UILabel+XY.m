//
//  UILabel+XY.m
//  JoinShow
//
//  Created by Heaven on 13-11-28.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "UILabel+XY.h"

@implementation UILabel (XY)

-(void) resize:(UILabelResizeType)type{
    CGSize size;
    if (type == UILabelResizeType_constantHeight) {
        size = [self estimateUISizeByHeight:self.bounds.size.height];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    }else if (type == UILabelResizeType_constantWidth) {
        size = [self estimateUISizeByWidth:self.bounds.size.width];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    }
}

- (CGSize)estimateUISizeByBound:(CGSize)bound
{
	if ( nil == self.text || 0 == self.text.length )
		return CGSizeZero;
    
	return [self.text sizeWithFont:self.font
				 constrainedToSize:bound
					 lineBreakMode:self.lineBreakMode];
}

- (CGSize)estimateUISizeByWidth:(CGFloat)width
{
	if ( nil == self.text || 0 == self.text.length )
		return CGSizeMake( width, 0.0f );
    
	if ( self.numberOfLines )
	{
		return [self.text sizeWithFont:self.font
					 constrainedToSize:CGSizeMake(width, self.font.lineHeight * self.numberOfLines + 1)
						 lineBreakMode:self.lineBreakMode];
	}
	else
	{
		return [self.text sizeWithFont:self.font
					 constrainedToSize:CGSizeMake(width, 999999.0f)
						 lineBreakMode:self.lineBreakMode];
	}
}

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
	if ( nil == self.text || 0 == self.text.length )
		return CGSizeMake( 0.0f, height );
    
	return [self.text sizeWithFont:self.font
				 constrainedToSize:CGSizeMake(999999.0f, height)
					 lineBreakMode:self.lineBreakMode];
}
@end
