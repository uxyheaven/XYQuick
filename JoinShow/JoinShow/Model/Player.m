//
// Created by ivan on 13-7-12.
//
//


#import "Player.h"
#import "YYJSONHelper.h"


@implementation Player

+ (void)initialize
{
    [super initialize];
    [self bindYYJSONKey:@"website_url" toProperty:@"webSiteURLString"];
}

@end