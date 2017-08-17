//
//  ViewControllerFactory.h
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+callback.h"

@interface ViewControllerFactory : NSObject

+(instancetype) mainFactory;

/**
 以指定控制器跳转新的控制器
 
 @param vcId 控制器ID(以类名命名)
 @param vc navController
 @param model model
 @param callback 操作回调
 */
- (void) pushWithVcId:(NSString *) vcId vc:(UIViewController *) vc model:(id) model callback:(void(^) (id model)) callback;

/**
 以当前活动控制器跳转新的控制器
 
 @param vcId 控制器ID(以类名命名)
 @param modelKey key
 @param model model
 @param callback 操作回调
 */
- (void) pushWithVcId:(NSString *) vcId modelKey:(NSString *) modelKey model:(id) model callback:(void(^) (id model)) callback;

/**
 以当前活动控制器跳转新的控制器
 
 @param vcId 控制器ID(以类名命名)
 @param controller 制定控制器
 @param modelKey key
 @param model model
 @param callback 操作回调
 */
- (void) pushWithVcId:(NSString *) vcId controller:(UIViewController *) controller modelKey:(NSString *) modelKey model:(id) model callback:(void(^) (id model)) callback;

@end
