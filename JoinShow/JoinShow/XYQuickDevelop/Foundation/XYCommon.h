//
//  XYFunction.h
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-7-10.
//
//

// 一大堆零散的方法
#import "XYPrecompile.h"

@class MBProgressHUD;
@class ASIHTTPRequest;

@class XYCommon;

#undef	$
#define $ __getTestBlock( self )
typedef	XYCommon *			(^XYCommonBlockTest)( id first, ... );
typedef	XYCommonBlockTest	(^XYCommonContextBlock)( id context );
XYCommonBlockTest	__getTestBlock( id context );


@interface XYCommon : NSObject{
 
}

typedef enum {
    filePathOption_documents = 1,
    filePathOption_tmp,
    filePathOption_app,
    filePathOption_resource,
} FilePathOption;

/** 
 * @brief 返回文件路径
 * @param file 文件名
 * @param kType 文件所在目录类型. documents:documents文件夹, tmp:Tmp文件夹, app,resource:app文件夹
 * @return 文件路径
 */
+ (NSString *)dataFilePath:(NSString *)file ofType:(FilePathOption)kType;

/** 
 * @brief 创建目录, 已经移植到XYSandbox
 * @param aPath 目录路径
 */
+ (void)createDirectoryAtPath:(NSString *)aPath;


/**
 * @brief Unicode格式的字符串编码转成中文的方法(如\u7E8C)转换成中文, unicode编码以\u开头, 已经移植到NSString(XY)
 * @param unicodeStr 需要被转的字符串
 * @return 转换后的字串
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;


typedef enum {
    MarkOption_middle = 1,
    MarkOption_front,
    MarkOption_back,
} MarkOption;
/**
 * @brief 返回字符串的位置的方法
 * @param rangeOfString:返回range. rangeArrayOfString:返回range数组
 * @param str 在str中查找
 * @param iStart 查找起始位置
 * @param strMark 需要查找的字符串的标记
 * @param strStart 起始标记
 * @param strEnd 结束标记
 * @param operation 模式. MarkOption_middle mark在Start和end中间,当Start=mark时,返回 Start和end中间的Range, MarkOption_front: mark在Start和end前面,MarkOption_back: mark在Start和end后面
 * @param block 每一个字符串都执行该block
 * @return 范围
 */
+ (NSRange) rangeOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation;
+ (NSMutableArray *) rangeArrayOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation;
+ (NSMutableArray *) rangeArrayOfString:(NSString *)str pointStart:(int)iStart start:(NSString *)strStart end:(NSString *)strEnd mark:(NSString *)strMark operation:(MarkOption)operation everyStringExecuteBlock:(void(^)(NSRange rangeEvery))block;



#define XYCommon_lastLocation -1
/**
 * @brief 返回没有属性的xml中指定节点的值的方法
 * @param str xml字符串
 * @param akey 节点名
 * @param location 起始位置
 * @param operation 模式. XYCommon_lastLocation 从上次结束的位置开始查找,提高效率
 * @return 返回没有属性的xml中指定节点的值
 */
+ (NSString *)getValueInANonAttributeXMLNode:(NSString *)str key:(NSString *)akey location:(int)location;


/**
 * @brief 正则表达式分析字符串的方法
 * @param analyseString  返回NSString数组. analyseStringToRange:返回range数组
 * @param str 被分析的字符串
 * @param regexStr 用于分析str的正则表达式 (.|[\r\n])*? 表示任何多个字符，包括换行符，懒惰扫描
 * @param options (已取消)匹配选项使用
 * @return 结果的字符串的array
 */
+ (NSMutableArray *)analyseString:(NSString *)str regularExpression:(NSString *)regexStr;
+ (NSMutableArray *)analyseStringToRange:(NSString *)str regularExpression:(NSString *)regexStr;

#pragma mark todo, 分享facebook,发EMail
/**
 * @brief 分享至Twitter的方法
 * @param strText 需要分享的文字
 * @param picPath 图片路径
 * @param strURL URL地址
 * @param vc Twitter的父视图控制器,目前版本请用nil,默认为[UIApplication sharedApplication].delegate.window.rootViewControlle
 */
+ (void)shareToTwitterWithStr:(NSString *)strText withPicPath:(NSString *)picPath withURL:(NSString*)strURL inController:(id)vc;


/**
 * @brief 返回UUID
 * @return UUID
 */
+ (NSString *)UUID;
// 没有"-"
+ (NSString *)UUIDWithoutMinus;

/**
 * @brief 用[UIApplication sharedApplication]打开一个URL
 * @param url http:// 浏览器, mailto:// 邮件, tel:// 拨号, sms: 短信
 */
+ (void)openURL:(NSURL *)url;

/**
 * @brief 得到当前UIViewController
 * @return 当前UIViewController
 */
+ (UIViewController *)topMostController;


#define SHOWMSG(title, msg, cancel) [XYCommon showAlertViewTitle:title message:msg cancelButtonTitle:cancel];
/**
 * @brief 显示UIAlertView
 * @param aTitle msg标题
 * @param msg 信息
 * @param strCancel 取消按钮标题
 */
+ (void)showAlertViewTitle:(NSString *)aTitle message:(NSString *)msg cancelButtonTitle:(NSString *)strCancel;

/**
 * @brief 替换string里面的单引号'为2个单引号'',用于处理SQL问题
 */
+ (NSString *)StringForSQL:(NSString *)str;

/**
 * @brief 返回日期格式器
 * @return dateFormatter yyyy-MM-dd HH:mm:ss. dateFormatterTemp 很多地方共用的. dateFormatterByUTC 返回UTC格式的
 */
+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)dateFormatterTemp;
+ (NSDateFormatter *)dateFormatterByUTC;

/**
 * @brief  打印内存情况
 * @param mark 标记
 */
+ (void)printUsedAndFreeMemoryWithMark:(NSString *)mark;


/** 
 * @brief 版本号比大小, Version format[X.X.X]
 * @param oldVersion 旧版本号
 * @param newVersion 新版本号
 * @return 比较oldVersion和newVersion, NSOrderedAscending 左边比右边的小
 */
+ (NSComparisonResult)compareVersionFromOldVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion;


#pragma mark - to do

@end
