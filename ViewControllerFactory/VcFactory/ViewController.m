//
//  ViewController.m
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import "ViewController.h"
#import "TableInfoModel.h"
#import "DetailViewController.h"
#import "Constant.h"
#import "MJExtension.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray  *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma makr - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableInfoModel *model = self.dataSource[indexPath.row];
    static NSString *identify = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@  年龄:%@岁",model.name,model.age];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //通过 json 串 来模拟推送
//    NSString *model = [@"1" mj_JSONString];
    //直接 模型
//    id model = self.dataSource[indexPath.row];
    NSString *model = [@[@"2",@"1"] mj_JSONString];
    
    [VC_FACTORY pushWithVcId:VC_DETAIL vc:self model:model callback:^(id model) {
        NSLog(@"我曹，回调了!");
        [self.tableView reloadData];
    }];
}

#pragma mark - 

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            TableInfoModel *model = [[TableInfoModel alloc] init];
            model.name = [NSString stringWithFormat:@"王杰希%d",i];
            model.age = [NSString stringWithFormat:@"%d",17 + i];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
