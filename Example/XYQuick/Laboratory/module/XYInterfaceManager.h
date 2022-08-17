//
//  XYInterfaceManager.h
//  XYQuick
//
//  Created by heaven on 2016/12/22.
//  Copyright © 2016年 uxyheaven. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYInterfaceManager : NSObject

/*
 * sel : create
 * sel : retrieve
 * sel : update
 * sel : delete
 * completion : {ret : 1, error : error, data : data }
 * resourceDoActionWithJSON("达人", retrieve, {达人id = 1});
 * resourceDoActionWithJSON("达人列表", retrieve, {count = 10});
 */

+ (void)resource:(NSString *)resource
        doAction:(SEL)sel
        withJSON:(id)json
         success:(void (^)(id data))success
         failure:(void (^)(NSError *error))failure;

@end
