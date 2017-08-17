//
//  UIViewController+callback.h
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (callback)

/**
 callback
 */
@property (nonatomic,copy) void(^callback) (id model);

@end
