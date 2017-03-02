//
//  CategoryView.m
//  JNews
//
//  Created by 王震 on 2017/3/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "CategoryView.h"
#import "TabBarButton.h"
#import "SNPublicDefine.h"
#import "UIView+Frame.h"
@implementation CategoryView
{
    TabBarButton * btn;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0,0, SCREEN_Width, SCREEN_Width *0.25);
        NSArray *array = @[@"奇葩",@"萌物",@"美女",@"精品"];
        NSArray *images = @[[UIImage imageNamed:@"qipa"],
                            [UIImage imageNamed:@"mengchong"],
                            [UIImage imageNamed:@"meinv"],
                            [UIImage imageNamed:@"jingpin"]
                            ];
        
        for (int index =0; index < 4; index++) {
            btn = [[TabBarButton alloc]init];
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat btnW = SCREEN_Width/4;
            CGFloat btnH = self.height -5;
            CGFloat btnX = index * btnW -1;
            CGFloat btnY = 0;
            
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            [btn setImage:images[index] forState:UIControlStateNormal];
            [btn setTitle:array[index] forState:UIControlStateNormal];
            btn.titleLabel.font = Font(15);
            btn.tag = index;
            [self addSubview:btn];
        }
        
        for (int i = 1; i < 4; i++) {
            UIView * lineView = [[UIView alloc]init];
            lineView.backgroundColor = RGBA(244, 244, 244, 1);
            CGFloat lineViewX = btn.width * i;
            CGFloat lineViewY = btn.originY;
            CGFloat lineViewW = 1;
            CGFloat lineViewH = btn.height;
            lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
            [self addSubview:lineView];
                    }
    }
    return self;
}

- (void)btnClick:(UIButton*)button{
    NSString * title = button.titleLabel.text;
    if (self.SelectBlock) {
        self.SelectBlock([NSString stringWithFormat:@"%ld",(long)button.tag],title);
    }
    
}
@end
