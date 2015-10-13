//
//  ClothModel.h
//  ClothStore
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 朱明科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClothModel : NSObject
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *ClickUrl;
@property(nonatomic,copy)NSString *cloth;
@property(nonatomic)NSNumber *clothingID;
@end
