//
//  Test_XYJSON.m
//  JoinShow
//
//  Created by Heaven on 15/11/24.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "XYQuick.h"

#pragma mark -
// ----------------------------------
// Unit test
// ----------------------------------
#if (1 == __XY_DEBUG_UNITTESTING__)

@interface Country : NSObject <XYJSONAutoBinding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name_id;
@end

@implementation Country
@end

@interface Address : NSObject
@property (nonatomic, assign) int code;
@property (nonatomic, strong) Country *country;
@property (nonatomic, copy) NSString *area;
@end

@implementation Address
@end

@protocol Address @end

@interface Tour : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <Address> *list;
@end

@implementation Tour
@end


UXY_TEST_CASE( Core, JSON )
{
    //	TODO( "test case" )
}

UXY_DESCRIBE( test0 )
{
    // 普通的解析
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json0.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Address *address = [str uxy_toModel:[Address class]];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test1 )
{
    // 解析成字典
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json1.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    NSDictionary *dic = [str uxy_JSONDictionary];
    UXY_EXPECTED( dic.count == 3 );
}

UXY_DESCRIBE( test2 )
{
    // 解析某个key里的值
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json2.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Address *address = [str uxy_toModel:[Address class] forKey:@"data"];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test3 )
{
    // 属性带有NSArray
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json3.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Tour *tour = [str uxy_toModel:[Tour class]];
    UXY_EXPECTED( [tour.name isEqualToString:@"线路"] );
    
    Address *address = tour.list[0];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_TEST_CASE_END

#endif