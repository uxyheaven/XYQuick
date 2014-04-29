//
// Created by ivan on 13-7-12.
//
//


#import <Foundation/Foundation.h>

@class Player;


@interface Shot : NSObject
@property(nonatomic,  strong) NSString *image_teaser_url;
@property(nonatomic,  strong) NSString *created_at;
@property(nonatomic, strong) NSNumber *rebounds_count;
@property(nonatomic, strong) NSNumber *comments_count;
@property(nonatomic, strong) NSNumber *rebound_source_id;
@property(nonatomic,  strong) NSString *url;
@property(nonatomic, strong) NSNumber *likes_count;
@property(nonatomic, strong) NSNumber *height;
@property(nonatomic,  strong) NSString *title;
@property(nonatomic,  strong) NSString *image_400_url;
@property(nonatomic, strong) NSNumber *views_count;
@property(nonatomic, strong) NSNumber *width;
@property(nonatomic,  strong) NSString *short_url;
@property(nonatomic, strong) NSNumber *id;
@property(nonatomic,  strong) NSString *imageURLString;
@property(nonatomic, strong) Player *player;
@property(nonatomic,  strong) NSString *testString;
@end