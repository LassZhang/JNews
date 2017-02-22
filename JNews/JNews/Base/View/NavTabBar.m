//
//  NavTabBar.m
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "NavTabBar.h"
#import "NSString+Extension.h"

@interface NavTabBar()
{
        UIScrollView    *_navgationTabBar;      // topScrollView
        UIView          *_line;                 // underscore show which item selected
        NSArray         *_itemsWidth;           // an array of items' width
}
@end
@implementation NavTabBar
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig{
    _items = [@[] mutableCopy];
    [self viewConfig];
}
- (void)viewConfig{
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width - 40, 44)];
    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
    
}

// 更新
- (void)updateData{
    _itemsWidth = [self getButtonsWidthsWithButtonTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}


/**
 *  传入一组标题的宽度，返回顶部栏<scrollView>的ContentSize，即滚动范围
 *  此过程中将每个item Button加入顶部栏
 *  @param widths
 *
 *  @return Contentsize.width
 */
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        CGSize textMaxSize = CGSizeMake(SCREEN_Width, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize].size;
        
        textRealSize = CGSizeMake(textRealSize.width + 15*2, 44);
        
        button.frame = CGRectMake(buttonX, 0,textRealSize.width, 44);
//        button.backgroundColor = [UIColor greenColor];
        //字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}
/**
 *  显示第一个下划线
 *
 *  @param width 传入标题宽度数组中的第一个宽度
 */
- (void)showLineWithButtonWidth:(CGFloat)width{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(15, 45 - 3.0f, width, 2.0f)];
    _line.backgroundColor = [UIColor redColor];
    [_navgationTabBar addSubview:_line];
    
    // 默认 - 取出第一个Button 并点击
    UIButton *btn = _items[0];
    [self itemPressed:btn type:0];
    
}

- (void)itemPressed:(UIButton*)button type:(int)type{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];

}
/**
 *  计算数组内各个标题的宽度，并存入数组
 *
 *  @param titles 传入标题数组
 *
 *  @return 返回一组标题宽度
 */
- (NSArray*)getButtonsWidthsWithButtonTitles:(NSArray*)titles{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize textMaxSize = CGSizeMake(SCREEN_Width, MAXFLOAT);
        CGSize textRealSize = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize].size;
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
    return widths;
}

#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    
    CGFloat flag = SCREEN_Width - 40;
    
    if (button.frame.origin.x + button.frame.size.width + 50 >= flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count]-1)
        {
            offsetX = offsetX + button.frame.size.width;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 15, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue], _line.frame.size.height);
    }];
}
@end
