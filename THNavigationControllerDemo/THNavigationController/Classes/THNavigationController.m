//
//  THNavigationController.m
//  THNavigationController
//
//  Created by k on 16/5/5.
//  Copyright © 2016年 k. All rights reserved.
//

#import "THNavigationController.h"
#import <objc/runtime.h>

#pragma mark - THWrapNavigationController

@interface THWrapNavigationController : UINavigationController

@end

@implementation THWrapNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    THNavigationController *th_navigationController = viewController.th_navigationController;
    NSInteger index = [th_navigationController.th_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:th_navigationController.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.th_navigationController = (THNavigationController *)self.navigationController;
    viewController.th_fullScreenPopGestureEnabled = viewController.th_navigationController.fullScreenPopGestureEnabled;
    
    UIImage *backButtonImage = viewController.th_navigationController.backButtonImage;
    
    if (!backButtonImage) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat width = 44;
        CGFloat height = 44;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width*scale, height*scale, 8, 4 * width*scale, colorSpace, kCGImageAlphaPremultipliedLast);
        
        CGContextSetLineWidth(context, scale);
        CGContextScaleCTM(context, 1, 1);
        
        CGPoint aPoints[3];
        aPoints[0] =CGPointMake(12*scale, 10*scale);
        aPoints[1] =CGPointMake(1, 21*scale);
        aPoints[2] =CGPointMake(12*scale, 32*scale);
        
        CGContextAddLines(context, aPoints, 3);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        UIImage *image = [UIImage imageWithCGImage:imageMasked scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(imageMasked);
        backButtonImage = image;
        
    }
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    
    [self.navigationController pushViewController:[THWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.th_navigationController=nil;
}

@end

#pragma mark - THWrapViewController

static NSValue *th_tabBarRectValue;

@implementation THWrapViewController

+ (THWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    THWrapNavigationController *wrapNavController = [[THWrapNavigationController alloc] init];
    wrapNavController.viewControllers = @[viewController];
    
    THWrapViewController *wrapViewController = [[THWrapViewController alloc] init];
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    
    return wrapViewController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !th_tabBarRectValue) {
        th_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && th_tabBarRectValue) {
        self.tabBarController.tabBar.frame = th_tabBarRectValue.CGRectValue;
    }
}

- (BOOL)th_fullScreenPopGestureEnabled {
    return [self rootViewController].th_fullScreenPopGestureEnabled;
}

- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

- (UIViewController *)rootViewController {
    THWrapNavigationController *wrapNavController = self.childViewControllers.firstObject;
    return wrapNavController.viewControllers.firstObject;
}

@end

#pragma mark - THNavigationController

@interface THNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;

@property (nonatomic, strong) id popGestureDelegate;

@end

@implementation THNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        rootViewController.th_navigationController = self;
        self.viewControllers = @[[THWrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.viewControllers.firstObject.th_navigationController = self;
        self.viewControllers = @[[THWrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    self.delegate = self;
    
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    self.popPanGesture.maximumNumberOfTouches = 1;
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    
    if (viewController.th_fullScreenPopGestureEnabled) {
        if (isRootVC) {
            [self.view removeGestureRecognizer:self.popPanGesture];
        } else {
            [self.view addGestureRecognizer:self.popPanGesture];
        }
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        [self.view removeGestureRecognizer:self.popPanGesture];
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = !isRootVC;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - Getter

- (NSArray *)th_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (THWrapViewController *wrapViewController in self.viewControllers) {
        [viewControllers addObject:wrapViewController.rootViewController];
    }
    return viewControllers.copy;
}


@end



@implementation UIViewController (THNavigationExtension)

- (BOOL)th_fullScreenPopGestureEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTh_fullScreenPopGestureEnabled:(BOOL)fullScreenPopGestureEnabled {
    objc_setAssociatedObject(self, @selector(th_fullScreenPopGestureEnabled), @(fullScreenPopGestureEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (THNavigationController *)th_navigationController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTh_navigationController:(THNavigationController *)navigationController {
    objc_setAssociatedObject(self, @selector(th_navigationController), navigationController, OBJC_ASSOCIATION_RETAIN);
}

@end


