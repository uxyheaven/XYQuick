# XYQuick

[![CI Status](http://img.shields.io/travis/uxyheaven/XYQuick.svg?style=flat)](https://travis-ci.org/uxyheaven/XYQuick)
[![Version](https://img.shields.io/cocoapods/v/XYQuick.svg?style=flat)](http://cocoapods.org/pods/XYQuick)
[![License](https://img.shields.io/cocoapods/l/XYQuick.svg?style=flat)](http://cocoapods.org/pods/XYQuick)
[![Platform](https://img.shields.io/cocoapods/p/XYQuick.svg?style=flat)](http://cocoapods.org/pods/XYQuick)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XYQuick is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "XYQuick"
```

## Author

uxyheaven, uxyheaven@163.com

## License

XYQuick is available under the MIT license. See the LICENSE file for more info.
#{XY} Quick

{XY} 快速开发框架是用于快速高效开发的工具库.它包含`Core`, `Event`, `UI`三层,
封装了数据持久化,数据缓存（文件缓存,内存缓存）,kvo, Notification, delegate, 动画, 图片处理, 自定义了 ViewController 生命周期.

- 本库采用 ARC

### XYQuick

#### Core

- XYTimer // 定时器类
- XYKVO // KVO 的封装
- XYNotification // NSNotification 的封装
- XYSandbox // 沙箱路径
- XYSystemInfo // 系统信息
- XYJSON // json to object , object to json
- XYAOP // 面向切面编程
- XYProtocolExtension // 协议扩展
- XYReachability // 网络可达性检测

##### Cache

缓存模块, 包含内存缓存, 文件缓存, UserDefaults

##### Debug

调试模块, 包含单元测试, 时间统计

#### Event

- XYMulticastDelegate // 多路委托
- XYSignal // 责任链信号
- XYNotification // Notification 的封装
- XYKVO // KVO 的封装
- XYFlyweightTransmit // 轻量级的底层往高层传数据

#### UI

- XYKeyboardHelper // 弹出键盘时,移动所编辑的控件的通用解决方案
- XYAnimate // UIView 动画的封装
- XYTabBarController // 自定义的 UITabBarController
- XYBaseViewController // 自定义 ViewController 生命周期
- XYViewControllerManager // UIViewController 管理类

### XYVender

- Extension 第三方库的一些简单包装,如
  - RequestHelper 网络通讯类
  - XYBaseDao 范化的本地 dao 类

### Laboratory

这里是一个实验室,里面有一些实验性质的代码.你可以参考这里的代码,如果觉得有用,可以自行拷贝到项目中.

---

## Installation

- 本库基于 ARC
- 拷贝 XYQuick 到项目里
- 在需要用的文件或者 pch 里 `#import "XYQuick.h"
- 在 `XYQuick_Predefine` 开启或者关闭需要的编译选项()

### Podfile

```
pod 'XYQuick'

#import "XYQuick.h"
```

---
