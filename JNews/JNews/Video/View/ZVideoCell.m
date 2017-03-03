//
//  ZVideoCell.m
//  JNews
//
//  Created by 王震 on 2017/3/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "ZVideoCell.h"
#import <Masonry.h>
#import "ZVideoData.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
@implementation ZVideoCell



+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"Playercell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ZVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cutRoundView:self.avtarImageView];
        [self.contentView addSubview:self.avtarImageView];
        
        
        
        self.picImageView.tag = 101;
        [self.contentView addSubview:self.picImageView];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.playButton setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.picImageView addSubview:self.playButton];
        CGFloat btnX =(self.picImageView.width-50)/2;
        CGFloat btnY =(self.picImageView.height-50)/2;
        self.playButton.frame = CGRectMake(btnX, btnY, 50, 50);


    }
    return self;
}



- (void)setZVideoData:(ZVideoData *)zVideoData{
     [self.picImageView sd_setImageWithURL:[NSURL URLWithString:zVideoData.cover] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = zVideoData.title;
}

- (void)play:(UIButton*)btn{
    if (self.playBlock) {
        self.playBlock(btn);
    }

}

// 切圆角
- (void)cutRoundView:(UIImageView *)imageView
{
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}
@end
