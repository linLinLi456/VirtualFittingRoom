//
//  DbManager.m
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "DataManager.h"
@interface DataManager(){
    FMDatabase *_database;
}
@end



@implementation DataManager

+(DataManager *)sharedManger{
    static DataManager *manager=nil;
   static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager=[[DataManager alloc]init];
    });
    return manager;
}
-(id)init{
    if (self=[super init]) {
        NSString *docpath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        
            NSString *filepath=[docpath stringByAppendingPathComponent:@"cloth.db"];
            _database=[[FMDatabase alloc]initWithPath:filepath];
            if ([_database open]) {
                NSLog(@"数据库打开成功");
                [self createtable];
            }
        }
    return self;
}
-(void)createtable{
    
        NSString *sql=@"create table if not exists clothInfo(ClothingID NSNumber primary key,Title text,ClickUrl varchar(1024))";
        if ([_database executeUpdate:sql]) {
            NSLog(@"创建表格成功");
        }

    
}
-(void)insertModel:(ClothModel1 *)model{
    if ([self isExistClothForclothID:model.ClothingID]) {
        NSLog(@"已存在");
    }else{
        NSString *sql=@"insert into clothInfo values(?,?,?)";
       BOOL flag= [_database executeUpdate:sql,model.ClothingID,model.Title,model.ClickUrl];
        if (flag) {
            NSLog(@"插入成功");
            
        }
    }
    //[_database close];
}
-(BOOL)isExistClothForclothID:(NSNumber *)ClothingID{
    NSString *sql=@"select *from clothInfo where ClothingID=?";
   FMResultSet *set=[_database executeQuery:sql,ClothingID];
    
    return [set next];
}
-(void)deleteModel:(NSNumber *)ClothingID{
    NSString *sql=@"delete from clothInfo where ClothingID=?";
    [_database executeUpdate:sql,ClothingID];
}
-(NSMutableArray *)fetch{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *sql = @"select *from clothInfo";
   FMResultSet *set = [_database executeQuery:sql];
    while ([set next]) {
        ClothModel1 *model = [[ClothModel1 alloc]init];
        model.ClothingID = (NSNumber *)[set stringForColumn:@"ClothingID"];
        model.Title = [set stringForColumn:@"title"];
        model.ClickUrl = [set stringForColumn:@"ClickUrl"];
        
        [arr addObject:model];
    }
    
    return arr;
}
@end
