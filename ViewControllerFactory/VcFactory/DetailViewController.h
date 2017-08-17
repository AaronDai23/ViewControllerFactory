//
//  DetailViewController.h
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableInfoModel.h"
#import "UIViewController+callback.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITextField *txtAge;

@property (nonatomic,strong) TableInfoModel *model;

@end
