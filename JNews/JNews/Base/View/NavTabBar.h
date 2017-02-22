//
//  NavTabBar.h
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//   顶部栏 -scrollView

#import <UIKit/UIKit.h>
#import "SNPublicDefine.h"
@protocol NavTabBarDelegate<NSObject>
@optional
// 控制顶部栏红色LineView 联动滚动
- (void)itemDidSelectedWithIndex:(NSInteger)index;
// 控制MainView 滑动时，顶部栏随之联动
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;
@end

@interface NavTabBar : UIView

/** deledate */
@property (nonatomic,weak) id<NavTabBarDelegate>                         delegate;
/** 当前Item的索引 */
@property (nonatomic,assign) NSInteger  currentItemIndex;
/** Item标题数组 */
@property (nonatomic,strong) NSArray*                         itemTitles;
/** lineView颜色 */
@property (nonatomic,strong) UIColor*                         lineColor;
/** items数组 */
@property (nonatomic,strong) NSMutableArray*                  items;


- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateData;

@end
