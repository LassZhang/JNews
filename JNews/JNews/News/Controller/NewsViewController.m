//
//  NewsViewController.m
//  JNews
//
//  Created by 王震 on 17/2/21.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "NewsViewController.h"
#import "NavTabBar.h"
#import "SocietyViewController.h"
#import "OthersViewController.h"
@interface NewsViewController ()<NavTabBarDelegate,UIScrollViewDelegate>
{
    NSInteger        _currentIndex;
    NSMutableArray  *_titles;
    
    NavTabBar       *_navTabBar;
    UIScrollView    *_mainView;
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 监听主题
    [self initControl];
    [self initConfig];
    [self viewConfig];

}
- (void)initControl{
    // 标题Array
    NSArray *namearray = [NSArray array];
    namearray = @[@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"];
    // 内容Array
    NSArray *contentarray = [NSArray array];
    contentarray = @[@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health"];
    _titles = [namearray mutableCopy];
    
    // ViewControllerArray
    NSMutableArray * VCarray = [NSMutableArray array];
    
    
    // Controller
    SocietyViewController * societyVC = [[SocietyViewController alloc]init];
    societyVC.title  = @"社会";
    [VCarray addObject:societyVC];
    
    for (int i = 0; i < namearray.count; i++) {
        OthersViewController * otVC = [[OthersViewController alloc]init];
        otVC.title = namearray[i];
        otVC.content = contentarray[i];
        [VCarray addObject:otVC];
    }
    _subViewControllers = [NSArray array];
    _subViewControllers = VCarray;
}

- (void)initConfig{
    _currentIndex = 1;
    
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    
    for (UIViewController *viewController in _subViewControllers)
    {
        // 将各个Controller 的title 加入标题数组
        [_titles addObject:viewController.title];
    }
    
}
- (void)viewConfig{
    
    [self viewInit];
    
    // 加载第一个视图
    BaseViewController *viewController = (BaseViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, SCREEN_Width , SCREEN_Height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
    
}
// 初始化NavTabBar和mainView
- (void)viewInit{
    // 顶部栏
    _navTabBar                 = [[NavTabBar alloc]initWithFrame:CGRectMake(0, 20, SCREEN_Width , 44)];
    // 暂定为透明，以后跟随主题
    _navTabBar.backgroundColor = [UIColor whiteColor];
    _navTabBar.lineColor       = _navTabBarLineColor;
    _navTabBar.delegate        = self;
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    // mainView
    _mainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_Width, SCREEN_Height-64)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBounces;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_Width*_subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
    //seperatorLine -not the topNavUnderLine
    UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_Width, 1)];
    linev.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];
    [self.view addSubview:linev];
    
    // the rightedge button- to weatherController or otherelse
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_Width - 40, 20, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(weatherClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
    
}
#pragma mark- weatherClickEvent
- (void)weatherClick{
    NSLog(@"click the weather Button")
}
#pragma mark-ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _currentIndex = scrollView.contentOffset.x / SCREEN_Width;
    _navTabBar.currentItemIndex = _currentIndex;// 此处很重要，传递currentIndex 可以让小红条跟随移动
    
    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * SCREEN_Width, 0, SCREEN_Width, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
    
    
    
}
#pragma mark-NavTabBardelegate
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex{
    NSLog(@"MainView moved ");
    if ((index - currentIndex) >= 2 || (index - currentIndex) <= -2) {// 超过一个的取消动画
        [_mainView setContentOffset:CGPointMake(index * SCREEN_Width, 0) animated:NO];

    } else {
        [_mainView setContentOffset:CGPointMake(index * SCREEN_Width, 0) animated:YES];

    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
