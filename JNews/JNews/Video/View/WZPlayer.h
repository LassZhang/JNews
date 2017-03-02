//
//  WZPlayer.h
//  JNews
//
//  Created by 王震 on 2017/3/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPlayer : UIView
@property (nonatomic , copy) void(^currentRowBlock)();
///title
@property (nonatomic , strong) NSString *title;
///url
@property (nonatomic , strong) NSString *mp4_url;
///当前在cell上的播放器的y值
@property (nonatomic)          CGFloat   currentOriginY;

- (void)removePlayer;
@end
