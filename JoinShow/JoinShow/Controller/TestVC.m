//
//  TestVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-1.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "TestVC.h"
//#import "UIView+Test.h"
#import "TestView.h"
#import "Test2View.h"
#import "PaintCodeView.h"

#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif

#import <Social/SocialDefines.h>
#import "XYExternal.h"

#import "Test1Model.h"
#import "Test2Model.h"
#import "GirlEntity.h"


#define MultiPlatform( __xib ) \
(NSString *)^(void){ \
if (1) { \
    return __xib; \
}else { \
    return [__xib stringByAppendingString:@"_ipad"]; \
}   \
}();

@interface TestVC ()

@end

@implementation TestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.array = [NSMutableArray array];
        _testKVO = 0;
        self.testArrayKVO = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc
{
    NSLogDD
    [XYTimer sharedInstance].delegate = nil;
    self.array = nil;
    self.testArrayKVO = nil;
    self.myGirl = nil;
    self.text = nil;
    [self removeAllObserver];
    [super dealloc];
}

-(void) someTest{
#pragma mark - others
    //////////////////// test KVO ///////////////////////
    [self observeWithObject:self keyPath:@"testKVO" selector:@selector(testKVOChanged:) observeKey:@"test_testKVO"];
    [self observeWithObject:self keyPath:@"testKVO" selector:@selector(testKVOChanged2:) observeKey:@"test_testKVO2"];
    [self observeWithObject:self keyPath:@"testArrayKVO" selector:@selector(testArrayKVOChanged:) observeKey:@"test_testArrayKVO"];
    
    NSString *str2 = MultiPlatform(@"xib");
    NSLogD(@"%@", str2);
    
#pragma mark - next
    NSString *str3 = [NSString stringWithFormat:@"%p", self];
    NSLog(@"%@", str3);
    
    // PRINT_CALLSTACK(64);
    
    NSMutableString *str4 = [NSMutableString string];
    NSString *str5 = str4.APPEND(@"%@%@", @"c", @"b");
    NSLogD(@"%@", str5);
    
    
#pragma mark - next
    NSString *strLen = @"a";
    NSLogD(@"%d", [strLen getLength2]);
    strLen = @"啊a";
    NSLogD(@"%d", [strLen getLength2]);
    strLen = @"你好,世界.";
    NSLogD(@"%d", [strLen getLength2]);
    
#pragma mark - next
    GirlEntity *tempGirl = [[GirlEntity alloc] init];
    self.myGirl = tempGirl;
    [tempGirl release];
    
    [self observeWithObject:self keyPath:@"myGirl.name" selector:@selector(expChanged:) observeKey:@"TestVC_myGirl"];
    
#pragma mark - next
    self.array = [NSMutableArray arrayWithArray:@[@"a"]];
    NSMutableArray *array2 = self->_array;
    NSLogD(@"%@", array2);
    
    NSString *str = [NSString stringWithFormat:@"%d", 123123];
    [str erasure];
    NSLogD(@"%@", str);

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[XYTimer sharedInstance] startTimerWithInterval:2];
    UIScrollView *scroll = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 66 , Screen_WIDTH - 20, Screen_HEIGHT - 86)] autorelease];
    //scroll.contentSize = CGSizeMake(Screen_WIDTH - 60, 2000);
    scroll.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:scroll];
    int btnOffsetY = 20;
    
    // 旋转
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(100, btnOffsetY, 100, 100);
    [tempBtn setBackgroundImage:LoadImage_cache(@"bg.jpg") forState:UIControlStateNormal];
    // [tempBtn setImageEdgeInsets:UIEdgeInsetsMake(00,00,50,00)];
    [tempBtn setTitle:@"title" forState:UIControlStateNormal];
    [tempBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [tempBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [tempBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, 00, 00, 00)];
    [tempBtn setRotate:0.5];
    [scroll addSubview:tempBtn];
    btnOffsetY += 120;
    
    // 点击动画
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor redColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 100, 44);
    [tempBtn setTitle:@"muhud" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickBtnMuhud:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // block
    int i = 1;
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 100, 44);
    [tempBtn setTitle:@"block1" forState:UIControlStateNormal];
    [tempBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLogD(@"block1:%d", i);
    }];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    i = 2;
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 100, 44);
    [tempBtn setTitle:@"block2" forState:UIControlStateNormal];
    [tempBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLogD(@"block2:%d", i);
    }];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // kvo
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"kvo" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // ios7语音
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"AVSpeech" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickAVSpeech:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // 只执行一次
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"once1" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickOnce:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"once2" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickOnce2:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // 显示阴影
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"show shade" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickOnce2:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // Block AlertView
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"Block AlertView" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickBtnBlockAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // Block ActionSheet
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"Block ActionSheet" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickBtnBlockActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    // SHOWMBProgressHUD
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"SHOWMBProgressHUD" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickBtnSHOWMBProgressHUDIndeterminate:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
   
    // Block UIButton
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"Block UIButton" forState:UIControlStateNormal];
    [tempBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLogD(@"Block UIButton")
    }];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"new girl" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickNewGirl:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"view bind data" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickViewBindData:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    TestView *testView = [[[PaintCodeView alloc] initWithFrame:CGRectMake(10, btnOffsetY, 200, 200)] autorelease];
    _testView = testView;
    [scroll addSubview:testView];
     btnOffsetY += 220;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"change view data" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickChangeViewData:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"send message" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickSendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"cache" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickStringCache:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"emoji" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"Crossfade" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickCrossfade:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"Cube" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickCube:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
#pragma mark -btn end
    tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.backgroundColor = [UIColor lightGrayColor];
    tempBtn.frame = CGRectMake(10, btnOffsetY, 200, 44);
    [tempBtn setTitle:@"OglFlip" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(clickOglFlip:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:tempBtn];
    btnOffsetY += 64;
    
    scroll.contentSize = CGSizeMake(Screen_WIDTH - 20, btnOffsetY + 100);
    
    [self someTest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) expChanged:(id)value{
    NSLogD(@"vlaue:%@", value);
}
- (IBAction)clickBtn1:(id)sender {
    /*
    [[XYTimer sharedInstance] startTimerWithInterval:2];
    [XYTimer sharedInstance].delegate = self;
     */
    // kvo
    self.testKVO = self.testKVO + 1;
    self.myGirl.name = [NSString stringWithFormat:@"%d", self.testKVO];
    id j = [self valueForKeyPath:@"testKVO"];
    NSLog(@"%@", j);
    
    // 观察array
    [self willChangeValueForKey:@"testArrayKVO"];
    [self.testArrayKVO addObject:@"a"];
    [self didChangeValueForKey:@"testArrayKVO"];
}

- (IBAction)clickBtn2:(id)sender {
    [[XYTimer sharedInstance] pauseTimer];
}
- (IBAction)clickBtnMuhud:(id)sender {
    UIButton* btn=(UIButton*) sender;
    XYAnimateSerialStep *steps = [XYAnimateSerialStep animate];
    XYAnimateStep *step1 = [XYAnimateStep duration:0.15 animate:^{
        btn.transform = CGAffineTransformMakeScale(.5, .5);
    }];
    XYAnimateStep *step2 = [XYAnimateStep duration:0.2 animate:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    XYAnimateStep *step3 = [XYAnimateStep duration:0.15 animate:^{
        btn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
    XYAnimateStep *step4 = [XYAnimateStep duration:0.1 animate:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    [[[[steps addStep:step1] addStep:step2] addStep:step3] addStep:step4];
    
    [steps run];
}
- (IBAction)clickAVSpeech:(id)sender {
    if (IOS7_OR_LATER) {
        NSLogD(@"1")
        
        AVSpeechSynthesizer *av = [[[AVSpeechSynthesizer alloc] init] autorelease];
        AVSpeechUtterance *utterance = [[[AVSpeechUtterance alloc] initWithString:@"Copyright (c) 2013 Heaven. All rights reserved"] autorelease];
     //   utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        utterance.pitchMultiplier = 1;
        [av speakUtterance:utterance];
    }else{
        NSLogD(@"2")
        SHOWMBProgressHUD(@"only show on IOS7", nil, nil, NO, 2)
    }
    
}

- (IBAction)clickOnce:(id)sender {
    XY_ONCE_BEGIN(a)
    SHOWMBProgressHUD(@"only show once", nil, nil, NO, 2)
    XY_ONCE_END
}

- (IBAction)clickOnce2:(id)sender {
    XY_ONCE_BEGIN(b)
    SHOWMBProgressHUD(@"only show once2", nil, nil, NO, 2)
    XY_ONCE_END
}
- (IBAction)clickBtnShade:(id)sender {
    [self.view addShadeWithTarget:self action:@selector(closeShade) color:nil alpha:0.7];
}
- (IBAction)clickBtnBlockAlertView:(id)sender {
    UIAlertView *alertView = [self showMessage:NO title:@"title" message:@"msg" cancelButtonTitle:@"cancel" otherButtonTitles:@"1",@"2", nil];
    [alertView handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        NSLogD(@"%d", btnIndex);
    }];
    [alertView show];
}

- (IBAction)clickBtnBlockActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"title" delegate:nil cancelButtonTitle:@"cancel" destructiveButtonTitle:@"destructive" otherButtonTitles:@"other1", @"other2", nil] autorelease];
    [actionSheet handlerClickedButton:^(UIActionSheet *actionSheet, NSInteger btnIndex) {
        NSLogD(@"%d", btnIndex);
    }];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)clickBtnSHOWMBProgressHUDIndeterminate:(id)sender {
    MBProgressHUD *hub = SHOWMBProgressHUDIndeterminate(@"title", @"message", NO)
    [hub addTapGestureWithBlock:^{
        HIDDENMBProgressHUD
    }];
    BACKGROUND_BEGIN
    sleep(3);
    FOREGROUND_BEGIN
    HIDDENMBProgressHUD
    FOREGROUND_COMMIT
    BACKGROUND_COMMIT
}
-(void) clickNewGirl:(id)sender{
    NSMutableDictionary *me = [NSMutableDictionary dictionary];
    // 从 GirlEntity类 创建一个妹子
    GirlEntity *girl1 = [[[GirlEntity alloc] init] autorelease];
    girl1.name = @"妹子1";
    [me setObject:girl1 forKey:@"girlFriend"];
    
    // 创建一个NSObject对象, 然后添加属性,把他设置成妹子
    NSObject *girl2 = [[[NSObject alloc] init] autorelease];
    objc_setAssociatedObject(girl2, "name", @"妹子2", OBJC_ASSOCIATION_COPY);
    [me setObject:girl2 forKey:@"girlFriend2"];
    
    // 动态创建一个妹子类,然后创建一个妹子
    const char *className = "Girl3";
    Class kclass = objc_getClass(className);
    if (!kclass)
    {
        Class superClass = [NSObject class];
        kclass = objc_allocateClassPair(superClass, className, 0);
    }
    
    NSUInteger size;
    NSUInteger alignment;
    NSGetSizeAndAlignment("*", &size, &alignment);
    class_addIvar(kclass, "name", size, alignment, "*");
    
    // 注册到运行时环境
    objc_registerClassPair(kclass);
    
    id girl3 = [[[kclass alloc] init] autorelease];
    object_setInstanceVariable(girl3, "name", "妹子3");
    
    [me setObject:girl3 forKey:@"girlFriend3"];
    
    // 挖墙角
    GirlEntity *girl4 = [[[GirlEntity alloc] init] autorelease];
    girl4.name = @"女神";
    
    SEL original = @selector(talk);
    SEL replacement = @selector(talk2);
    
    Method a = class_getInstanceMethod([GirlEntity class], original);
    Method b = class_getInstanceMethod([self class], replacement);
    if (class_addMethod([GirlEntity class], original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod([GirlEntity class], replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
    
    [girl4 talk];
    
    
    NSLogD(@"%@", me);
}
-(void) talk2{
    NSString *name = [self valueForKey:@"name"];
    if ([name isEqualToString:@"女神"]) {
        // do 你懂的
        NSLog(@"%s", __FUNCTION__);
    }
}

-(void) clickViewBindData:(id)sender{
    
    NSDictionary *dic = @{@"label1": @(self.testKVO), @"img1": @"headportrait.jpg"};
    [_testView bindDataWithDic:dic];
}
-(void) clickChangeViewData:(id)sender{
    
}

-(void) clickSendMessage:(id)sender{
    /*
    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init]; autorelease];
    controller.recipients = [NSArray arrayWithObject:@"15988888888"];
    controller.body = @"请直接将此条认证短信发送给我们，以完成手机安全绑定。(9qzkd27953ma)";
    controller.messageComposeDelegate = self;
    
    [self presentModalViewController:controller animated:YES];
    //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"SomethingElse"];//修改短信界面标题
     */
}
-(void) clickStringCache:(id)sender{
    static int iKey = 0;
    
    XYObjectCache *cache = [XYObjectCache sharedInstance];
    [cache registerObjectClass:[NSString class]];
    NSString *key = [NSString stringWithFormat:@"%d", iKey];
    
    NSString *str = nil;
    if (![cache hasCachedForURL:key]) {
        str = @"hello world";
    }else{
        str = [cache objectForURL:key];
        NSLogD(@"%@", str);
        str = [str stringByAppendingString:@"1"];
        iKey++;
        key = [NSString stringWithFormat:@"%d", iKey];
    }

    if ( 0 ) {
        // 异步
        FOREGROUND_BEGIN
        [cache saveToMemory:str forURL:key];
        
        BACKGROUND_BEGIN
        [cache saveToData:[str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] forURL:key];
        BACKGROUND_COMMIT
        FOREGROUND_COMMIT
    }
    else {
        // 同步
        [cache saveToData:[str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] forURL:key];
        [cache saveToMemory:str forURL:key];
    }
    
    NSLogD(@"%@", str);
}
-(void) clickEmoji:(id)sender{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 80)] autorelease];
   // label.font = [UIFont fontWithName:@"AppleColorEmoji" size:12.0];
    label.text = @"This is a smiley \ue415 face";
    
    [label popupWithtype:PopupViewOption_none touchOutsideHidden:YES succeedBlock:nil dismissBlock:nil];
    [label.po_frameBuilder centerInSuperview];
}

-(void) clickCrossfade:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn setImage:LoadImage_cache(@"headportrait.jpg") forState:UIControlStateNormal];
    [btn animationCrossfadeWithDuration:5];
}

-(void) clickCube:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn setImage:LoadImage_cache(@"headportrait.jpg") forState:UIControlStateNormal];
    [btn animationCubeWithDuration:5 direction:kCATransitionFromRight];
}

-(void) clickOglFlip:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn setImage:LoadImage_cache(@"headportrait.jpg") forState:UIControlStateNormal];
    [btn animationOglFlipWithDuration:5 direction:kCATransitionFromTop];
}
/////////////////////////// 备注 ///////////////////////////////
/*
void objc_setAssociatedObject(id object, void *key, id value, objc_AssociationPolicy policy) {
    if (UseGC) {
        //这部分是有垃圾回收机制的实现，我们不用管
        if ((policy & OBJC_ASSOCIATION_COPY_NONATOMIC) == OBJC_ASSOCIATION_COPY_NONATOMIC) {
            value = objc_msgSend(value, @selector(copy));
        }
        auto_zone_set_associative_ref(gc_zone, object, key, value);
    } else {
        //这是引用计数机制部分的实现
        // Note, creates a retained reference in non-GC.
        _object_set_associative_reference(object, key, value, policy);
    }
}
 */

// 自动布局
/*
- (void)loadView
{
    //initalize
    AutoSizeView *view = [[AutoSizeView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 108.0)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 64.0) style:UITableViewStylePlain];
    
    //config view
    [view setBackgroundColor:[UIColor colorWithWhite:47.0/255.0 alpha:1.0]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    tableView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    // assige view
    self.view = view;
    self.tableView = tableView;
    [view release];
    [tableView release];
    
    //addsubview
    [self.view addSubview:self.tableView];
}
*/
-(void) testKVOChanged:(id)value{
    NSLogD(@"vlaue:%@", value);
}
-(void) testKVOChanged2:(id)value{
    NSLogD(@"vlaue:%@", value);
}
-(void) testArrayKVOChanged:(id)value{
    NSLogD(@"vlaue:%@", value);
}


#pragma mark - XYTimerDelegate
-(void) onTimer:(NSString *)timer time:(NSTimeInterval)ti{
    _testKVO++;
}
@end
