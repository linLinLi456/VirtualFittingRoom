//
//  DBManager.m
//  ClothStore
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import "DBManager.h"
#import "ClothModel.h"

@implementation DBManager
+(instancetype)sharedInstance{
    static DBManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[DBManager alloc]init];
    });
    return manager;
}
-(instancetype)init{
    if (self = [super init]) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"clothes.db"];
        self.dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        NSLog(@"%@",dbPath);
        if ([_dataBase open]) {
            NSLog(@"打开数据库成功");
            
            NSString *sql = @"create table if not exists clothInfo(price text, name text,image text Primary Key,clothUrl text,cloth text,clothingID number)";
            if ([self.dataBase executeUpdate:sql]) {
                NSLog(@"创建表格成功");
            }
            
            [self.dataBase close];
        }
    }
    return self;
    
}
-(void)insertModel:(ClothModel *)model{
    if ([self.dataBase open]) {
        NSString *sql = @"insert into clothInfo values(?,?,?,?,?,?)";
        if ([self.dataBase executeUpdate:sql,model.price,model.name,model.image,model.ClickUrl,model.cloth,model.clothingID]) {
            NSLog(@"收藏成功");
        }
        [self.dataBase close];
    }
}
-(BOOL)isExistClothForImage:(NSString *)image{
    if ([self.dataBase open]) {
        NSString *sql = @"select * from clothInfo where image = ?";
        if ([self.dataBase executeUpdate:sql,image]) {
            return YES;
        }
        [self.dataBase close];
    }
    return NO;
    
}
-(void)deleteModel:(ClothModel *)model{
    [self deleteModelForImageName:model.image];
}
-(void)deleteModelForImageName:(NSString *)imageName{
    NSString *sql = @"delete from clothInfo where image=?";
    if ([self.dataBase open]) {
        if ([self.dataBase executeUpdate:sql,imageName]) {
            NSLog(@"取消收藏成功");
        }
        [self.dataBase close];
    }
}

-(NSMutableArray *)fetch{
    NSString *sql = @"select * from clothInfo";
    if ([self.dataBase open]) {
        FMResultSet *set = [self.dataBase executeQuery:sql];
        NSMutableArray *clothesArray = [NSMutableArray array];
        while ([set next]) {
            ClothModel *model = [[ClothModel alloc]init];
            model.price = [set stringForColumn:@"price"];
            model.name = [set stringForColumn:@"name"];
            model.ClickUrl = [set stringForColumn:@"clothUrl"];
            model.image = [set stringForColumn:@"image"];
            model.cloth = [set  stringForColumn:@"cloth"];
            model.clothingID = [NSNumber numberWithInt:[set intForColumn:@"clothingID"]];
            [clothesArray addObject:model];
        }
        [self.dataBase close];
        return  clothesArray;
    }
    return nil;
}


























@end
