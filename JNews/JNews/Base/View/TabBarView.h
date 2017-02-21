//
//  TabBarView.h
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarView : UIView
/** button 被选中block*/
@property (nonatomic,copy) void (^btnSelectBlock)(NSInteger to);

- (void)selectIndex:(int)index;
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@end
