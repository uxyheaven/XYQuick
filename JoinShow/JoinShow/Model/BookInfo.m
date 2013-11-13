//
//  BookInfo.m
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-1-14.
//
//

#import "BookInfo.h"

@implementation BookInfo{
    
}

@synthesize Level;
@synthesize BookNo;
@synthesize seriesno;
@synthesize iPadOrder;
@synthesize idbook;
@synthesize title;
@synthesize pcTWPCredit;
@synthesize cover_path;
@synthesize publisher;
@synthesize genre;
@synthesize description;
@synthesize ageGroupFrom;
@synthesize ageGroupTo;
@synthesize specialOffer;
@synthesize version;
@synthesize userVersion;
@synthesize isPurchased;
@synthesize WordCount;
@synthesize Author;
@synthesize IllustratedBy;
@synthesize FictionType;
@synthesize keywords;
@synthesize ISBN_Paperback;
@synthesize ISBN_Digital;
@synthesize pagecount;
@synthesize MD5Checksum;

@synthesize color;
@synthesize download;
@synthesize localVersion;

+ (void)mapRelation
{
	[super mapRelation];
   // [super useAutoIncrement];
    [super mapPropertyAsKey:@"idbook"];
}
-(void)dealloc{
    self.Level = nil;
    self.BookNo = nil;
    self.seriesno = nil;
    self.iPadOrder = nil;
    self.idbook = nil;
    self.title = nil;
    self.pcTWPCredit = nil;
    self.cover_path = nil;
    self.publisher = nil;
    self.genre = nil;
    self.description = nil;
    self.ageGroupFrom = nil;
    self.ageGroupTo = nil;
    self.specialOffer = nil;
    self.version = nil;
    self.userVersion = nil;
    self.isPurchased = nil;
    self.WordCount = nil;
    self.Author = nil;
    self.IllustratedBy = nil;
    self.FictionType = nil;
    self.keywords = nil;
    self.ISBN_Paperback = nil;
    self.ISBN_Digital = nil;
    self.pagecount = nil;
    self.MD5Checksum = nil;
    
    self.color = nil;
    self.download = nil;
    self.localVersion = nil;
    
    [super dealloc];
}
// 屏蔽
/*
+(id)bookWithDic:(NSMutableDictionary *)aDic{
    BookInfo *tmp = [[[BookInfo alloc] init] autorelease];
    if (tmp) {
        tmp.idbook = [aDic objectForKey:@"idbook"];
        tmp.title = [aDic objectForKey:@"title"];
        tmp.pcTWPCredit = [aDic objectForKey:@"pcTWPCredit"];
        tmp.cover_path = [aDic objectForKey:@"coverpath"];
        tmp.publisher = [aDic objectForKey:@"publisher"];
        tmp.genre = [aDic objectForKey:@"genre"];
        tmp.description = [aDic objectForKey:@"description"];
        tmp.ageGroupFrom = [aDic objectForKey:@"ageGroupFrom"];
        tmp.ageGroupTo = [aDic objectForKey:@"ageGroupTo"];
        tmp.specialOffer = [aDic objectForKey:@"specialOffer"];
        tmp.version = [aDic objectForKey:@"version"];
        tmp.isPurchased = [aDic objectForKey:@"isPurchased"];
        tmp.download = [aDic objectForKey:@"download"];
        
        NSRange tmpRange = [XYCommon rangeOfString:tmp.cover_path pointStart:0 start:@"covers/" end:@"/" mark:@"s/" operation:kFront];
        if (tmpRange.length == 0) {
            //  SHOWMSG(@"", @"颜色获取错误", @"");
        }else{
            tmpRange.location +=7;
            tmpRange.length -=8;
            NSString *aColor = [tmp.cover_path substringWithRange:tmpRange];
            tmp.color = aColor;
        }
    }
    
    return tmp;
}
*/
@end
