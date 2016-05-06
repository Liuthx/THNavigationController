//
//  THNavigationController.h
//  THNavigationController
//
//  Created by k on 16/5/5.
//  Copyright © 2016年 k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THWrapViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

+ (THWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end

@interface THNavigationController : UINavigationController

@property (nonatomic, strong) UIImage *backButtonImage;

@property (nonatomic, assign) BOOL fullScreenPopGestureEnabled;

@property (nonatomic, copy, readonly) NSArray *th_viewControllers;

@end

@interface UIViewController (THNavigationExtension)

@property (nonatomic, assign) BOOL th_fullScreenPopGestureEnabled;

@property (nonatomic, strong) THNavigationController *th_navigationController;

@end