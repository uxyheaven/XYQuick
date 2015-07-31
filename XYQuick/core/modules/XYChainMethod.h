//
//  XYChainMethod.h.h
//  JoinShow
//
//  Created by heaven on 15/5/14.
//  Copyright (c) 2015年 Heaven. All rights reserved.
//

#ifndef JoinShow_XYChainMethod_h_h
#define JoinShow_XYChainMethod_h_h

#import "XYQuick_Predefine.h"

// ----------------------------------
// public
// ----------------------------------

#define uxy_as_chainMethod(__blockType, __methodName)  \
        - (__blockType)__methodName;

#define uxy_def_chainMethod(__blockType, __methodName, ...)            \
        metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))         \
        (__uxy_chainMethod_1(__blockType, __methodName, __VA_ARGS__))    \
        (__uxy_chainMethod_2(__blockType, __methodName, __VA_ARGS__))


// ----------------------------------
// private
// ----------------------------------
#define __uxy_chainMethod_1(__blockType, __methodName, __propertyName) \
        - (__blockType)__methodName \
        {   \
            __blockType block = ^ id (id __propertyName){ \
            self.__propertyName = __propertyName;  \
            return self;    \
        };  \
            return block;   \
        }

#define __uxy_chainMethod_2(__blockType, __methodName, __propertyName, __defaultValue) \
        - (__blockType)__methodName \
        {   \
            __blockType block = ^ id (void){ \
            self.__propertyName = __defaultValue;  \
            return self;    \
        };  \
            return block;   \
        }

#endif
