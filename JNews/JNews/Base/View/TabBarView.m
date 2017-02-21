//
//  TabBarView.m
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//  ps-customTabBarView

#import "TabBarView.h"
#import "TabBarButton.h"

@interface TabBarView()

@property (nonatomic,strong) TabBarButton*                         tabBarButton;
@property (nonatomic,strong) TabBarButton*                         selectTabBarButton;

@end

@implementation TabBarView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item{
    // 创建按钮
    TabBarButton * button =[[TabBarButton alloc]init];
    [self addSubview:button];
    self.tabBarButton = button;
    
    // 设置相关
    button.item = item;
    
    //监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 默认选中第一个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
    
}
- (void)selectIndex:(int)index{
    TabBarButton *btn = self.subviews[index];
    btn.tag = index;
    [self buttonClick:btn];
}

- (void)buttonClick:(TabBarButton*)btn{
    // 如果Block存在就回调block
    if (self.btnSelectBlock) {
        self.btnSelectBlock(btn.tag);
    }
    
    if (btn.tag == self.selectTabBarButton.tag) {
      [[NSNotificationCenter defaultCenter]postNotificationName:btn.titleLabel.text object:nil];
    }
    
    self.selectTabBarButton.selected = NO;
    btn.selected = YES;
    self.selectTabBarButton = btn;
}

// 重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat  buttonW = self.frame.size.width/self.subviews.count;
    CGFloat  buttonY = 0;
    CGFloat  buttonH = self.frame.size.height;
    
    for (int index = 0; index<self.subviews.count; index++) {
        
        //取出系统原来tabbar上面得按钮
        TabBarButton *button = self.subviews[index];
        CGFloat  buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //设置按钮得tag值
        button.tag = index;
    }
    
}
@end
