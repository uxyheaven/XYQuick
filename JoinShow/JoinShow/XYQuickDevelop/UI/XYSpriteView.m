//  Created by Heaven on 13-5-16.
//

#import "XYSpriteView.h"

@interface XYSpriteView (){
    struct {
        unsigned int spriteFinished : 1;
        unsigned int spriteWillStart : 1;
        unsigned int spriteDidStop : 1;
        unsigned int spritePlaying_onIndex : 1;
    } _delegateFlags;
}

@end

@implementation XYSpriteView

-(void)dealloc{
    NSLogD(@"%s", __FUNCTION__);
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageNameArray = [[NSMutableArray alloc] init];
        
        fromIndex = -1;
        toIndex = 0;
        _repeatCount = 1;
        _duration = 0;
        _interval = 0;
        _delay = 0;
        _firstImgIndex = 0;
        isDelayed = NO;
        
        _isTransformLR = NO;
        _isTransformUD = NO;
        _isReverseOrder = NO;
        _isAutoPlay = NO;
        _isPlayAudio = NO;
        
        state = SpriteStateUndefine;
        self.aniPath = @"";
        
    }
    return self;
}
-(void) setDelegate:(id<XYSpriteDelegate>)delegate{
    _delegate = delegate;
    if (_delegate != nil) {
        _delegateFlags.spriteFinished = [delegate respondsToSelector:@selector(spriteFinished:)];
        _delegateFlags.spriteWillStart = [delegate respondsToSelector:@selector(spriteWillStart:)];
        _delegateFlags.spriteDidStop = [delegate respondsToSelector:@selector(spriteDidStop:)];
        _delegateFlags.spritePlaying_onIndex = [delegate respondsToSelector:@selector(spritePlaying:onIndex:)];
    }
}
-(void)start{
    state = SpriteStatePlaying;
    
    if (_delegateFlags.spriteWillStart) {
        [_delegate spriteWillStart:self];
    }
}
-(void)pause{
    state = SpriteStatePause;
}
-(void)reset{
    _curImageIndex = fromIndex;
    curRepeatCount = 0;
    _curTime = 0;
    state = SpriteStateStop;
}
-(void)stop{
    state = SpriteStateStop;

    if (_delegateFlags.spriteDidStop) {
        [_delegate spriteDidStop:self];
    }
}

// if fileType == nil, support png, jpg
- (NSMutableArray *)allFilesAtPath:(NSString *)direString type:(NSString*)fileType
{
    NSMutableArray *pathArray = [NSMutableArray array];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str = [XYCommon dataFilePath:direString ofType:filePathOption_app];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:str error:nil];
    
    if (tempArray == nil) {
        return nil;
    }
    
    NSString *strType = nil;
    if (fileType) {
        strType = [NSString stringWithFormat:@".%@",fileType];
    }
    
    for (NSString *fileName in tempArray) {
        BOOL flag = YES;
        NSString *path = [direString stringByAppendingPathComponent:fileName];
        NSString *fullPath = [XYCommon dataFilePath:path ofType:filePathOption_app];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag])
        {
            if (!flag) {
                
                if (strType != nil) {
                    if ([fileName hasSuffix:strType]) {
                        
                        [pathArray addObject:fileName];
                        
                    }
                }else
                {
                    if ([fileName hasSuffix:@".png"] || [fileName hasSuffix:@".jpg"]) {
                        
                        [pathArray addObject:fileName];
                        
                    }
                }
                
            }
            else {
                
            }
        }
    }
    
    return pathArray;
}
- (void) updateTimer:(NSTimeInterval)time{
    if (state != SpriteStatePlaying) return;
    
    // 延时未到
    if (isDelayed) {
        if (_curTime >= _delay){
            isDelayed = NO;
            _curTime = 0;
        }
        _curTime += time;
        return;
    }
    
    if (curRepeatCount != _repeatCount) {
        // 不是最后一轮
        // 间隔
        if (_curTime >= _duration && _curTime < allTime){
            _curTime += time;
        }
    } else{
        if (_repeatCount != 0) {
            allTime = _duration;
        }
    }
    
    if (_curTime >= allTime) {
        [self showImgWithIndex:toIndex];
        if (curRepeatCount + 1 >= _repeatCount && _repeatCount != 0)
        {
            // 播放完成
          //  [self resetPlay];
            state = SpriteStateStop;
            
            if (_delegateFlags.spriteFinished) {
                [_delegate spriteFinished:self];
            }
        }else{
            // 下一个循环开始
            curRepeatCount++;
            _curTime = _curTime - allTime;
            _curImageIndex = fromIndex;
            state = SpriteStatePlaying;
        }
    }else{
        // curTime < duration
        state = SpriteStatePlaying;
        NSInteger index = _isReverseOrder ? fromIndex - (NSInteger)(_curTime / animInterval) : (NSInteger)(_curTime / animInterval) + fromIndex;
       // NSLogD(@"%s, index:%d:, count:%d", __FUNCTION__, index, _imageNameArray.count);
        // 判断范围
        BOOL b;
        if (_isReverseOrder) {
            b = (index >= toIndex) && (index <= fromIndex);
        }else{
            b = (index >= fromIndex) && (index <= toIndex);
        }
        if (lastImgIndex != index && b) {
            _curImageIndex = index;

            if (_delegateFlags.spritePlaying_onIndex) {
                [_delegate spritePlaying:self onIndex:_curImageIndex];
            }
            
            [self showImgWithIndex:_curImageIndex];
        }
        
        _curTime += time;
        lastImgIndex = index;
    }
    
}
- (void)updateImage
{
    if (0 == state) return;
    
    if (_imageNameArray == nil && _imageNameArray.count == 0) {
        return;
    }
    
    if (_repeatCount == 0)  //无限循环播放
    {
        if (_curImageIndex >= _imageNameArray.count)
        {
            _curImageIndex = 0;
            
        }
        [self showImgWithIndex:_curImageIndex];
        _curImageIndex++;
    }
    else
    {
        if (_curImageIndex >= _imageNameArray.count)
        {
            
            if (curRepeatCount >= _repeatCount - 1) {     //播放至最后一遍最后一帧关闭定时器
                return;
            }
            else
            {
                curRepeatCount++;
                _curImageIndex = 0;
            }
        }
        [self showImgWithIndex:_curImageIndex];
        _curImageIndex++;
        
    }
}

-(BOOL) setFromIndex:(NSInteger)from toindex:(NSInteger)to{
#pragma mark - todo 边界值, 正反序
    if (to >= [_imageNameArray count] || from < -1 || to < -1 || from >= [_imageNameArray count]) {
        return NO;
    }
    
    if (from > to)
    {
        _isReverseOrder = YES;
    }
    else
    {
        _isReverseOrder = NO;
    }
    fromIndex = from;
    toIndex = to;
    if (from == -1) {
        _isReverseOrder = NO;
        fromIndex = 0;
        toIndex = [_imageNameArray count];
    }
    if (to == -1) {
        _isReverseOrder = YES;
        fromIndex = [_imageNameArray count];
        toIndex = 0;
    }
    
    _curImageIndex = fromIndex;
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    oneImgTurnCount = labs(fromIndex - toIndex) + 1;
#else
    oneImgTurnCount = abs(fromIndex - toIndex) + 1;
#endif
    _duration = oneImgTurnCount / XYSpriteView_aniFrames;
    allTime = _duration + _interval;
    
    animInterval = _duration / oneImgTurnCount;
    
    return YES;
}

-(void)setDelay:(NSTimeInterval)delay{
    _delay = delay;
    if (delay > 0) {
        isDelayed = YES;
    }
}
-(void)setInterval:(NSTimeInterval)interval{
    _interval = interval;
    allTime = _duration + _interval;
}

-(void)setIsTransformLR:(BOOL)b{
    if (_isTransformLR == b) return;
    _isTransformLR = b;
    float f = _isTransformUD ? -1 : 1;

    if (_isTransformLR){
        CATransform3D stransform = CATransform3DMakeScale(-1.0f, f, 1.0f);
        CATransform3D transform = CATransform3DTranslate(stransform, 0.0f, 0.0f, 0.0f);
        self.layer.transform = transform;
    }else{
        CATransform3D stransform = CATransform3DMakeScale(1.0f, f, 1.0f);
        CATransform3D transform = CATransform3DTranslate(stransform, 0.0f, 0.0f, 0.0f);
        self.layer.transform = transform;
    }
}

-(void)setIsTransformUD:(BOOL)b{
    if (_isTransformUD == b) return;
    _isTransformUD = b;
    float f = _isTransformLR ? -1 : 1;
    
    if (_isTransformUD){
        CATransform3D stransform = CATransform3DMakeScale(f, -1.0f, 1.0f);
        CATransform3D transform = CATransform3DTranslate(stransform, 0.0f, 0.0f, 0.0f);
        self.layer.transform = transform;
    }else{
        CATransform3D stransform = CATransform3DMakeScale(f, 1.0f, 1.0f);
        CATransform3D transform = CATransform3DTranslate(stransform, 0.0f, 0.0f, 0.0f);
        self.layer.transform = transform;
    }
}
-(void)resetCATransform3D{
    //  CATransform3D stransform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 0.0f, 0.0f, 0.0f);
    self.layer.transform = transform;
}
- (void)pageAnimate:(UITapGestureRecognizer*)sender
{
    [self reset];
    [self start];
}
- (void)imagesPath:(NSString *)imagesPath repeatCount:(NSUInteger)count{
    [self imagesPath:imagesPath repeatCount:count fromIndex:-1 toIndex:0];
}
- (void)imagesPath:(NSString *)imagesPath repeatCount:(NSUInteger)count fromIndex:(int)from toIndex:(int)to{
    //replay need to stop first
    if (state == SpriteStatePlaying) {
        // return;
    }
    
    if (!imagesPath) return;

#pragma mark -todo 后缀
    NSMutableArray *tmpArray = [self allFilesAtPath:imagesPath type:@"png"];
    
    if (!tmpArray || [tmpArray count] == 0) {
        return;
    }
    
    self.aniPath = imagesPath;
    
    [_imageNameArray removeAllObjects];
    [_imageNameArray addObjectsFromArray:tmpArray];
    _repeatCount = count;
    [self setFromIndex:from toindex:to];
    [self reset];

}
- (void) formatImg:(NSString *)format count:(NSInteger)count2 repeatCount:(NSUInteger)count{
    _repeatCount = count;

    [_imageNameArray removeAllObjects];
    for (NSInteger i = 0 + _firstImgIndex; i < count2 + _firstImgIndex; i++) {
        [_imageNameArray addObject:[NSString stringWithFormat:format, i]];
    }
    
    [self setFromIndex:0 toindex:count2 - 1];
     [self reset];
}
- (void) showImgWithIndex:(NSInteger)index{
    if (self.imageNameArray.count == 0 || index > self.imageNameArray.count - 1) {
        return;
    }
    NSString *imageName = [_imageNameArray objectAtIndex:index];
    NSString *tmpStr = [[NSString alloc] initWithFormat:@"%@/%@", self.aniPath, imageName];
    NSString *path = [XYCommon dataFilePath:tmpStr ofType:filePathOption_app];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        self.layer.contents = nil;
        UIImage *tmpIMG = [[UIImage alloc] initWithContentsOfFile:path];
        self.layer.contents = (id)tmpIMG.CGImage;
    }
}
- (void)duration:(NSTimeInterval)dur interval:(NSTimeInterval)i delay:(NSTimeInterval)d{
    _duration = dur;
    _interval = i;
    _delay = d;
    allTime = _duration + _interval;
    
    if (_delay > 0) {
        isDelayed = YES;
    }
    
    animInterval = _duration / oneImgTurnCount;
}


@end
