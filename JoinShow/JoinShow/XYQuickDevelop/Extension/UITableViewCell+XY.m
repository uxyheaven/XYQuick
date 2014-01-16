//
//  UITableViewCell+XY.m
//  JoinShow
//
//  Created by Heaven on 14-1-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UITableViewCell+XY.h"
#import "XYPrecompile.h"

#undef	UITableViewCell_key_rowHeight
#define UITableViewCell_key_rowHeight	"UITableViewCell.rowHeight"

@implementation UITableViewCell (XY)
/*
@dynamic rowHeight;

-(float) rowHeight{
    NSNumber *number = objc_getAssociatedObject(self, UITableViewCell_key_rowHeight);
    if (number == nil) {
       return -1;
    }
    
    return [number floatValue];
}

-(void) setRowHeight:(float)rowHeight{
    objc_setAssociatedObject(self, UITableViewCell_key_rowHeight, [NSNumber numberWithFloat:rowHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 */

+(CGFloat) heightForRowWithData:(id)aData{
    if (aData == nil) {
        return -1;
    }
    
    return 44;
}

-(void) layoutSubviewsWithDic:(NSMutableDictionary *)dic{
    
}
@end
