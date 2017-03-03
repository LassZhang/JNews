//
//  ZVideoCell.h
//  JNews
//
//  Created by 王震 on 2017/3/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZVideoData.h"
typedef void(^PlayBtnCallBackBlock)(UIButton *);

@interface ZVideoCell : UITableViewCell
/** uiimageView */
@property (nonatomic,strong) UIImageView*                         avtarImageView;
/** picImageView */
@property (nonatomic,strong) UIImageView*                         picImageView;

/** titleLabel */
@property (nonatomic,strong) UILabel*                         titleLabel;

/** data */
@property (nonatomic,strong) ZVideoData*                         zVideoData;
/** sd */
@property (nonatomic,strong) UIButton*                         playButton;
/** 播放按钮block */
@property (nonatomic, copy  ) PlayBtnCallBackBlock          playBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
