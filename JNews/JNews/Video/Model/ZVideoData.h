//
//  ZVideoData.h
//  JNews
//
//  Created by 王震 on 2017/3/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZVideoData : NSObject
/** 标题 */
@property (nonatomic, copy  ) NSString *title;
/** 描述 */
@property (nonatomic, copy  ) NSString *Description;
/** 视频地址 */
@property (nonatomic, copy  ) NSString *mp4_url;
/** 封面图 */
@property (nonatomic, copy  ) NSString *cover;
@end
