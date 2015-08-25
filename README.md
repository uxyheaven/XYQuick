#{XY} Quick

{XY} 快速开发框架是一个常用方法与常用模式的集合.封装了数据持久化,数据缓存（文件缓存,内存缓存）,kvo, Notification, delegate, 动画, 图片处理, 自定义了ViewController生命周期.

* 本库采用ARC

### XYQuick
#### core
* XYTimer 		// 定时器类
* XYKVO 	// KVO的封装
* XYNotification 	// NSNotification的封装
* XYSandbox 	// 沙箱路径
* XYSystemInfo //	系统信息
* cache         // 对象缓存,包含内存缓存, 文件缓存, UserDefaults
* XYJsonHelper 	// json to object , object to json
* XYAOP // 面向切面编程

#### event
* XYMulticastDelegate 	// 多路委托
* XYSignal				// 责任链信号
* XYNotification		// Notification的封装
* XYKVO			// KVO的封装
* XYFlyweightTransmit	// 轻量级的底层往高层传数据

#### ui
* XYKeyboardHelper		// 弹出键盘时,移动所编辑的控件的通用解决方案
* XYAnimate 	// UIView动画的封装
* XYTabBarController		// 自定义的UITabBarController
* XYBaseViewController		// UIViewController基类,自定义了ViewController的生命周期
* XYViewControllerManager		// UIViewController 管理类

### XYVender
* Extension 第三方库的一些简单包装,如
    * RequestHelper 网络通讯类
    * XYBaseDao 范化的本地dao类

### Laboratory
这里是一个实验室,里面有一些实验性质的代码.你可以参考这里的代码,如果觉得有用,可以自行拷贝到项目中.

---
## Installation
* 本库基于ARC
* 拷贝XYQuick到项目里
* 在需要用的文件或者pch里 `#import "XYQuick.h"
* 在 `XYQuick_Predefine` 开启或者关闭需要的编译选项()

### Podfile

```
pod 'XYQuick'

#import "XYQuick.h"
```

---