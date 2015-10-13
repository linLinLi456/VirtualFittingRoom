//
//  Model.h
//  SharedView
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李娟. All rights reserved.
//

#import "JSONModel.h"
@class CellModel;
@protocol CellModel;

@interface CellModel : JSONModel

@property(nonatomic)NSNumber *ShareID;
@property(nonatomic,copy)NSString *SmallPath;
@property(nonatomic,copy)NSString *Remark;

@end
