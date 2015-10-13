//
//  UIImage+util.h
//  VirtualFittingRoom
//
//  Created by qianfeng on 15-10-3.
//  Copyright (c) 2015年 Shawhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (util)
//-(UIImage *)TransformtoSize:(CGSize)Newsize;
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
@end
