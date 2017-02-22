//
//  BaseViewController.h
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "NetManger.h"
@interface BaseViewController : UIViewController
- (BOOL)canSwipBack;
- (void)back;
@end
