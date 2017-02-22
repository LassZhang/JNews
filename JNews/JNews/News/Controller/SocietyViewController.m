//
//  SocietyViewController.m
//  JNews
//
//  Created by 王震 on 17/2/22.
//  Copyright © 2017年 Joseph. All rights reserved.
//

#import "SocietyViewController.h"
@interface SocietyViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    
}

//- initTopView
- (void)initBannerView{

    
}

//- initTableView
- (void)initTableView{

    
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}


@end
