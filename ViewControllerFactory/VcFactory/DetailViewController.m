//
//  DetailViewController.m
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑人员信息";
    if (self.model) {
        self.txtName.text = self.model.name;
        self.txtAge.text = self.model.age;
    }
}

- (IBAction)commitTouchAction:(id)sender {
    self.model.name = self.txtName.text;
    self.model.age = self.txtAge.text;
    if (self.callback) {
        self.callback(self.model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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
