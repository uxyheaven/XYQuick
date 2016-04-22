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
//  This file Copy from ProtocolKit.

#import "XYQuick_Predefine.h"
#pragma mark -

// For a magic reserved keyword color, use @uxy_defProtocolMethod(your_protocol_name)
#define uxy_defProtocolMethod __uxy_extension

// Interface
#define __uxy_extension($protocol) __uxy_extension_imp($protocol, __uxy_get_container_class($protocol))

// Implementation
#define __uxy_extension_imp($protocol, $container_class) \
        protocol $protocol; \
        @interface $container_class : NSObject <$protocol> @end \
        @implementation $container_class \
        + (void)load { \
            __uxy_protocolExtension_load(@protocol($protocol), $container_class.class); \
        } \

// Get container class name by counter
#define __uxy_get_container_class($protocol) __uxy_get_container_class_imp($protocol, __COUNTER__)
#define __uxy_get_container_class_imp($protocol, $counter) __uxy_get_container_class_imp_concat(__PKContainer_, $protocol, $counter)
#define __uxy_get_container_class_imp_concat($a, $b, $c) $a ## $b ## _ ## $c

void __uxy_protocolExtension_load(Protocol *protocol, Class containerClass);

