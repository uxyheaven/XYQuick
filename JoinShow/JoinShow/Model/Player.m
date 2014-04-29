//
// Created by ivan on 13-7-12.
//
//


#import "Player.h"
#import "YYJSONHelper.h"


@implementation Player

+ (void)initialize
{
    if (self == [Player class]){
        [self bindYYJSONKey:@"website_url" toProperty:@"webSiteURLString"];
    }
}

@end