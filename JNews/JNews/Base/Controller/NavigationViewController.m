//
//  NavigationViewController.m
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "NavigationViewController.h"
#import "BaseViewController.h"
#import "SNPublicDefine.h"
#import "UIBarButtonItem+gyh.h"

@interface NavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
/** currentVC */
@property (nonatomic,strong) BaseViewController*                         currentShowVC;
@end

@implementation NavigationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate=self;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航外观主题
    
    //设置相关代理
    IMP_BLOCK_SELF(NavigationViewController);
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = block_self;
        self.delegate = block_self;
    }
}

#pragma mark  拦截push，一旦进入下个视图，隐藏tabbar，自定义返回按钮
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithIcon:@"navigationbar_back_os7" highIcon:nil target:self action:@selector(back)];
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    @synchronized(self){
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
            self.interactivePopGestureRecognizer.enabled = YES;
        
        if (navigationController.viewControllers.count == 1)
            self.currentShowVC = nil;
        else
            self.currentShowVC = (BaseViewController *)viewController;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.currentShowVC respondsToSelector:@selector(canSwipBack)]) {
        return [self.currentShowVC canSwipBack];
    }
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

@end
