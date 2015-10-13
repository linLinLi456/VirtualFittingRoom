//
//  FirstModel.h
//  Demo
//
//  Created by qianfeng007 on 15-10-4.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "JSONModel.h"

@interface FirstModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *ShareID;
@property (nonatomic, copy) NSString<Optional> *SmallPath;
@property (nonatomic, copy) NSString<Optional> *Remark;

@end
