//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Copyright (C) Heaven.
//
//	https://github.com/uxyheaven/XYQuick
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "XYBaseViewController.h"
#import <objc/runtime.h>

#pragma mark - def

#pragma mark - override

#pragma mark - api

#pragma mark - model event
#pragma mark 1 notification
#pragma mark 2 KVO

#pragma mark - view event
#pragma mark 1 target-action
#pragma mark 2 delegate dataSource protocol

#pragma mark - private
#pragma mark - getter / setter

#pragma mark -

@interface XYBaseViewControllerHelper : NSObject

+ (instancetype)sharedInstance;
+ (void)purgeSharedInstance;

@property (nonatomic, strong) NSMutableArray *vcContainers;

@end

@interface XYViewControllerContainer: NSObject
@property (nonatomic, weak) UIViewController *vc;
@end

@implementation XYViewControllerContainer
@end


@interface UIViewController (XYBase_private)

// 某些vc(UITableViewController)加载的时候不执行loadView方法
@property (nonatomic, assign) BOOL __uxy_isExecutedLoadView;

+ (void)__uxy_swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement;

@end

@implementation UIViewController (XYBase)

+ (void)load
{
    @autoreleasepool {
        [self __uxy_swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(loadView) replacementSel:@selector(__uxy__loadView)];
        [self __uxy_swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(viewDidLoad) replacementSel:@selector(__uxy__viewDidLoad)];
        [self __uxy_swizzleInstanceMethodWithClass:[UIViewController class] originalSel:NSSelectorFromString(@"dealloc") replacementSel:@selector(__uxy__dealloc)];
        [self __uxy_swizzleInstanceMethodWithClass:[UIViewController class] originalSel:@selector(didReceiveMemoryWarning) replacementSel:@selector(__uxy__didReceiveMemoryWarning)];
    }
}

- (void)__uxy__loadView
{
    [self __uxy__loadView];
    [self __uxy__loadViewHandle];
}

- (void)__uxy__dealloc
{
    if ([self respondsToSelector:@selector(uxy_destroyEvents)])
        [self performSelector:@selector(uxy_destroyEvents)];
    
    if ([self respondsToSelector:@selector(uxy_destroyViews)])
        [self performSelector:@selector(uxy_destroyViews)];
    
    if ([self respondsToSelector:@selector(uxy_destroyFields)])
        [self performSelector:@selector(uxy_destroyFields)];
    
    [self __uxy__dealloc];
}

- (void)__uxy__viewDidLoad
{
    [self __uxy__loadViewHandle];
    
    if ([self respondsToSelector:@selector(uxy_loadData)])
        [self performSelector:@selector(uxy_loadData)];
    
    [self __uxy__viewDidLoad];
}

- (void)__uxy__didReceiveMemoryWarning
{
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        if ([self respondsToSelector:@selector(uxy_cleanData)])
            [self performSelector:@selector(uxy_cleanData)];
    }
    
    [self __uxy__didReceiveMemoryWarning];
}

#pragma mark - private
- (void)__uxy__loadViewHandle
{
    if (self.__uxy_isExecutedLoadView) return;
    
    self.__uxy_isExecutedLoadView = YES;

    if ([self respondsToSelector:@selector(uxy_createFields)])
        [self performSelector:@selector(uxy_createFields)];
    
    if ([self respondsToSelector:@selector(uxy_createViews)])
        [self performSelector:@selector(uxy_createViews)];
    
    if ([self respondsToSelector:@selector(uxy_createEvents)])
        [self performSelector:@selector(uxy_createEvents)];
    
    if ([self respondsToSelector:@selector(uxy_enterBackground)] || [self respondsToSelector:@selector(uxy_enterForeground)])
    {
        XYViewControllerContainer *container = [[XYViewControllerContainer alloc] init];
        container.vc = self;
        [[XYBaseViewControllerHelper sharedInstance].vcContainers addObject:container];
    }
}
@end

@implementation UIViewController(XYBase_private)

uxy_staticConstString(UIViewController_isExecuted_loadView)
- (BOOL)__uxy_isExecutedLoadView
{
    return [objc_getAssociatedObject(self, UIViewController_isExecuted_loadView) boolValue];
}
-(void)set__uxy_isExecutedLoadView:(BOOL)__uxy_isExecutedLoadView
{
        objc_setAssociatedObject(self, UIViewController_isExecuted_loadView, @(__uxy_isExecutedLoadView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)__uxy_swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method a = class_getInstanceMethod(clazz, original);
    Method b = class_getInstanceMethod(clazz, replacement);

    if (class_addMethod(clazz, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(clazz, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}
@end

#pragma mark-

#pragma mark -

@implementation XYBaseViewControllerHelper

static id __singleton__objc__token;
static dispatch_once_t __singleton__token__token;
+ (instancetype)sharedInstance
{
    dispatch_once(&__singleton__token__token, ^{ __singleton__objc__token = [[self alloc] init]; });
    return __singleton__objc__token;
}

+ (void)purgeSharedInstance
{
    __singleton__objc__token  = nil;
    __singleton__token__token = 0;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vcContainers = [@[] mutableCopy];
        [self registerLifecycleNotification];
    }
    return self;
}

- (void)registerLifecycleNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)onEnterBackground
{
    for (NSUInteger i = _vcContainers.count; i > 0; i--)
    {
        XYViewControllerContainer *container = self.vcContainers[i - 1];
        if (container.vc == nil)
        {
            [_vcContainers removeObjectAtIndex:(i - 1)];
            continue;
        }
        
        if ([container.vc respondsToSelector:@selector(uxy_enterBackground)])
        {
            [container.vc performSelector:@selector(uxy_enterBackground) withObject:nil];
        }
    }
}

- (void)onEnterForeground
{
    for (NSUInteger i = _vcContainers.count; i > 0; i--)
    {
        XYViewControllerContainer *container = self.vcContainers[i - 1];
        if (container.vc == nil)
        {
            [_vcContainers removeObjectAtIndex:(i - 1)];
            continue;
        }
        
        if ([container.vc respondsToSelector:@selector(uxy_enterForeground)])
        {
            [container.vc performSelector:@selector(uxy_enterForeground) withObject:nil];
        }
    }
}

@end




