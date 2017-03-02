//
//  SocietyViewController.m
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "SocietyViewController.h"
#import "TopData.h"
#import "TopViewController.h"
#import "WZRefreshGifHeader.h"
#import "DataModel.h"
#import "NewsCell.h"
#import "ImagesCell.h"
#import "TopCell.h"
#import "BigImageCell.h"
@interface SocietyViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic , strong) NSMutableArray *totalArray;
@property (nonatomic , strong) SDCycleScrollView*bannerView;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *imagesArray;
@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , assign) int page;



@end

@implementation SocietyViewController

- (NSMutableArray *)totalArray{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}
- (NSMutableArray *)topArray{
    if (! _topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社会";
    [self initTopNet];
    [self initTableView];
    [self initBannerView];
    
}
//请求滚动数据
- (void)initTopNet{
    IMP_BLOCK_SELF(SocietyViewController);
    
    [[NetManger shareEngine] runRequestWithPara:nil path:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-10.html"success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * dataArray = [TopData mj_objectArrayWithKeyValuesArray:responseObject[@"T1348647853363"][0][@"ads"]];
        NSLog(@"%@",dataArray);
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *topArray = [NSMutableArray array];
        for (TopData * data in dataArray) {
            [topArray addObject:data];
            [statusFrameArray addObject:data.imgsrc];
            [titleArray addObject:data.title];
        }
        [block_self.topArray addObjectsFromArray:topArray];
        [block_self.imagesArray addObjectsFromArray:statusFrameArray];
        [block_self.titleArray addObjectsFromArray:titleArray];
        
        // 绑定数据
        _bannerView.titlesGroup = block_self.titleArray;
        _bannerView.imageURLStringsGroup = block_self.imagesArray;
        // 点击回调事件
        _bannerView.clickItemOperationBlock = ^(NSInteger index){
            TopData *data = block_self.topArray[index];
            NSString * url1;
            if (data.url.length >4) {
                url1 = [data.url substringFromIndex:4];
                if (url1.length >4) {
                    url1 = [url1 substringToIndex:4];
                }else{
                    NSLog(@"validURL：%@",url1) ;
                    return ;
                }
            }else{
                NSLog(@"%@",url1);
            }
            NSString *url2;
            if (data.url.length > 9) {
                url2 = [data.url substringFromIndex:9];
                
                url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
                
            }
            TopViewController *topVC = [[TopViewController alloc]init];
            topVC.url = url2;
            [block_self.navigationController pushViewController:topVC animated:YES];
            [block_self.navigationController hidesBottomBarWhenPushed];
        };
    } failure:^(id error) {
        
    }];

}
//- initTopView
- (void)initBannerView{
    SDCycleScrollView * banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Width* 0.55) delegate:self placeholderImage:[UIImage imageNamed:@"chongwu"]];
    banner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    self.tableview.tableHeaderView = banner;
    _bannerView = banner;
    
}

//- initTableView
- (void)initTableView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height-49-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    self.tableview =tableView;
    IMP_BLOCK_SELF(SocietyViewController);
    
    WZRefreshGifHeader * header = [WZRefreshGifHeader headerWithRefreshingBlock:^{
        block_self.page = 0;
        [block_self requestNet:1];

    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.header = header;
    [header beginRefreshing];
    
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self requestNet:2];
    }];
}

- (void)requestNet:(int)type{
    IMP_BLOCK_SELF(SocietyViewController);
    NSString *urlstr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%d-20.html",self.page];
    
    [[NetManger shareEngine] runRequestWithPara:nil path:urlstr success:^(id responseObject) {
        
        NSArray *temArray = responseObject[@"T1348647853363"];
        NSArray *arrayM = [DataModel mj_objectArrayWithKeyValuesArray:temArray];
        NSMutableArray *statusArray = [NSMutableArray array];
        for (DataModel *data in arrayM) {
            [statusArray addObject:data];
        }
        
        if (type == 1) {
            block_self.totalArray = statusArray;
        }else{
            [block_self.totalArray addObjectsFromArray:statusArray];
        }
        [block_self.tableview reloadData];
        block_self.page += 20;
        
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
        
    } failure:^(id error) {
        if (error) {
            NSLog(@"%@",error);
        }
        [block_self.tableview.header endRefreshing];
        [block_self.tableview.footer endRefreshing];
        
    }];

}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _totalArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    DataModel *newsModel = self.totalArray[indexPath.row];
    
    NSString *ID = [NewsCell idForRow:newsModel];
    
    if ([ID isEqualToString:@"NewsCell"]) {
        
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
//        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
//            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
//            cell.lblTitle.textColor = [UIColor whiteColor];
//        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.lblTitle.textColor = [UIColor blackColor];
        }
        cell.dataModel = newsModel;
        return cell;
    }else if ([ID isEqualToString:@"ImagesCell"]){
        ImagesCell *cell = [ImagesCell cellWithTableView:tableView];
//        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
//            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
//        }
//        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.dataModel = newsModel;
        return cell;
    }else if ([ID isEqualToString:@"TopImageCell"]){
        
        TopCell *cell = [TopCell cellWithTableView:tableView];
//        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
//            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
//        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
        
    }else if([ID isEqualToString:@"TopTxtCell"]){
        
        TopCell *cell = [TopCell cellWithTableView:tableView];
//        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
//            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
//        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
        
    }else{
        BigImageCell *cell = [BigImageCell cellWithTableView:tableView];
//        if ([defaultManager.themeName isEqualToString:@"高贵紫"]) {
//            cell.backgroundColor = [[ThemeManager sharedInstance] themeColor];
//        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.dataModel = newsModel;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataModel *newsModel = self.totalArray[indexPath.row];
    
    CGFloat rowHeight = [NewsCell heightForRow:newsModel];
    
    return rowHeight;  
}
#pragma mark -SDCycleViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了%ld",index);
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"当前滑到%ld张",index);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入该页面时，重启Timer
    [_bannerView startScroll];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 解决当Push到下一页时，上一页的视图还在回调代理
    [_bannerView stopScroll];
}
@end
