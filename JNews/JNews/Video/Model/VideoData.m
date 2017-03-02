//
//  VideoData.m
//  JNews
//
//  Created by 王震 on 2017/3/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "VideoData.h"

@implementation VideoData
-(NSString *)ptime
{
    NSString *str1 = [_ptime substringToIndex:10];
    str1 = [str1 substringFromIndex:5];
    
    return str1;
}
@end
