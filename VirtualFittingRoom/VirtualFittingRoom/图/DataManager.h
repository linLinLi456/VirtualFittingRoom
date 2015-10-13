//
//  DbManager.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import"FMDatabase.h"
#import "ClothModel1.h"


@interface DataManager : NSObject


+(DataManager *)sharedManger;
-(void)insertModel:(ClothModel1 *)model;
-(BOOL)isExistClothForclothID:(NSNumber *)clothId;
-(void)deleteModel:(NSNumber *)ClothingID;
-(NSMutableArray *)fetch;
@end
