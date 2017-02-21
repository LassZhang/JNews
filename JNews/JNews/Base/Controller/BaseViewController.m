//
//  BaseViewController.m
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//   基类-做全局控制使用

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (BOOL)canSwipBack{
    return YES;
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
