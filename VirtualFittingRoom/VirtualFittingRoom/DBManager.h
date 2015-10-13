//
//  DBManager.h
//  ClothStore
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ClothModel.h"

@interface DBManager : NSObject
@property(nonatomic)FMDatabase *dataBase;

+(instancetype)sharedInstance;
-(void)insertModel:(ClothModel *)model;
-(void)deleteModel:(ClothModel *)model;
-(BOOL)isExistClothForImage:(NSString *)image;
-(NSMutableArray *)fetch;

@end
