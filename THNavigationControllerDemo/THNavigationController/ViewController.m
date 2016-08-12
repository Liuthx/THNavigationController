//
//  ViewController.m
//  THNavigationController
//
//  Created by k on 16/1/5.
//  Copyright © 2016年 k. All rights reserved.
//

#import "ViewController.h"
#import "KCategory.h"
#import "THNavigationController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"viewDidLoad");
    
    [self configUI];
    
    
}

- (void)configUI {
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = CGRectMake(100, 100, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    self.view.backgroundColor = [UIColor randomColor];
}

- (void)push {
    [self.navigationController pushViewController:({
        ViewController * vc = [ViewController new];
        vc;
    }) animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
