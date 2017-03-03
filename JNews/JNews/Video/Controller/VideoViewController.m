//
//  VideoViewController.m
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//  视频列表，支持播放,此处使用自定义的播放器- 另选日期完成-可以试用ZFPlayer -并总结其利弊
//  完成视频上传-播放
// 在这里整体思路是：拿到视频，转换为MP4，压缩，上传

#import "VideoViewController.h"
#import "GYHCircleLoadingView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreFoundation/CoreFoundation.h>
#import "CategoryView.h"
#import "VideoData.h"
#import "VideoFrameData.h"
#import "VideoCell.h"
#import "WZPlayer.h"
#import "ClassViewController.h"
@interface VideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImagePickerController *_imagePickerController; // 摄像或相册页面
    UIImageView             *_imageView; // 展示选中的图片imageView
    ZFPlayerView * playerView;
}
///** AVPlayer-播放器，将数据解码资源处理为图像和声音 */
//@property (nonatomic,strong) AVPlayer*                         player;
///** AVPlayerLayer-图像曾，AVPlayer的图像要通过此层展示 */
//@property (nonatomic,strong) AVPlayerLayer*                         playerLayer;
///** AVPlayerItem -建立动态媒体资源动态数据模型，并保存AVPlayer播放资源的状态-，说白了就是数据管家*/
//@property (nonatomic,strong) AVPlayerItem*                         playerItem ;
///** AVURLAsset- 负责网络连接，请求数据 */
//@property (nonatomic,strong) AVURLAsset*                         urlAssert;
///** NSURL_视频播放资源 */
//@property (nonatomic,strong) NSURL*                         video_Url;
//
///** NSURL_压缩后的视频播放资源 */
//@property (nonatomic,strong) NSURL *                         outVideoURL;
///** 是否在播放-默认是NO */
//@property (nonatomic,assign) BOOL   isPlay;

/** 视频列表数据源*/
@property (nonatomic , strong) NSMutableArray *             videoArray;
/** 视频列表TableView*/
@property (nonatomic , weak) UITableView *                  tableview;
@property (nonatomic , strong) WZPlayer     *               player;
@property (nonatomic)          CGFloat                      currentOriginY;
/** 数量 */
@property (nonatomic,assign) int  count;



@end
@implementation VideoViewController

- (NSMutableArray *)videoArray{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 测试视频录制并上传的功能
    {
        //    [self setUpUI];
        //    [self setUpImagePickerController];
    }
    
    //
    self.title =@"视频😝";
    [self initUI];
}
#pragma mark - 初始化UI
- (void)initUI{
    // 1 创建tableView
    UITableView * tableView = [[UITableView alloc]init];
    tableView.frame = self.view.bounds;
    tableView.backgroundColor = COLOR(@"#f4f4f4");
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    
    self.tableview = tableView;
    self.tableview.tableFooterView = [[UIView alloc]init];// ???这行代码的作用
    
    // 2 tableView 头和脚绑定
    IMP_BLOCK_SELF(VideoViewController);
    WZRefreshGifHeader * header = [WZRefreshGifHeader headerWithRefreshingBlock:^{
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
    
    // 头视图
    CategoryView * view = [[CategoryView alloc]initWithFrame:CGRectZero];
    
    view.SelectBlock = ^(NSString*tag,NSString*title){
        NSArray *arr = @[@"VAP4BFE3U",
                         @"VAP4BFR16",
                         @"VAP4BG6DL",
                         @"VAP4BGTVD"];
        ClassViewController *classVC = [[ClassViewController alloc]init];
        classVC.url = arr[[tag intValue]];
        classVC.title = title;
        [block_self.navigationController pushViewController:classVC animated:YES];
    };
    self.tableview.tableHeaderView = view;
}

#pragma mark- 网络请求数据
- (void)initNetWork{
    IMP_BLOCK_SELF(VideoViewController);
    NSString * getUrl =[NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-10.html",self.count];
    [[NetManger shareEngine]runRequestWithPara:nil path:getUrl success:^(id responseObject) {
        // 数据存入模型
        NSArray *dataArray = [VideoData mj_objectArrayWithKeyValuesArray:responseObject[@"videoList"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];

        for (VideoData *videodata in dataArray) {
            VideoFrameData *videodataFrame = [[VideoFrameData alloc] init];
            videodataFrame.videodata = videodata;
            [statusFrameArray addObject:videodataFrame];
        }
        
        if (block_self.count == 0) {
            block_self.videoArray = statusFrameArray;
        }else{
            [block_self.videoArray addObjectsFromArray:statusFrameArray];
        }
        
        block_self.count += 10;
        [block_self.tableview reloadData];
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
        block_self.tableview.footer.hidden = dataArray.count < 10;

        NSLog(@"responseObject%@",responseObject);
    } failure:^(id error) {
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
    }];
    
}


#pragma mark -UITableViewDelegate


#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoFrameData *videoFrame = self.videoArray[indexPath.row];
    return videoFrame.cellH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell * cell = [VideoCell cellWithTableView:tableView];
    cell.videodataframe =self.videoArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoFrameData *videoframe = self.videoArray[indexPath.row];
    VideoData *videodata = videoframe.videodata;

    //创建播放器
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
    CGFloat originY = videoframe.cellH*indexPath.row+videoframe.coverF.origin.y+SCREEN_Width * 0.25;
    self.currentOriginY = originY;
    self.player = [[WZPlayer alloc] initWithFrame:CGRectMake(0, originY, SCREEN_Width, SCREEN_Width * 0.56)];
    self.player.mp4_url = videodata.mp4_url;
    self.player.title = videodata.title;
    self.player.currentOriginY = originY;
    IMP_BLOCK_SELF(VideoViewController);
    self.player.currentRowBlock = ^(){
        [block_self.tableview addSubview:block_self.player];
    };
    [self.tableview addSubview:self.player];

}
//判断滚动事件，如何超出播放界面，停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.player) {
        if (fabs(scrollView.contentOffset.y)+64 > CGRectGetMaxY(self.player.frame)) {
            [self.player removePlayer];
            self.player = nil;
        }
    }
}






///**
// * Play A Video- 这里是简单的一个播放器，后期需要自定义
// */
//- (void)playVideoWithContentURL:(NSURL*)url{
//    _playerItem = [AVPlayerItem playerItemWithURL:url];
//    _player = [AVPlayer playerWithPlayerItem:_playerItem];
//    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//    _playerLayer.frame = CGRectMake(0, 400, SCREEN_Width, 200) ;
//    [self.view.layer insertSublayer:_playerLayer atIndex:0];
//    [_player play];
//    _isPlay = YES;
//    
//}
//
///**
// * 点击屏幕
// */
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (_player) {
//        if (_isPlay){
//            [_player pause];
//            _isPlay = NO;
//        }else{
//            [_player play];
//            _isPlay = YES;
//        }
//    }
//}
///**
// *初始化界面
// */
//- (void)setUpUI{
//    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, SCREEN_Width-200 , SCREEN_Width-200)];
//    _imageView.image = [UIImage imageNamed:@"chongwu.png"];
//    [self.view addSubview:_imageView];
//    
//    // 选择照片或资源Button
//    UIButton * chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [chooseButton setTitle:@"选择视频或照片来源" forState:UIControlStateNormal];
//    [chooseButton setBackgroundColor:[UIColor purpleColor]];
//    chooseButton.frame =CGRectMake(15, 400, SCREEN_Width-30, 48);
//    [chooseButton addTarget:self action:@selector(chooseSourceFrom) forControlEvents:UIControlEventTouchUpInside];
//    [chooseButton setTitleColor:COLOR(@"#55a5f1") forState:UIControlStateNormal];
//    [self.view addSubview:chooseButton];
//    
//    
//    // 上传按钮
//    UIButton * upLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [upLoadButton setTitle:@"上传视频或图片" forState:UIControlStateNormal];
//    [upLoadButton setBackgroundColor:[UIColor purpleColor]];
//    upLoadButton.frame =CGRectMake(15, 450, SCREEN_Width-30, 48);
//    [upLoadButton addTarget:self action:@selector(uploadVideoWithURL:) forControlEvents:UIControlEventTouchUpInside];
//    [upLoadButton setTitleColor:COLOR(@"#55a5f1") forState:UIControlStateNormal];
//    [self.view addSubview:upLoadButton];
//}
//
///**
// *选择图片来源事件
// */
//- (void)chooseSourceFrom{
//    
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self selectImageFromCamera];
//        
//    }];
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self selectImageFromAlbum];
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVc addAction:cameraAction];
//    [alertVc addAction:photoAction];
//    [alertVc addAction:cancelAction];
//    [self presentViewController:alertVc animated:YES completion:nil];
//}
///**
// *从相册获取照片或视频
// */
//- (void)selectImageFromAlbum
//{
//    NSLog(@"相册");
//    // sourceType 三种
//    /*
//     *UIImagePickerControllerSourceTypePhotoLibrary,
//     *UIImagePickerControllerSourceTypeCamera,
//     *UIImagePickerControllerSourceTypeSavedPhotosAlbum
//     */
//    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//    [self presentViewController:_imagePickerController animated:YES completion:nil];
//}
///**
// *初始化ImagePikerController
// */
//- (void)setUpImagePickerController{
//    _imagePickerController = [[UIImagePickerController alloc] init];
//    _imagePickerController.delegate = self;
//    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    _imagePickerController.allowsEditing = YES;
//}
//
//
///**
// *从摄像头获取图片或视频
// */
//- (void)selectImageFromCamera
//{
//    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    //录制视频时长，默认10s
//    _imagePickerController.videoMaximumDuration = 15;
//    
//    //相机类型（拍照、录像...）字符串需要做相应的类型转换
//    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
//    
//    //视频质量
//    //UIImagePickerControllerQualityTypeHigh高清
//    //UIImagePickerControllerQualityTypeMedium中等质量
//    //UIImagePickerControllerQualityTypeLow低质量
//    //UIImagePickerControllerQualityType640x480
//    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
//    
//    //设置摄像头模式（拍照，录制视频）为录像模式
//    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
//    [self presentViewController:_imagePickerController animated:YES completion:nil];
//}
//
//#pragma mark UIImagePickerControllerDelegate
////该代理方法仅适用于只选取图片时
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
//    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
//}
//
////适用获取所有媒体资源，只需判断资源类型
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
//    //判断资源类型
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
//        NSLog(@"选择完毕----image");
//
//        //如果是图片
//         _imageView.image = info[UIImagePickerControllerEditedImage];
////        压缩图片
//        NSData *fileData = UIImageJPEGRepresentation(_imageView.image, 1.0);
////        保存图片至相册
//        UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerEditedImage], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
////        上传图片
//        [self uploadImageWithData:fileData];
//        
//    }else{
//        //如果是视频
//        NSURL *url = info[UIImagePickerControllerMediaURL];
//        //播放视频
//        _video_Url = url;
//        [self playVideoWithContentURL:_video_Url];
//        //保存视频至相册（异步线程）
//        NSString *urlStr = [url path];
//       CGFloat  beforeConvertSize =  [self getFileSize:urlStr];
//        NSLog(@"%.2fkb",beforeConvertSize);
//        [self getVideoLength:url];
//
//        NSLog(@"NSURL:%@===NSURLStr:%@",url,urlStr);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
//                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//            }
//        });
//        // 转码
////        NSURL *newVideoURL;// MP4
//        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
//        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
//        _outVideoURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
//        
//        NSLog(@"%@",_outVideoURL.path);
//        
//        
//        
//        // 压缩
//        NSLog(@"loading。。。。。");
//        [self convertVideoQuailtyWithInputURL:url outputURL:_outVideoURL completeHandler:nil];
//        
//        //视频上传
//        
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//// 转换为MP4文件-并压缩
//- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
//                               outputURL:(NSURL*)outputURL
//                         completeHandler:(void (^)(AVAssetExportSession*))handler
//{
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
//    
//    /*
//     AVAssetExportPresetLowQuality       输出低质量
//     AVAssetExportPresetMediumQuality    输出中质量
//     AVAssetExportPresetHighestQuality   输出高质量
//     */
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//    //  NSLog(resultPath);
//    exportSession.outputURL = outputURL;
//    exportSession.outputFileType = AVFileTypeMPEG4;
//    exportSession.shouldOptimizeForNetworkUse= YES;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
//     {
//         switch (exportSession.status) {
//             case AVAssetExportSessionStatusCancelled:
//                 NSLog(@"AVAssetExportSessionStatusCancelled");
//                 break;
//             case AVAssetExportSessionStatusUnknown:
//                 NSLog(@"AVAssetExportSessionStatusUnknown");
//                 break;
//             case AVAssetExportSessionStatusWaiting:
//                 NSLog(@"AVAssetExportSessionStatusWaiting");
//                 break;
//             case AVAssetExportSessionStatusExporting:
//                 NSLog(@"AVAssetExportSessionStatusExporting");
//                 break;
//             case AVAssetExportSessionStatusCompleted:
//                 NSLog(@"AVAssetExportSessionStatusCompleted");
//                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
//                 NSLog(@"压缩之后的%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
//                 //保存到手机相册
//                 UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);
//                 [self alertUploadVideo:outputURL];
//                 break;
//             case AVAssetExportSessionStatusFailed:
//                 NSLog(@"AVAssetExportSessionStatusFailed");
//                 break;
//         }
//         
//     }];
//    
//}
//// 根据上传图片的大小做出提示；
//- (void)alertUploadVideo:(NSURL*)URL{
//    CGFloat size = [self getFileSize:[URL path]];
//    NSString *message;
//    NSString *sizeString;
//    CGFloat sizemb= size/1024;
//    if(size<=1024){
//        sizeString = [NSString stringWithFormat:@"%.2fKB",size];
//    }else{
//        sizeString = [NSString stringWithFormat:@"%.2fMB",sizemb];
//    }
//    
//    
//    
//    
//    if(sizemb<2){// 视频小于2M，直接上传
////        [self uploadVideoWithURL:URL];
//        NSLog(@"视频小于2M");
//    }
//    
//    else if(sizemb<=5){// 视频大于2M 小于5M ,给出提示
//        message = [NSString stringWithFormat:@"视频%@，大于2MB会有点慢，确定上传吗？", sizeString];
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
//                                                                                  message: message
//                                                                           preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
//            [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
//        }]];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self uploadVideoWithURL:URL];
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }else if(sizemb>5){// 大于5M ，不能上传
//        message = [NSString stringWithFormat:@"视频%@，超过5MB，不能上传，抱歉。", sizeString];
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
//                                                                                  message: message
//                                                                           preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
//            [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间
//            
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//    }
//}
//#pragma mark - cancle的回调
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
//{
//    NSLog(@"取消");
//    [_imagePickerController dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"已经取消");
//    }];
//}
//
//#pragma mark 图片保存完毕的回调
//- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextIn {
//    if (error) {
//        NSLog(@"图片保存错误%@",error.description)
//    }else{
//        NSLog(@"图片保存至相册成功");
//    }
//}
//#pragma mark 视频保存完毕的回调
//- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextIn {
//    if (error) {
//        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
//    }else{
//        NSLog(@"视频保存成功.");
//    }
//}
//
//#pragma mark -上传图片
//- (void)uploadImageWithData:(NSData*)data{
//    NSLog(@"上传图片的大小%lu",data.length);
//}
//
//#pragma mark -上传视频
//- (void)uploadVideoWithURL:(NSURL*)URL{
//    // [My tools showMesseage:@"正在上传"];
//    [MBProgressHUD showMessage:@"正在上传" toView:self.view];
//    if(NilOrNull(_outVideoURL)){
//        return;
//    }
//    NSData * data = [NSData dataWithContentsOfURL:_outVideoURL];
//    // 上传大文件或视频
//    // 入参
//    NSMutableDictionary * para = [NSMutableDictionary dictionary];
//    para[@"userid"] = @"007";
//    para[@"name"] = @"jamebunde";
//    [NetManger upLoadToUrlString:@"serverUrl" parameters:para fileData:data name:@"serverParaName" fileName:@"fileName" mimeType:AVFileTypeMPEG4 response:JSON progress:^(NSProgress * progress) {
//    } success:^(NSURLSessionDataTask * task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        [MBProgressHUD showSuccess:@"上传成功"];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.description);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error.description]];
//            [MBProgressHUD hideHUDForView:self.view];
//
//        });
//    }];
//}
//
///**
// * 获取视频的大小，单位KB
// */
//- (CGFloat) getFileSize:(NSString *)path
//{
//    NSLog(@"%@",path);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    float filesize = -1.0;
//    if ([fileManager fileExistsAtPath:path]) {
//        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
//        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
//        filesize = 1.0*size/1024;
//    }else{
//        NSLog(@"找不到文件");
//    }
//    return filesize;
//}
///**
// * 获取视频的时长，单位是秒
// */
//- (CGFloat) getVideoLength:(NSURL *)URL
//{
//    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
//    CMTime time = [avUrl duration];
//    int second = ceil(time.value/time.timescale);
//    return second;
//}
@end
