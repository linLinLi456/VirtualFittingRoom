//
//  DetailModel.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "JSONModel.h"

@interface DetailModel : JSONModel
@property(nonatomic)NSNumber *ShareID;
@property(nonatomic,copy)NSString *SmallPath;
@property(nonatomic,copy)NSString *OldPath;
@property(nonatomic,copy)NSString *NewPath;
@property(nonatomic,copy)NSString *IsBest;
@property(nonatomic,copy)NSString *PetName;
@property(nonatomic,copy)NSString *Remark;
@property(nonatomic)NSNumber *Flowers;
@property(nonatomic)NSNumber *Eggs;
@property(nonatomic)NSNumber *Hits;
@property(nonatomic)NSNumber *ReplayNumber;
@end
