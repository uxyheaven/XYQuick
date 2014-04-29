//
// Created by ivan on 13-7-12.
//
//


#import <Foundation/Foundation.h>


@interface Player : NSObject

@property(nonatomic) int rebounds_count;
@property(nonatomic) int likes_received_count;
@property(nonatomic,  strong) NSString *created_at;
@property(nonatomic,  strong) NSString *webSiteURLString;
@property(nonatomic,  strong) NSString *test;
@property(nonatomic, strong) NSArray *testArray;


@end