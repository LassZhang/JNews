//
//  VideoCell.h
//  JNews
//
//  Created by 王震 on 2017/3/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoFrameData;
@interface VideoCell : UITableViewCell
@property (nonatomic , strong) VideoFrameData *videodataframe;
@property (nonatomic , weak) UILabel *      titleLabel;
@property (nonatomic , weak) UIImageView *  imageview;
@property (nonatomic , weak) UIImageView *  playcoverImage;
@property (nonatomic , weak) UILabel *      lengthLabel;
@property (nonatomic , weak) UIImageView *  playImage;
@property (nonatomic , weak) UILabel *      playcountLabel;
@property (nonatomic , weak) UILabel *      ptimeLabel;
@property (nonatomic , weak) UIView *       lineV;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
