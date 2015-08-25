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
