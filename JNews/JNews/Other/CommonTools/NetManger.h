//
//  NetManger.h
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManger : NSObject
+ (instancetype)shareEngine;

- (void)runRequestWithPara:(NSMutableDictionary *)para
                      path:(NSString *)path
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(id error))failure;
@end
