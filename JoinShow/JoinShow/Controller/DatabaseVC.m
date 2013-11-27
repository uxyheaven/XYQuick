//
//  DatabaseVC.m
//  JoinShow
//
//  Created by Heaven on 13-9-16.
//  Copyright (c) 2013年 Heaven. All rights reserved.
//

#import "DatabaseVC.h"
#import "LKTestModels.h"
#if (1 == __XYQuick_Framework__)
#import <XYQuick/XYQuickDevelop.h>
#else
#import "XYQuickDevelop.h"
#endif


@interface DatabaseVC ()
@property(strong, nonatomic) NSMutableString* ms;
@property(unsafe_unretained, nonatomic) UITextView* tv;
@end

@implementation DatabaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ms = [NSMutableString string];
    UITextView* textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.frame = CGRectMake(0, 20, 320, self.view.bounds.size.height);
    textView.textColor = [UIColor blackColor];
    [self.view addSubview:textView];
    self.tv = textView;
    [textView release];
    BACKGROUND_BEGIN
    [self test];
    BACKGROUND_COMMIT
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)add:(NSString*)txt
{
    FOREGROUND_BEGIN
        [_ms appendString:@"\n"];
        [_ms appendString:txt];
        [_ms appendString:@"\n"];
        
        self.tv.text = _ms;
   FOREGROUND_COMMIT
}
#define addText(fmt, ...) [self add:[NSString stringWithFormat:fmt,##__VA_ARGS__]]

-(void)test
{
    addText(@"示例 开始 example start \n\n");
    
    //清空数据库
    LKDBHelper* globalHelper = [LKDBHelper getUsingLKDBHelper];
    [globalHelper dropAllTable];
    
    //创建表  会根据表的版本号  来判断具体的操作 . create table need to manually call
    [globalHelper createTableWithModelClass:[LKTest class]];
    [globalHelper createTableWithModelClass:[LKTestForeign class]];
    
    addText(@"LKTest create table sql :\n%@\n",[LKTest getCreateTableSQL]);
    addText(@"LKTestForeign create table sql :\n%@\n",[LKTestForeign getCreateTableSQL]);
    
    //清空表数据   clear table data
    [LKDBHelper clearTableData:[LKTest class]];
    
    
    LKTestForeign* foreign = [[[LKTestForeign alloc] init] autorelease];
    foreign.address = @":asdasdasdsadasdsdas";
    foreign.postcode  = 123341;
    foreign.addid = 213214;
    
    //插入数据    insert table row
    LKTest* test = [[LKTest alloc]init];
    test.name = @"zhan san";
    test.age = 16;
    
    //外键 foreign key
    test.address = foreign;
    
    test.isGirl = YES;
    test.like = 'I';
    test.img = [UIImage imageNamed:@"p31b0001.png"];
    test.date = [NSDate date];
    test.color = [UIColor orangeColor];
    test.error = @"nil";
    
    //异步 插入第一条 数据   Insert the first
    [globalHelper insertToDB:test];
    
    [globalHelper executeDB:^(FMDatabase *db) {
        
        [db beginTransaction];
        
        test.name = @"1";
        [globalHelper insertToDB:test];
        test.name = @"2";
        [globalHelper insertToDB:test];
        
        test.name = @"3";
        test.rowid = 0;     //no new object,should set rowid:0
        BOOL insertSucceed = [globalHelper insertWhenNotExists:test];
        
        //insert fail
        if(insertSucceed == NO)
            [db rollback];
        else
            [db commit];
        
    }];
    
    
    addText(@"同步插入 完成!  Insert completed synchronization");
    
    sleep(1);
    
    
    //改个 主键 插入第2条数据   update primary colume value  Insert the second
    test.name = @"li si";
    [globalHelper insertToDB:test callback:^(BOOL isInsert) {
        addText(@"asynchronization insert complete: %@",isInsert>0?@"YES":@"NO");
    }];
    
    
    
    //查询   search
    addText(@"同步搜索    sync search");
    
    NSMutableArray* arraySync = [LKTest searchWithWhere:nil orderBy:nil offset:0 count:100];
    for (NSObject* obj in arraySync) {
        addText(@"%@",[obj printAllPropertys]);
    }
    
    addText(@"休息2秒 开始  为了说明 是异步插入的\n"
            "rest for 2 seconds to start is asynchronous inserted to illustrate");
    
    sleep(2);
    
    addText(@"休息2秒 结束 \n rest for 2 seconds at the end");
    
    //异步
    [globalHelper search:[LKTest class] where:nil orderBy:nil offset:0 count:100 callback:^(NSMutableArray *array) {
        
        addText(@"异步搜索 结束,  async search end");
        for (NSObject* obj in array) {
            addText(@"%@",[obj printAllPropertys]);
        }
        
        sleep(1);
        
        //修改    update
        LKTest* test2 = [array objectAtIndex:0];
        test2.name = @"wang wu";
        
        [globalHelper updateToDB:test2 where:nil];
        
        addText(@"修改完成 , update completed ");
        
        array =  [globalHelper search:[LKTest class] where:nil orderBy:nil offset:0 count:100];
        for (NSObject* obj in array) {
            addText(@"%@",[obj printAllPropertys]);
        }
        
        test2.rowid = 0;
        
        BOOL ishas = [globalHelper isExistsModel:test2];
        if(ishas)
        {
            //删除    delete
            [globalHelper deleteToDB:test2];
        }
        
        addText(@"删除完成, delete completed");
        sleep(1);
        
        array =  [globalHelper search:[LKTest class] where:nil orderBy:nil offset:0 count:100];
        for (NSObject* obj in array) {
            addText(@"%@",[obj printAllPropertys]);
        }
        
        addText(@"示例 结束  example finished\n\n");
        
        
        
        //Expansion: Delete the picture is no longer stored in the database record
        addText(@"扩展:  删除已不再数据库中保存的 图片记录 \n expansion: Delete the picture is no longer stored in the database record");
        //目前 已合并到LKDBHelper 中  就先写出来 给大家参考下
        
        [LKDBHelper clearNoneImage:[LKTest class] columes:[NSArray arrayWithObjects:@"img",nil]];
    }];
}

@end
