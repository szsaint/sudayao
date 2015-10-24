//
//  MainViewController.m
//  sudayao
//
//  Created by yyx on 15/10/13.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "MainViewController.h"

#pragma mark -- 自定义轮播图控件
#import "BannerView.h"

#pragma mark -- SDWebImage
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainViewController ()<BannerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *cityStr;

@end

@implementation MainViewController{
    UITableView *_mainTableView;
    BannerView *_bannerView;
    UIView *_saleView;
    NSArray *_bannerImageNamesArray;
    UIButton *_cityBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initUserInterface];
    [self initUserData];
}

/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    _cityBtn = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:({
            CGRect frame = CGRectMake(0, 0, 30, 30);
            frame;
        })];
        [btn setTitle:_cityStr forState:UIControlStateNormal];
        btn;
    });
    UIBarButtonItem *cityItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_cityBtn];
        item;
    });
    
    self.navigationItem.leftBarButtonItem = cityItem;
}

/**
 *  初始化用户界面
 */
-(void)initUserInterface{
    
    _mainTableView = ({
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:({
            CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            frame;
        })];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView;
    });
    
    //轮播图控件初始化
    _bannerView = ({
        BannerView *bannerView = [[BannerView alloc] initWithFrame:({
            CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
            frame;
        })];
        bannerView.delegate = self;
        bannerView;
    });
    
    UIImageView *saleImageLeft = ({
        UIImageView *img = [[UIImageView alloc] initWithFrame:({
            CGRect frame = CGRectMake(0, 0, (SCREEN_WIDTH-1)/2, 100);
            frame;
        })];
        [img sd_setImageWithURL:[NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/b3b7d0a20cf431ad06c0d4f14836acaf2fdd98ec.jpg"]];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img;
    });
    
    UIImageView *saleImageRight = ({
        UIImageView *img = [[UIImageView alloc] initWithFrame:({
            CGRect frame = CGRectMake((SCREEN_WIDTH-1)/2+1, 0, (SCREEN_WIDTH-1)/2, 100);
            frame;
        })];
        [img sd_setImageWithURL:[NSURL URLWithString:@"https://www.baidu.com/img/bd_logo1.png"]];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img;
    });
    
    _saleView = ({
        UIView *view = [[UIView alloc] initWithFrame:({
            CGRect frame = CGRectMake(0, 5, SCREEN_WIDTH, 100);
            frame;
        })];
        
        view;
    });
    
    [_saleView addSubview:saleImageLeft];
    [_saleView addSubview:saleImageRight];
    
    
    [self.view addSubview:_mainTableView];
    
}


/**
 *  初始化数据
 */
-(void)initUserData{
    //test
    _bannerImageNamesArray = [NSArray arrayWithObjects:@"http://f.hiphotos.baidu.com/image/pic/item/b3b7d0a20cf431ad06c0d4f14836acaf2fdd98ec.jpg",@"https://www.baidu.com/img/bd_logo1.png",@"bannertest",nil];
    _cityStr = @"张家港";
    /*******************************/
    [_bannerView bindImageNameArray:_bannerImageNamesArray autoSCrollEnable:NO titles:nil];
}

-(void)presseImageAtIndex:(NSInteger)index{
    
}

#pragma mark -- UITableViewDataSource start

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 150;
            break;
        case 1:
            return 100;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"bannercell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell addSubview:_bannerView];
        }
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIdentifier = @"salecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell addSubview:_saleView];
        }
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellIdentifier = @"cartcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"111";
        }
        return cell;
    }
    return nil;
}

#pragma mark -- UITableViewDataSource end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
