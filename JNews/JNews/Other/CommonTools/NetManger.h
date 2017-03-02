//
//  NetManger.h
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,ResponseStyle) {
    JSON,
    XML,
    Data,
};

typedef NS_ENUM(NSUInteger,RequestStyle) {
    RequestJSON,
    RequestString,
    RequestDefault,
};
@interface NetManger : NSObject
+ (instancetype)shareEngine;

- (void)runRequestWithPara:(NSMutableDictionary *)para
                      path:(NSString *)path
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(id error))failure;

+ (void)upLoadToUrlString:(NSString* )url parameters:(NSDictionary* )parameters fileData:(NSData* )fileData name:(NSString* )name fileName:(NSString* )fileName mimeType:(NSString* )mimeType response:(ResponseStyle)style progress:(void (^)(NSProgress* ))progress success:(void (^)(NSURLSessionDataTask* , id))success failure:(void (^)(NSURLSessionDataTask* , NSError* ))failure;


@end
