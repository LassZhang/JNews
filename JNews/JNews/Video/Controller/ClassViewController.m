//
//  ClassViewController.m
//  JNews
//
//  Created by 王震 on 2017/3/1.
//  Copyright © 2017年 Joseph. All rights reserved.
//  指定类的视频列表

#import "ClassViewController.h"
#import "ZVideoData.h"
#import "ZVideoCell.h"
#import "ZPlayerModel.h"
#import "ZFPlayerModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoFrameData.h"
#import "VideoData.h"
#import "VideoCell.h"
#import "GYHCircleLoadingView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ClassViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>
@property (nonatomic , strong) NSMutableArray *videoArray;
@property (nonatomic , weak) UITableView *tableview;
@property (nonatomic , assign)int count;
@property (nonatomic , assign) int currtRow;
@property (nonatomic, strong) MPMoviePlayerController *mpc;
@property (nonatomic, strong) MPMoviePlayerController *hpmpc;
@property (nonatomic , strong) GYHCircleLoadingView *circleLoadingV;
@property (nonatomic , assign) BOOL smallmpc;


@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;


@end

@implementation ClassViewController


- (NSMutableArray *)videoArray{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(239, 239, 244, 1);
    [self initUI];
    //监听屏幕改变
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}

- (ZFPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

- (void)initUI{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.frame = self.view.frame;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(ClassViewController);
    WZRefreshGifHeader *header = [WZRefreshGifHeader headerWithRefreshingBlock:^{
        block_self.count = 0;
        [block_self initNetWork];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    [header beginRefreshing];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self initNetWork];
    }];
}

- (void)initNetWork{
    NSLog(@"数据来了");
    IMP_BLOCK_SELF(ClassViewController);
    NSString *getstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/%@/y/%d-10.html",_url,self.count];
    
    [[NetManger shareEngine] runRequestWithPara:nil path:getstr success:^(id responseObject) {
        NSLog(@"===%@",responseObject);
        NSArray *dataarray = [VideoData mj_objectArrayWithKeyValuesArray:responseObject[_url]];
        // 创建frame模型对象
        
        
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (VideoData *videodata in dataarray) {
            VideoFrameData *videodataFrame = [[VideoFrameData alloc] init];
            videodataFrame.videodata = videodata;
            [statusFrameArray addObject:videodataFrame];        }
        
        if (block_self.videoArray.count == 0) {
            block_self.videoArray = statusFrameArray;
        }else{
            [block_self.videoArray addObjectsFromArray:statusFrameArray];
        }
        
        block_self.count += 10;
        [block_self.tableview reloadData];
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
        block_self.tableview.footer.hidden = block_self.videoArray.count < 10;
    } failure:^(id error) {
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
    }];

}


#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.videoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoFrameData *videoFrame = self.videoArray[indexPath.row];
    return videoFrame.cellH;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 VideoCell *cell    = [VideoCell cellWithTableView:tableView];
    cell.videodataframe = self.videoArray[indexPath.row];
       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoFrameData *videoframe = self.videoArray[indexPath.row];
    VideoData *videodata = videoframe.videodata;
    
    if (self.mpc) {
        [self.mpc.view removeFromSuperview];
    }
    self.currtRow = (int)indexPath.row;
    // 创建播放器对象
    self.mpc = [[MPMoviePlayerController alloc] init];
    self.mpc.contentURL = [NSURL URLWithString:videodata.mp4_url];
    // 添加播放器界面到控制器的view上面
    self.mpc.view.frame = CGRectMake(0, videoframe.cellH*indexPath.row+videoframe.coverF.origin.y, SCREEN_Width, videoframe.coverF.size.height);
    //设置加载指示器
    [self setupLoadingView];
    
    [self.tableview addSubview:self.mpc.view];
    
    // 隐藏自动自带的控制面板
    self.mpc.controlStyle = MPMovieControlStyleNone;
    
    // 监听播放器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:self.mpc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStateDidChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.mpc];
    
    [self.mpc play];

}

- (void)setupLoadingView
{
    self.circleLoadingV = [[GYHCircleLoadingView alloc]initWithViewFrame:CGRectMake(self.mpc.view.frame.size.width/2-20, self.mpc.view.frame.size.height/2-20, 40, 40)];
    self.circleLoadingV.isShowProgress = YES;   //设置中间label进度条
    [self.mpc.view addSubview:self.circleLoadingV];
    [self.circleLoadingV startAnimating];
}

#pragma mark - 监听播放完毕
- (void)movieDidFinish
{
    NSLog(@"----播放完毕");
    if (self.mpc) {
        [self.mpc.view removeFromSuperview];
        self.mpc = nil;
    }
}

#pragma mark - 监听播放状态
- (void)movieStateDidChange
{
    NSLog(@"----播放状态--%ld", (long)self.mpc.playbackState);
    if (self.mpc.playbackState == 1) {
        [self.circleLoadingV stopAnimating];
    }
    
}

#pragma mark - 屏幕改变
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

- (void)up
{
    if(self.mpc){
        
        if (self.smallmpc) {
        }else{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                
                VideoFrameData *videoframe = self.videoArray[self.currtRow];
                self.mpc.view.transform = CGAffineTransformIdentity;
                self.mpc.view.frame = CGRectMake(0, videoframe.cellH*self.currtRow+videoframe.coverF.origin.y, SCREEN_Width, videoframe.coverF.size.height);
                [self.tableview addSubview:self.mpc.view];
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }
    
}

- (void)left
{
    if (self.mpc) {
        
        if (self.smallmpc) {
        }else{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                
                self.mpc.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
                
                self.mpc.view.frame = CGRectMake(0, 0, SCREEN_Width, SCREEN_Height);
                
                [[[[UIApplication sharedApplication] delegate] window] addSubview:self.mpc.view];
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
    
}
#pragma mark - 判断滚动事件，如何超出播放界面，停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.mpc) {
        
        if (fabs(scrollView.contentOffset.y)+64 > CGRectGetMaxY(self.mpc.view.frame)) {
            
            [self setupSmallmpc];
        }else{
            [self.mpc.view removeFromSuperview];
        }
    }
}

- (void)setupSmallmpc
{
    self.smallmpc = YES;
    self.mpc.view.frame = CGRectMake(SCREEN_Width-20-200, SCREEN_Height - 120, 200, 200*0.56);
    [self.view addSubview:self.mpc.view];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.mpc) {
        NSLog(@"销毁了");
        [self.mpc stop];
        [self.mpc.view removeFromSuperview];
        self.mpc = nil;
    }
    self.tableview.delegate = nil;
}
@end
