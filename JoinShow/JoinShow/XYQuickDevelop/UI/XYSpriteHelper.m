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
    [_sprites release];
    [super dealloc];
}

-(void)startTimer{
    [[XYTimer sharedInstance] startTimer:XYSpriteHelper_timer interval:_interval];
    [[XYTimer sharedInstance] setTimer:XYSpriteHelper_timer delegate:self];
}
-(void) pauseTimer{
    [[XYTimer sharedInstance] pauseTimer:XYSpriteHelper_timer];
}
-(void)stopTimer{
    [[XYTimer sharedInstance] stopTimer:XYSpriteHelper_timer];
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
-(void) onTimer:(NSString *)timer time:(NSTimeInterval)ti{
  //  NSLogD(@"%f", ti);
    [self updateSprites];
}
#pragma mark -
@end
