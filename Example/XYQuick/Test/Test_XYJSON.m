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

uxy_as_JSONAutoParse(Address999)

uxy_as_JSONAutoParse(Asdasasdad)

uxy_as_JSONAutoParse(Country)


@interface Country : NSObject <Country>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name_id;
@end

@implementation Country
@end

@interface Country2 : NSObject <XYJSON>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger num;
@end

@implementation Country2
@end

uxy_as_JSONAutoParse(Address)

@interface Address : NSObject <Address, Address999, Asdasasdad, XYJSON>
@property (nonatomic, assign) int code;
@property (nonatomic, strong) Country <Country> *country;
@property (nonatomic, copy) NSString *area;
@end

@implementation Address
@end




@interface Address2 : NSObject
@property (nonatomic, assign) int code;
@property (nonatomic, strong) Country <Country> *country;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *string;
@end

@implementation Address2
@end

@interface Address3 : NSObject <XYJSON>
@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSArray <Country> *list;
@property (nonatomic, copy) NSString *area;
@end

@implementation Address3
@end


@interface Tour : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <Address999, Address> *list;
@end

@implementation Tour
@end


@interface Tour2 : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <Address> *list;

@end

@implementation Tour2
+ (void)initialize
{
    if (self == [Tour2 class]){
        [self uxy_addNickname:@"name2" forProperty:@"name"];
        [self uxy_addNickname:@"name4" forProperty:@"name"];
        [self uxy_addNickname:@"list2" forProperty:@"list"];
    }
}
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
    
    Address *address = [str uxy_JSONObjectByClass:[Address class]];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test0_1 )
{
    // 变量里有多余的属性
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json0.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Address2 *address = [str uxy_JSONObjectByClass:[Address2 class]];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( address.string.length == 0 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test1 )
{
    // 解析成字典
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json1.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    NSDictionary *dic = [str uxy_JSONObject];
    UXY_EXPECTED( dic.count == 3 );
}

UXY_DESCRIBE( test2 )
{
    // 解析某个key里的值
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json2.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Address *address = [str uxy_JSONObjectByClass:[Address class] forKeyPath:@"data"];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test2_1 )
{
    // keyPath
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json2.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Country *country = [str uxy_JSONObjectByClass:[Country class] forKeyPath:@"data.country"];
    UXY_EXPECTED( [country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test2_2 )
{
    // key带有count
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json2_2.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Address *address = [str uxy_JSONObjectByClass:[Address class] forKeyPath:@"count"];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test3 )
{
    // 属性带有NSArray
    /*
     0. Tour类的一个属性list里存放的是Address数组
     1. 申明和类同名的协议 uxy_as_JSONAutoParse(Address)
     2. 申明类实现了这个协议 @interface Address : NSObject <Address>
     3. 申明属性实现了这个协议 @property (nonatomic, strong) NSArray <Address> *list;
     */
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json3.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Tour *tour = [str uxy_JSONObjectByClass:[Tour class]];
    UXY_EXPECTED( [tour.name isEqualToString:@"线路"] );
    
    Address *address = tour.list[0];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test4 )
{
    // 解析 NSArray
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json4.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    NSArray *array = [str uxy_JSONObjectByClass:[Address class]];
    Address *address = array[0];
    
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}

UXY_DESCRIBE( test5 )
{
    // 开启JSONCache 提高一个返回值里有多个对象的时候解析速度的问题.
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json5.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    str.uxy_keepJSONObjectCache = YES;
    if (str.length == 0)
        return;
    
    Address *address = [str uxy_JSONObjectByClass:[Address class] forKeyPath:@"data1"][0];
    Country *country = [str uxy_JSONObjectByClass:[Country class] forKeyPath:@"data2"];
    
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
    UXY_EXPECTED( [country.name isEqualToString:@"米国"] );
}

UXY_DESCRIBE( test6 )
{
    // 有空值
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json6.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Tour *tour = [str uxy_JSONObjectByClass:[Tour class]];
    UXY_EXPECTED( [tour.name isEqualToString:@"线路"] );
    UXY_EXPECTED( tour.list == nil );
}

UXY_DESCRIBE( test7 )
{
    // key的名字和属性不一致
    /*
     0. JSON里的key是name2, Tour2类里的属性名字是name
     1. 在Tour2类里执行 [self uxy_addNickname:@"name2" forProperty:@"name"];
     */
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"json7.json" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    if (str.length == 0)
        return;
    
    Tour2 *tour = [str uxy_JSONObjectByClass:[Tour2 class]];
    UXY_EXPECTED( [tour.name isEqualToString:@"线路"] );
    
    Address *address = tour.list[0];
    UXY_EXPECTED( address.code == 1 );
    UXY_EXPECTED( [address.area isEqualToString:@"华东"] );
    UXY_EXPECTED( [address.country.name isEqualToString:@"天朝"] );
}


UXY_DESCRIBE(test8_0)
{
    // 对象解析成字串
    /*
     1. 需要申明对象实现了XYJSON协议, @interface Country2 : NSObject <XYJSON>
     */
    Country2 *country = [[Country2 alloc] init];
    country.name = @"米国";
    country.num = 100;
    
    NSString *str = [country uxy_JSONString];
    
    // 以下是测试的代码
    NSDictionary *dic = [str uxy_JSONObject];
    NSInteger i = [(NSNumber *)dic[@"num"] integerValue];
    
    UXY_EXPECTED( [dic[@"name"] isEqualToString:@"米国"] );
    UXY_EXPECTED( i == 100 );
}

UXY_DESCRIBE(test8_1)
{
    // 对象的属性里包含对象, 解析成字串
    /*
     1. 需要申明对象实现了XYJSON协议, @interface Address : NSObject <XYJSON>
     1. 申明和类同名的协议 uxy_as_JSONAutoParse(Country)
     2. 申明类实现了这个协议 @interface Country : NSObject <Country>
     3. 申明属性实现了这个协议 @property (nonatomic, strong) Country <Country> *country;
     */
    Country *country = [[Country alloc] init];
    country.name = @"米国";
    country.name_id = @"001";
    
    Address *address = [[Address alloc] init];
    address.code = 999;
    address.area = @"美洲";
    address.country = country;
    
    NSString *str = [address uxy_JSONString];
    
    // 以下是测试的代码
    NSDictionary *dic = [str uxy_JSONObject];
    NSInteger i = [(NSNumber *)dic[@"code"] integerValue];
    
    UXY_EXPECTED( [dic[@"country"][@"name"] isEqualToString:@"米国"] );
    UXY_EXPECTED( i == 999 );
}

UXY_DESCRIBE(test8_2)
{
    // 对象的属性里包含NSArray对象, 解析成字串
    /*
     1. 需要申明对象实现了XYJSON协议, @interface Address : NSObject <XYJSON>
     1. 申明和类同名的协议 uxy_as_JSONAutoParse(Country)
     2. 申明类实现了这个协议 @interface Country : NSObject <Country>
     3. 申明属性实现了这个协议 @property (nonatomic, strong) Country <Country> *country;
     */
    Country *country = [[Country alloc] init];
    country.name = @"米国";
    country.name_id = @"001";
    
    Country *country2 = [[Country alloc] init];
    country2.name = @"岛国";
    country2.name_id = @"002";
    
    Address3 *address = [[Address3 alloc] init];
    address.code = 999;
    address.area = @"美洲";
    address.list = @[country, country2];
    
    NSString *str = [address uxy_JSONString];
    
    // 以下是测试的代码
    NSDictionary *dic = [str uxy_JSONObject];
    NSInteger i = [(NSNumber *)dic[@"code"] integerValue];
    
    UXY_EXPECTED( [dic[@"list"][0][@"name"] isEqualToString:@"米国"] );
    UXY_EXPECTED( i == 999 );
}

UXY_DESCRIBE(test9)
{
    // 对象解析成字典
    /*
     1. 需要申明对象实现了XYJSON协议, @interface Country2 : NSObject <XYJSON>
     */
    Country2 *country = [[Country2 alloc] init];
    country.name = @"米国";
    country.num = 100;
    
    NSDictionary *dic = [country uxy_JSONDictionary];
    NSInteger i = [(NSNumber *)dic[@"num"] integerValue];
    
    UXY_EXPECTED( [dic[@"name"] isEqualToString:@"米国"] );
    UXY_EXPECTED( i == 100 );
}

UXY_DESCRIBE(test9_1)
{
    // 对象的属性里包含对象, 解析成字典
    /*
     1. 需要申明对象实现了XYJSON协议, @interface Address : NSObject <XYJSON>
     1. 申明和类同名的协议 uxy_as_JSONAutoParse(Country)
     2. 申明类实现了这个协议 @interface Country : NSObject <Country>
     3. 申明属性实现了这个协议 @property (nonatomic, strong) Country <Country> *country;
     */
    Country *country = [[Country alloc] init];
    country.name = @"米国";
    country.name_id = @"001";
    
    Address *address = [[Address alloc] init];
    address.code = 999;
    address.area = @"美洲";
    address.country = country;
    
    NSDictionary *dic = [address uxy_JSONDictionary];
    NSInteger i = [(NSNumber *)dic[@"code"] integerValue];
    
    UXY_EXPECTED( [dic[@"country"][@"name"] isEqualToString:@"米国"] );
    UXY_EXPECTED( i == 999 );
}

UXY_DESCRIBE(test9_2)
{
    // 对象的属性里包含NSArray对象, 解析成字典
    /*
     1. 需要申明对象实现了XYJSON协议, @interface Address : NSObject <XYJSON>
     1. 申明和类同名的协议 uxy_as_JSONAutoParse(Country)
     2. 申明类实现了这个协议 @interface Country : NSObject <Country>
     3. 申明属性实现了这个协议 @property (nonatomic, strong) Country <Country> *country;
     */
    Country *country = [[Country alloc] init];
    country.name = @"米国";
    country.name_id = @"001";
    
    Country *country2 = [[Country alloc] init];
    country2.name = @"岛国";
    country2.name_id = @"002";
    
    Address3 *address = [[Address3 alloc] init];
    address.code = 999;
    address.area = @"美洲";
    address.list = @[country, country2];

    // 以下是测试的代码
    NSDictionary *dic = [address uxy_JSONDictionary];
    NSInteger i = [(NSNumber *)dic[@"code"] integerValue];
    
    UXY_EXPECTED( [dic[@"list"][0][@"name"] isEqualToString:@"米国"] );
    UXY_EXPECTED( i == 999 );
}

UXY_TEST_CASE_END

#endif