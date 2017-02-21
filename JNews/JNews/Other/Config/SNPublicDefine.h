//
//  SNPublicDefine.h
//  dianDaiSuning
//
//  Created by user on 16/6/23.
//  Copyright © 2016年 suning. All rights reserved.
//
#import "UIColor+Extension.h"

#ifndef SNPublicDefine_h
#define SNPublicDefine_h

/* 字符串是否为空 */
#define StrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
/* 是否为空或是[NSNull null] */
#define NilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:@"null"]) || ([(_ref) isEqual:@"(null)"]))
/* 16进制颜色转化 */
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/* 常用frame */
#define BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_Width    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_Height   ([UIScreen mainScreen].bounds.size.height)

/* 区分屏幕 */
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/* 显示打印行 */
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/**
 *设置rgb颜色
 *@prame a 透明度
 */
#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__ = nil; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//字体大小-系统--standard
#define Font(X) [UIFont systemFontOfSize:X]

//bold-系统
#define BoldFont(X) [UIFont boldSystemFontOfSize:X]



// 保存账户名
#define USERIDKEY @"userId"
// 经度
#define USER_LONGITUDE @"USERLONGITUDE"
// 纬度
#define USER_LATITUDE @"USER_LATITUDE"
// 客户编号
#define CustId @"custId"

// 保存登录状态
#define SNISLOGIN @"isLogin"
// 保存时间年月日
#define TIMEFORYMD @"TIMEFORYMD"
// 保存用户基本信息
#define USERBASEINFO @"USERBASEINFO"
// 保存 用户-时间 字典
#define USERTOTIMEDICTIONARY @"USERTOTIMEDICTIONARY" 

#define USERID [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY]

#define terminalType @"03"
// 修改密码类型
#define TYPEKEY @"type"

#define findPasswordRegId @"findPasswordRegId"
// 比例
#define kScreenWidthRatio  (SCREEN_Width / 320.0)
#define kScreenHeightRatio (SCREEN_Height / 568.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)


// block self
//
//#define MPWeakSelf(type)  __weak typeof(type) weak##type = type;
//#define MPStrongSelf(type)  __strong typeof(type) type = weak##type;
//#define WEAKSELF                    typeof(self) __weak weakSelf = self;

#if __has_feature(objc_arc)
#define IMP_BLOCK_SELF(type) __weak type *block_self=self;
#else
#define IMP_BLOCK_SELF(type) __block type *block_self=self;
#endif


// 删除上次保存信息
#define kDeletePersonMessegeAreaInfoLastTime @"kDeletePersonMessegeAreaInfoLastTime"

//
#define kupdateMaximumNumberOfImage 3
// 保存口令
#define RandomKey @"Randomkey"
// 业务流水号
#define SN_applyCodeKey @"SN_applyCodeKey"
// 忘记密码-两个号
#define SN_FindPass_workId @"SN_FindPass_workId"
#define SN_FindPass_batch @"SN_FindPass_batch"

// 消息推送保存key，保存的为数组，value为字典
#define PUSHNOTIFICATIONSAVE @"PUSHNOTIFICATIONSAVE"
// 收到消息推送发的通知
#define POSTPUSHNOTIFICATION @"POSTPUSHNOTIFICATION"

// 登录成功发送通知名称
#define LOGINNOTIFICATIONNAME @"LOGINNOTIFICATIONNAME"

// 注销发送通知名称
#define CANCLELOGINNOTIFICATIONNAME @"CANCLELOGINNOTIFICATIONNAME"

// 账单分期详情 全选通知
#define SELECTALLITEMS @"SELECTALLITEMS"

// 现金分期-移除支付密码视图
#define RemoveInputPayPwdViewNotification @"RemoveInputPayPwdViewNotification"

//  还款或体现成功后: 刷新首页额度--账单页面刷新--待还页面刷新
#define SNRefreshIndexNotification @"SNRefreshIndexNotification"

//  支付密码tableView
#define SNPaymentInputPayPwdNotification @"SNPaymentInputPayPwdNotification"

//  还款成功 弹出还款成功控制器
#define SNPresentPaymentAmountResultNotification @"SNPresentPaymentAmountResultNotification"

// 点击选择还款方式 左右移动
#define SNClickSelectPaymentMethodScrollViewNotification @"SNClickSelectPaymentMethodScrollViewNotification"

//  设置或忘记密码
#define SNSetPwdOrForgetPwdNotification @"SNSetPwdOrForgetPwdNotification"

// 绑卡
#define SNBindingBankCardNotification @"SNBindingBankCardNotification"

// 初始化发送通知名称
#define INITTIFICATIONNAME @"INITTIFICATIONNAME"

// 异步获取设备数据
#define BLACKBOX @"blackBox"

// deviceToken
#define serverError @"网络异常,请稍后再试"

#define NetworkErrorTitleDefine @"网络设置提示"

#define NetworkErrorMsgDefine @"网络连接不可用，是否进行设置?"

// 图片名称
#define IMAGE(string) [UIImage imageNamed:string]

// 十六进制颜色
#define COLOR(String) [UIColor colorWithHexString:String]
#define COLORNUMBER @"#333333"
#define COLORTABBAR @"#232f41"

#endif /* SNPublicDefine_h */

