//
//  vipListVC.m
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//

#import "vipListVC.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "NSObject+apiManager.h"
#import "videoWebVC.h"

@interface vipListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nullable, nonatomic, strong) UITableView *tableView;
@property (nullable, nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation vipListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tableView];
}


// MARK: - Delegate

// MARK: - UITableViewDelegate
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}
  
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] init];
    }
    headerView.textLabel.adjustsFontSizeToFitWidth = YES;
    headerView.textLabel.minimumScaleFactor = 0.55;
    headerView.textLabel.textColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.7];
    headerView.textLabel.text = @"由可爱的江盈滢小朋友爸爸友情提供";
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"___identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.dataArray.count > indexPath.row) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.textLabel.text = dic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count > indexPath.row) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        videoWebVC *vc = [[videoWebVC alloc] init];
        vc.platformDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
 
/// MARK: - NetApi
- (void)refreshData {
    
    // https://github.com/adxiaoquan32/vipVideo/blob/master/vipIosVersion/vlist.json
    
    NSString *url = @"https://raw.githubusercontent.com/adxiaoquan32/vipVideo/master/vipIosVersion/vlist.json";
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"___sucess:%@",responseObject);
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"___failed:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
    
    
//    [self.sessionManager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"___sucess:%@",responseObject);
//        [self.tableView.mj_header endRefreshing];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"___failed:%@",error);
//        [self.tableView.mj_header endRefreshing];
//    }];
     
}

- (void)footerRefresh {
    
    
}

- (NSMutableArray *)dataArray{
    if ( !_dataArray ) {
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObjectsFromArray:self.p2pPlatList];
    }
    return _dataArray;
}
  
- (UITableView *)tableView {
    
    if (_tableView) return _tableView;
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    //_tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
      
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(weakSelf.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        }
    }];
      
    
    return _tableView;
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
