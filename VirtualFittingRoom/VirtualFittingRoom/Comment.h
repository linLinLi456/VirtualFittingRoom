//
//  Comment.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import "JSONModel.h"


@interface Comment : JSONModel
@property(nonatomic)NSNumber *ShareReplayID;
@property(nonatomic,copy)NSString *Content;
@property(nonatomic,copy)NSString *UserName;
@property(nonatomic,copy)NSString *PubTime;
@property(nonatomic)NSNumber *Flowers;
@end
