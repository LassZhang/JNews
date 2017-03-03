//
//  WZPlayer.m
//  JNews
//
//  Created by 王震 on 2017/3/2.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "WZPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "GYHCircleLoadingView.h"
#import "UIView+Frame.h"
#import "SNPublicDefine.h"
@interface WZPlayer()
@property (nonatomic, strong) AVPlayerItem *            playerItem;
@property (nonatomic, strong) AVPlayerLayer *           playerLayer;
@property (nonatomic, strong) AVPlayer *                player;
@property (nonatomic, strong) GYHCircleLoadingView *    circleLoadingV;


@property (nonatomic, strong) UIView *                  bottomView;     //整个view
@property (nonatomic, strong) UILabel *                 lbTitle;        //视频标题
@property (nonatomic, strong) UIImageView *             imgBgTop;       //视频标题背景

@property (nonatomic, strong) UIView *                  bottomBar;      //底部工具栏
@property (nonatomic, strong) UIImageView *             imgBgBottom;    //视频底部背景
@property (nonatomic, strong) UIButton *                btnPlayOrPause; //播放暂停
@property (nonatomic, strong) UIButton *                btnFullScreen;  //全屏按钮

@property (nonatomic)         BOOL                      isFullScreen;
@end
@implementation WZPlayer

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIDevice * device = [UIDevice currentDevice];
        [device beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
        
        // 加载指示框
        self.circleLoadingV = [[GYHCircleLoadingView alloc]initWithViewFrame:CGRectMake(self.width/2-20, self.height/2-20, 40, 40)];
        [self addSubview:self.circleLoadingV];

    }
    return self;
}
- (void)setMp4_url:(NSString *)mp4_url {
    _mp4_url = mp4_url;
    [self.layer addSublayer:self.playerLayer];
    [self insertSubview:self.bottomView aboveSubview:self];
    [self insertSubview:self.circleLoadingV aboveSubview:self.bottomView];
    [self.circleLoadingV startAnimating];
    [self.player play];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.lbTitle.text = _title;
}

//添加kvo noti
- (void)addObserverAndNotification {
    //监控状态属性 AVPlayerStatusUnknown,AVPlayerStatusReadyToPlay,AVPlayerStatusFailed
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //加载进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
//kvo监听播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
//    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay){
            NSLog(@"准备播放");
            [self.circleLoadingV stopAnimating];
            //            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
            //            self.totalDurationLabel.text = [self timeFormatted:self.totalDuration];
        } else if (status == AVPlayerStatusFailed){
            NSLog(@"播放失败");
        } else if (status == AVPlayerStatusUnknown){
            NSLog(@"unknown");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //        NSArray *array = playerItem.loadedTimeRanges;
        //        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        //        float startSeconds = CMTimeGetSeconds(timeRange.start);
        //        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        ////        self.slider.middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
        //        //        NSLog(@"totalBuffer：%.2f",totalBuffer);
        //
        //        //loading animation
        //        if (self.slider.middleValue  <= self.slider.value || (totalBuffer - 1.0) < self.current) {
        //            DLog(@"正在缓冲...");
        //            self.activityIndicatorView.hidden = NO;
        //            //            self.activityIndicatorView.center = self.center;
        //            [self.activityIndicatorView startAnimating];
        //        }else {
        //            self.activityIndicatorView.hidden = YES;
        //            if (self.playOrPauseBtn.selected) {
        //                [self.player play];
        //            }
        //        }
    }
}

#pragma  mark- 监控设备方向的通知

//屏幕改变
- (void)orientationChanged:(NSNotification *)note  {
    
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:            // 屏幕变正
            NSLog(@"屏幕变正");
            [self up];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:       //屏幕左转
            NSLog(@"屏幕变左");
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [self left];
            
            break;
        case UIDeviceOrientationLandscapeRight:   //屏幕右转
            NSLog(@"屏幕变右");
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            
            break;
        default:
            break;
    }
}

- (void)up {
    if(self.superview) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [self isFullScreen:NO];
        } completion:nil];
    }
}

- (void)left {
    if (self.superview) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [self isFullScreen:YES];
        } completion:nil];
    }
}

//播放暂停
- (void)playOrPause:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
        
        [self.player play];
        
    } else {
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateNormal];
        [self.player pause];
       
    }
}

//全屏不全屏
- (void)fullScreen:(UIButton *)btn {
    if (self.isFullScreen) {
        [self.btnFullScreen setImage:[UIImage imageNamed:@"sc_video_play_ns_enter_fs_btn.png"] forState:UIControlStateNormal];
    } else {
        [self.btnFullScreen setImage:[UIImage imageNamed:@"sc_video_play_ns_enter_fs_btn.png"] forState:UIControlStateNormal];
    }
}

//是否全屏
- (void)isFullScreen:(BOOL)isFullScreen {
    if (isFullScreen) {
        self.isFullScreen = YES;
        
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = CGRectMake(0, 0, SCREEN_Width, SCREEN_Height);
        self.playerLayer.frame = self.bounds;
        //设置底部工具栏的frame
        self.bottomView.frame = CGRectMake(0, 0, SCREEN_Height, SCREEN_Width);
        
        self.imgBgTop.width = SCREEN_Height;
        
        self.lbTitle.width = SCREEN_Height - 20;
        self.bottomBar.originY = SCREEN_Width - 37;
        self.bottomBar.width = SCREEN_Height;
        self.imgBgBottom.width = SCREEN_Height;
        self.btnFullScreen.originX = SCREEN_Height - 10 - 37;
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    } else {
        self.isFullScreen = NO;
        
        self.transform = CGAffineTransformIdentity;
        self.frame = CGRectMake(0, self.currentOriginY, SCREEN_Width, SCREEN_Width * 0.56);
        self.playerLayer.frame = self.bounds;
        
        self.bottomView.frame = CGRectMake(0, 0, SCREEN_Width, self.height);
        self.lbTitle.width = SCREEN_Width - 20;
        self.imgBgTop.width = SCREEN_Width;
        self.bottomBar.originY = self.height - 37;
        self.bottomBar.width = SCREEN_Width;
        self.imgBgBottom.width = SCREEN_Width;
        self.btnFullScreen.originX = SCREEN_Width - 10 - 37;
        
        if (self.currentRowBlock) {
            self.currentRowBlock();
        }
    }
}
// 移除播放器View
- (void)removePlayer {
    if (self.superview) {
        [self.player pause];
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    [self removePlayer];
}

#pragma mark - lazy

- (AVPlayer *)player {
    if (!_player) {
        self.playerItem = [self getAVPlayItem];
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self addObserverAndNotification];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        
    }
    return _playerLayer;
}

//获取url是网络的还是本地的
- (AVPlayerItem *)getAVPlayItem{
    
    if ([self.mp4_url rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.mp4_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.mp4_url] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.frame = CGRectMake(0, 0, SCREEN_Width, self.height);
        
        self.imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 50)];
        self.imgBgTop.image = [UIImage imageNamed:@"top_shadow.png"];
        [_bottomView addSubview:self.imgBgTop];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_Width - 20, 40)];
        self.lbTitle.font = [UIFont systemFontOfSize:16];
        self.lbTitle.numberOfLines = 0;
        self.lbTitle.textColor = COLOR(@"#ffffff");
        [_bottomView addSubview:self.lbTitle];
        
        
        self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 37, SCREEN_Width, 37)];
        [_bottomView addSubview:self.bottomBar];
        
        self.imgBgBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 37)];
        self.imgBgBottom.image = [UIImage imageNamed:@"bottom_shadow.png"];
        [self.bottomBar addSubview:self.imgBgBottom];
        
        self.btnPlayOrPause = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 17, 17)];
        [self.btnPlayOrPause setImage:[UIImage imageNamed:@"video_pause.png"] forState:UIControlStateNormal];
        [self.btnPlayOrPause addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        self.btnPlayOrPause.selected = YES;
        [self.bottomBar addSubview:self.btnPlayOrPause];
        
        self.btnFullScreen = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_Width - 10 - 37, 0, 37, 37)];
        [self.btnFullScreen setImage:[UIImage imageNamed:@"sc_video_play_ns_enter_fs_btn.png"] forState:UIControlStateNormal];
        [self.btnFullScreen addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:self.btnFullScreen];
        
        [self addSubview:_bottomView];
    }
    return _bottomView;
}


@end
