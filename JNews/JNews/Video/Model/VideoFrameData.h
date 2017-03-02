//
//  VideoFrameData.h
//  JNews
//
//  Created by 王震 on 2017/3/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VideoData;
@interface VideoFrameData : NSObject

@property (nonatomic , strong)VideoData *videodata;

/**
 *  题目
 */
@property (nonatomic , assign) CGRect titleF;
/**
 *  播放图标
 */
@property (nonatomic , assign) CGRect playF;
/**
 *  图片
 */
@property (nonatomic , assign) CGRect coverF;
/**
 *  时长
 */
@property (nonatomic , assign) CGRect lengthF;
/**
 *  播放来源图片
 */
@property (nonatomic , assign) CGRect playImageF;
/**
 *  播放来源文字
 */
@property (nonatomic , assign) CGRect playCountF;
/**
 *  时间
 */
@property (nonatomic , assign) CGRect ptimeF;

@property (nonatomic , assign) CGRect lineVF;

@property (nonatomic , assign) CGFloat cellH;
@end
