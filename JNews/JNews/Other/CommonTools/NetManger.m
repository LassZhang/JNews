//
//  NetManger.m
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "NetManger.h"
#import "AFNetworking.h"
#import "SNPublicDefine.h"
@implementation NetManger
static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)runRequestWithPara:(NSMutableDictionary *)para
                      path:(NSString *)path
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(id error))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:path parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" --%@ %@",path,responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" --%@ %@",path,error);
        failure(error);
    }];
}
//@param url 服务器地址
//@param parameters 字典 token
//@param fileData 要上传的数据
//@param name 服务器参数名称 后台给你
//@param fileName 文件名称 图片:xxx.jpg,xxx.png 视频:video.mov
//@param mimeType 文件类型 图片:image/jpg,image/png 视频:video/quicktime
//@param style 返回的数据类型
//@param progress
//@param success
//@param failure
+ (void)upLoadToUrlString:(NSString* )url parameters:(NSDictionary* )parameters fileData:(NSData* )fileData name:(NSString* )name fileName:(NSString* )fileName mimeType:(NSString* )mimeType response:(ResponseStyle)style progress:(void (^)(NSProgress* ))progress success:(void (^)(NSURLSessionDataTask* , id))success failure:(void (^)(NSURLSessionDataTask* , NSError* ))failure {
    
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.根据style 的类型 去选择返回值得类型
    switch (style) {
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //3.设置相应数据支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 如果此处是单张图片或是视频则用此方法处理，若是多个，则此处使用For循环添加
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
}


@end
