//  Created by Heaven on 13-5-15.
//
//


#import "XYSpriteHelper.h"



@implementation XYSpriteHelper{
    
}

DEF_SINGLETON(XYSpriteHelper);

-(id)init{
    self = [super init];
    if (self) {
        _sprites = [[NSMutableDictionary alloc] initWithCapacity:5];
        self.interval = 1.0/12.0;
    }
    return self;
}
-(void)dealloc{
}

-(void)startTimer{
    [self timer:_interval repeat:YES];
}
-(void) pauseTimer{
    [self cancelTimer:nil];
}
-(void)stopTimer{
    [self cancelTimer:nil];
}

-(void)clearAllSprites{
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani removeFromSuperview];
    }];
    [self.sprites removeAllObjects];
}
-(void) startAllSprites{
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani start];
    }];
}
-(void) stopAllSprites{
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani stop];
    }];
}

- (void)updateSprites{
    if (self.sprites.count == 0) return;
    
    [self.sprites enumerateKeysAndObjectsUsingBlock:^(id key, XYSpriteView *ani, BOOL *stop) {
        [ani updateTimer:_interval];
       // [ani updateImage];
    }];
}
#define mark - XYTimerDelegate

ON_TIMER( ){
    [self updateSprites];
}

#pragma mark -
@end
