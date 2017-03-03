//
//  ZVideoData.m
//  JNews
//
//  Created by 王震 on 2017/3/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "ZVideoData.h"

@implementation ZVideoData
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // 转换系统关键字description
    if ([key isEqualToString:@"description"]) {
        self.Description = [NSString stringWithFormat:@"%@",value];
    }
    
}
@end
