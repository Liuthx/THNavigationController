//
//  THNavigationController.h
//  THNavigationController
//
//  Created by k on 16/1/5.
//  Copyright © 2016年 k. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface THNavigationController : UINavigationController
/**
 *  在navigationController自定义的返回图标, 空为默认图标
 */
@property (nonatomic, strong) UIImage *backButtonImage;
/**
 *  在navigationController中开启全屏返回的全局手势, 默认为NO
 */
@property (nonatomic, assign) BOOL fullScreenPopGestureEnabled;

@property (nonatomic, copy, readonly) NSArray *th_viewControllers;

@end

@interface UIViewController (THNavigationExtension)
/**
 *  在viewController中禁止右滑返回手势, 
 *  覆盖navigationController中的设置, 默认NO
 */
@property (nonatomic, assign) BOOL th_forbidPopGesture;
/**
 *  在viewController中开启全屏返回手势, 默认NO
 */
@property (nonatomic, assign) BOOL th_fullScreenPopGestureEnabled;
/**
 *  指向viewController真实的navigationController
 */
@property (nonatomic, strong) THNavigationController *th_navigationController;

@end