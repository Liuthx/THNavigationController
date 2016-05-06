//
//  UIImage+ImageWithColor.h
//  
//
//  Created by k on 16/4/29.
//  Copyright © 2016年 k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)

+ (instancetype)imageWithColor:(UIColor *)color;

@end

@interface UIColor (RandomColor)

+ (instancetype)randomColor;

@end