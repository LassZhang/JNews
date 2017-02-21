//
//  TabBarViewController.m
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "TabBarViewController.h"
#import "TabBarView.h"
#import "SNPublicDefine.h"
#import "NavigationViewController.h"
#import "NewsViewController.h"
#import "VideoViewController.h"
#import "LiveViewController.h"
#import "MineViewController.h"


@interface TabBarViewController ()
/** tabbar */
@property (nonatomic,strong) TabBarView*                         tabbar;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
    [self initController];
    // 主题变化通知
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView * child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
///**
// *  自己定义的tabbar在iOS8 中重叠的情况.就是原本已经移除的UITabBarButton再次出现
// 在iOS8 是允许动态添加tabbaritem的
// */
//-(void)viewWillLayoutSubviews{
//    
//    [super viewWillLayoutSubviews];
//    
//    for (UIView *child in self.tabBar.subviews) {
//        
//        if ([child isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            
//            [child removeFromSuperview];
//        }
//    }
//}
- (void)initTabBar{
    
    IMP_BLOCK_SELF(TabBarViewController);
    TabBarView * tabbar = [[TabBarView alloc]init];
    tabbar.frame = self.tabBar.bounds;
     // 将系统的index传给自定义的TabbarView
    tabbar.btnSelectBlock = ^(NSInteger to){
        block_self.selectedIndex = to;
    };
    [self.tabBar addSubview:tabbar];
    _tabbar = tabbar;
     [self handleThemeChanged];
}
// 主题切换事件
-(void)handleThemeChanged
{

}

- (void)initController{
    
    
    NewsViewController * news = [[NewsViewController alloc]init];
    [self setupChildViewController:news title:@"新闻" imageName:@"tabbar_news" selectedImage:@"tabbar_news_hl"];
    
    VideoViewController *video = [[VideoViewController alloc]init];
    [self setupChildViewController:video title:@"视频" imageName:@"tabbar_video" selectedImage:@"tabbar_video_hl"];
    
    LiveViewController *photo = [[LiveViewController alloc]init];
    [self setupChildViewController:photo title:@"直播" imageName:@"tabbar_picture" selectedImage:@"tabbar_picture_hl"];
    
    MineViewController *me = [[MineViewController alloc]init];
    [self setupChildViewController:me title:@"我的" imageName:@"tabbar_setting" selectedImage:@"tabbar_setting_hl"];
}

- (void)selectIndex:(int)index{
    [self.tabbar selectIndex:index];
}

// 给TabBarViewController 增加子控制器
-(void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage
{
    
    //设置控制器属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //包装一个导航控制器
    NavigationViewController *nav = [[NavigationViewController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    [self.tabbar addTabBarButtonWithItem:childVc.tabBarItem];
}
@end
