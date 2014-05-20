//
//  XYUISignal.m
//  JoinShow
//
//  Created by Heaven on 14-5-19.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYUISignal.h"
#import "UIView+XY.h"


#undef	XYUISignal_NAMESPACE
#define XYUISignal_NAMESPACE	"UIView.nameSpace"

#pragma mark - XYUISignal
@implementation XYUISignal

-(instancetype)init
{
    self = [super init];
    if (self) {
        _isDead = NO;
        _isReach = NO;
        _jump = 0;
        _name = @"signal.nil.nil";
        _callPath = [NSMutableString string];
    }
    return self;
}

-(NSString *) description
{
	if ( _callPath.length ) {
		return [NSString stringWithFormat:@"%@ > %@", _name, _callPath];
	}
	else {
		return [NSString stringWithFormat:@"%@", _name];
	}
}

-(BOOL) is:(NSString *)name
{
	return [_name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [_name hasPrefix:prefix];
}

-(BOOL) isSentFrom:(id)source
{
	return (self.source == source) ? YES : NO;
}

-(BOOL) send
{
    if ( self.source )
	{
		UIView * sourceView = nil;
        
		if ( [self.source isKindOfClass:[UIView class]] ) {
			sourceView = self.source;
		} else if ( [self.source isKindOfClass:[UIViewController class]] ) {
			sourceView = ((UIViewController *)self.source).view;
		}
        
		if ( sourceView )
		{
			NSString * nameSpace = sourceView.nameSpace;	// .lowercaseString;
			NSInteger tag = sourceView.tag;	// .lowercaseString;
			
			NSString * selector = nil;
			if ( nameSpace) {
				selector = [NSString stringWithFormat:@"%@_%d", nameSpace, tag];
			}
            
			selector = [selector stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
			selector = [selector stringByReplacingOccurrencesOfString:@":" withString:@"_"];
			self.preSelector = selector;
		}
	}
    
    if ( [_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] ) {
		_jump = 1;
		
		[self routes];
	} else {
		_isReach = YES;
	}
    
    if ( _isDead )
		return NO;
    
	return _isReach;
}

-(BOOL) forward
{
	if ( nil == _target )
		return NO;
	
	if ( [_target isKindOfClass:[UIView class]] ) {
		UIView * targetView = ((UIView *)_target).superview;
		if ( targetView ) {
			[self forward:targetView];
		} else {
			_isReach = YES;
		}
	} else if ( [_target isKindOfClass:[UIViewController class]] ) {
		_isReach = YES;
	}
    
	return YES;
}
-(BOOL) forward:(id)target
{
	if ( _isDead )
		return NO;
    
#if (__XYUISIGNAL_USED_CALLPATH__ == 1)
	if ( [target isKindOfClass:[UIView class]] ) {
		[_callPath appendFormat:@" > %@(%d)", [[target class] description], [((UIView *)target) tag]];
	} else {
		[_callPath appendFormat:@" > %@", [[target class] description]];
	}
	if ( _isReach ) {
		[_callPath appendFormat:@" > [DONE]"];
	}
#endif
    
    if ( [_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] ) {
		_jump += 1;
		_target = target;
		
		[self routes];
	} else {
		_isReach = YES;
	}
    
	return _isReach;
}
-(void) routes{
    NSObject * targetObject = _target;
	if ( nil == targetObject )
		return;
	
	if ( [_target isKindOfClass:[UIView class]] ) {
		UIViewController *viewController = [(UIView *)_target viewController];
		if ( viewController ) {
			targetObject = viewController;
		}
	}

    Class rtti = [_source class];
	for ( ;; ) {
		if ( nil == rtti )
			break;
		
		NSString *	selectorName = [NSString stringWithFormat:@"handle%@:", [rtti description]];
		SEL			selector = NSSelectorFromString(selectorName);
        
		if ( selector && [targetObject respondsToSelector:selector] ) {
			[targetObject performSelector:selector withObject:self];
			break;
		}
        
		rtti = class_getSuperclass( rtti );
		if ( rtti == [UIResponder class] )
		{
			rtti = nil;
			break;
		}
	}

    if ( nil == rtti ) {
        if ( [targetObject respondsToSelector:@selector(handleUISignal:)] ) {
            [targetObject performSelector:@selector(handleUISignal:) withObject:self];
        }
    }
}

-(BOOL) boolValue
{
	if ( nil == _returnValue || NO == [_returnValue isKindOfClass:[NSNumber class]] )
		return NO;
    
	return [(NSNumber *)_returnValue boolValue];
}

-(void) returnYES
{
	self.returnValue = @YES;
}

-(void) returnNO
{
	self.returnValue = @NO;
}

@end


#pragma mark - UIView(XYUISignal)
@implementation UIView(XYUISignal)

@dynamic nameSpace;

-(NSString *) nameSpace
{
	NSObject * obj = objc_getAssociatedObject( self, XYUISignal_NAMESPACE );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

-(void) setNameSpace:(NSString *)value
{
	if ( nil == value )
		return;
	
	objc_setAssociatedObject( self, XYUISignal_NAMESPACE, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

+(NSString *) SIGNAL
{
	return [self SIGNAL_TYPE];
}

+(NSString *) SIGNAL_TYPE
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

-(void) handleUISignal:(XYUISignal *)signal
{
	if ( self.superview ) {
		[signal forward:self.superview];
	} else {
		signal.isReach = YES;
	}
}

-(XYUISignal *) sendUISignal:(NSString *)name
{
	return [self sendUISignal:name withObject:nil from:self];
}

-(XYUISignal *) sendUISignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendUISignal:name withObject:object from:self];
}

-(XYUISignal *) sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
	XYUISignal * signal = [[XYUISignal alloc] init];
    
	if ( signal ) {
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;
		signal.object = object;
		
		[signal send];
	}
    
	return signal;
}
@end

#pragma mark - UIViewController(XYUISignal)
@implementation UIViewController(XYUISignal)

@dynamic nameSpace;

-(NSString *) nameSpace
{
	NSObject * obj = objc_getAssociatedObject( self, XYUISignal_NAMESPACE );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

-(void) setNameSpace:(NSString *)value
{
	if ( nil == value )
		return;
	
	objc_setAssociatedObject( self, XYUISignal_NAMESPACE, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

+(NSString *) SIGNAL
{
	return [self SIGNAL_TYPE];
}

+(NSString *) SIGNAL_TYPE
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

-(void) handleUISignal:(XYUISignal *)signal
{
	signal.isReach = YES;
}

-(XYUISignal *) sendUISignal:(NSString *)name
{
	return [self sendUISignal:name withObject:nil from:self];
}

-(XYUISignal *) sendUISignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendUISignal:name withObject:object from:self];
}

-(XYUISignal *) sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
	XYUISignal *signal = [[XYUISignal alloc] init];
    
	if ( signal ) {
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;
		signal.object = object;
		
		[signal send];
	}
    
	return signal;
}
@end


#pragma mark - XYUISignal(SourceView)
@implementation XYUISignal(SourceView)

@dynamic sourceView;
@dynamic sourceViewController;

- (UIView *)sourceView
{
	if ( nil == self.source )
		return nil;
	
	if ( [self.source isKindOfClass:[UIView class]] ) {
		return (UIView *)self.source;
	} else if ( [self.source isKindOfClass:[UIViewController class]] ) {
		return ((UIViewController *)self.source).view;
	}
    
	return nil;
}

- (UIViewController *)sourceViewController
{
	if ( nil == self.source )
		return nil;
	
	if ( [self.source isKindOfClass:[UIView class]] ) {
		return [(UIView *)self.source viewController];
	} else if ( [self.source isKindOfClass:[UIViewController class]] ) {
		return (UIViewController *)self.source;
	}
    
	return nil;
}

@end





