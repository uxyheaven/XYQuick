//
//  BookInfo.h
//  TWP_SkyBookShelf
//
//  Created by Heaven on 13-1-14.
//
//
#define kIdbook 1
#define kTitle 3
#define kPcTWPCredit 5
#define kCover_path 7
#define kPublisher 9
#define kGenre 11
#define kDescription 13
#define kAgeGroupFrom 15
#define kAgeGroupTo 17
#define kSpecialOffer 19
#define kVersion 21
#define kUserVersion 23
#define kIsPurchased 25

#import <Foundation/Foundation.h>

@interface BookInfo : NSObject{
}

@property (nonatomic, copy) NSString *Level;
@property (nonatomic, copy) NSString *BookNo;
@property (nonatomic, copy) NSString *seriesno;
@property (nonatomic, copy) NSString *iPadOrder;
@property (nonatomic, copy) NSString *idbook;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pcTWPCredit;
@property (nonatomic, copy) NSString *cover_path;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *ageGroupFrom;
@property (nonatomic, copy) NSString *ageGroupTo;
@property (nonatomic, copy) NSString *specialOffer;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *userVersion;
@property (nonatomic, copy) NSString *isPurchased;
@property (nonatomic, copy) NSString *WordCount;
@property (nonatomic, copy) NSString *Author;
@property (nonatomic, copy) NSString *IllustratedBy;
@property (nonatomic, copy) NSString *FictionType;          // 小说类型
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *ISBN_Paperback;
@property (nonatomic, copy) NSString *ISBN_Digital;
@property (nonatomic, copy) NSString *pagecount;
@property (nonatomic, copy) NSString *MD5Checksum;

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *localVersion;

//@property (nonatomic, assign) ASIHTTPRequest *request;

//+(id)bookWithDic:(NSMutableDictionary *)aDic;

@end
