//
//  CategoryView.h
//  JNews
//
//  Created by 王震 on 2017/3/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//  列表顶部的分类按钮所在的View

#import <UIKit/UIKit.h>

@interface CategoryView : UIView
/** 点击按钮Block */
@property (nonatomic , copy) void(^SelectBlock)(NSString *tag, NSString *title);
@end
