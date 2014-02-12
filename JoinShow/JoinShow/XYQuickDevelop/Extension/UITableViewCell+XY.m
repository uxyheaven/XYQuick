//
//  UITableViewCell+XY.m
//  JoinShow
//
//  Created by Heaven on 14-1-2.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "UITableViewCell+XY.h"
#import "XYPrecompile.h"

@implementation UITableViewCell (XY)

+(CGFloat) heightForRowWithData:(id)aData{
    if (aData == nil) {
        return -1;
    }
    
    return 44;
}

-(void) layoutSubviewsWithDic:(NSMutableDictionary *)dic{
    
}
@end
