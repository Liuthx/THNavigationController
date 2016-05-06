//
//  UIImage+ImageWithColor.m
//  
//
//  Created by k on 16/4/29.
//  Copyright © 2016年 k. All rights reserved.
//

#import "KCategory.h"

@implementation UIImage (ImageWithColor)

+ (instancetype)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end

@implementation UIColor (RandomColor)

+ (instancetype)randomColor {
    return [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1];
}

@end
