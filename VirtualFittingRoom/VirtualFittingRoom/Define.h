//
//  Define.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#ifndef VirtualFittingRoom_Define_h
#define VirtualFittingRoom_Define_h
//全部
#define kAll  @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=18&pageIndex=%ld&isbest=&sn=&recordCount=0"
//#define kAll  @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
//http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=3&isbest=&sn=&recordCount=14217  /// 上拉刷新后

//精华
#define kBest @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=18&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
//http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=2&isbest=1&sn=&recordCount=4509  /// 上拉刷新后

//美女
#define kBeauty @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=18&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
//http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=2&isbest=12&sn=&recordCount=498   /// 上拉刷新后

//萌翻天
#define kCute @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=18&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
//http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=3&isbest=14&sn=&recordCount=334  /// 上拉刷新后
//·http://clothing.yyasp.net/download.aspx?SharePicture=2015_09_20_201509201829412941-small.jpg

//帅哥
#define kBoy @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=18&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
//http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=2&isbest=11&sn=&recordCount=111  /// 上拉刷新后
//http://clothing.yyasp.net/download.aspx?SharePicture=2015_08_14_201508141817141714-small.jpg

//卧槽
#define kWo @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=18&pageIndex=%ld&isbest=%ld&sn=&recordCount=0"
//http://clothing.yyasp.net/SharePicture_Phone.aspx?type=picture2&pageSize=15&pageIndex=2&isbest=13&sn=&recordCount=40    /// 上拉刷新后
//http://clothing.yyasp.net/download.aspx?SharePicture=2015_09_20_20150920200043043-small.jpg
#define kpicture @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=pictureID2&id=%@"
#define kPL @"http://clothing.yyasp.net/Json.aspx?ShareReplayShow=yes&ShareID=%@"

#define kNear @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=clothingshare&clothingID=%@&pageSize=3&pageIndex=1"

#define kMore @"http://clothing.yyasp.net/Json.aspx?ShareReplayShow=yes&ShareID=%@&pageSize=20&pageIndex=%ld"

#define kMuch @"http://clothing.yyasp.net/SharePicture_Phone.aspx?type=clothingshare&clothingID=%@&pageSize=9&pageIndex=%ld"

#define kImage @"http://clothing.yyasp.net/download.aspx?SharePicture=%@"

#endif
