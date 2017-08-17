//
//  ViewControllerFactory.m
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import "ViewControllerFactory.h"

#import <objc/runtime.h>

#import "MJExtension.h"

static ViewControllerFactory *mainVcFactory;

@implementation ViewControllerFactory

+(instancetype) mainFactory{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainVcFactory = [[ViewControllerFactory alloc] init];
    });
    return mainVcFactory;
}

#pragma mark 界面跳转

/**
 以指定控制器跳转新的控制器
 
 @param vcId 控制器ID(以类名命名)
 @param vc navController
 @param model model
 @param callback 操作回调
 */
- (void) pushWithVcId:(NSString *) vcId vc:(UIViewController *) vc model:(id) model callback:(void(^) (id model)) callback{
    //默认 model
    [self pushWithVcId:vcId controller:vc modelKey:@"model" model:model callback:callback];
}

/**
 以当前活动控制器跳转新的控制器

 @param vcId 控制器ID(以类名命名)
 @param modelKey key
 @param model model
 @param callback 操作回调
 */
- (void) pushWithVcId:(NSString *) vcId modelKey:(NSString *) modelKey model:(id) model callback:(void(^) (id model)) callback{
    [self pushWithVcId:vcId controller:nil modelKey:modelKey model:model callback:callback];
}

/**
 以当前活动控制器跳转新的控制器
 
 @param vcId 控制器ID(以类名命名)
 @param controller 制定控制器
 @param modelKey key
 @param model model
 @param callback 操作回调
 */
- (void) pushWithVcId:(NSString *) vcId controller:(UIViewController *) controller modelKey:(NSString *) modelKey model:(id) model callback:(void(^) (id model)) callback {
    const char *className = [vcId cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        [self alertMsg:@"找不到要打开的窗口"];
        return;
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    if (![instance isKindOfClass:[UIViewController class]]) {
        [self alertMsg:@"创造了非视图控制器"];
        return;
    }
    if (modelKey) {
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:modelKey]) {
            //是否为系统类型
            NSString *propertyClassName = [self checkPropertyIsSystemClassWidthInstance:instance propertyName:modelKey];
            if (propertyClassName == nil) {
                [instance setValue:model forKey:modelKey];
            }else{
                id valModel = model;
                
                //此方式是新创建对象不会有对象引用关系（仅用于推送打开窗口,不适用于回调操作）
                if ([model isKindOfClass:[NSDictionary class]] ||
                    [model isKindOfClass:[NSString class]])
                {
                    Class modelCalss = objc_getClass([propertyClassName cStringUsingEncoding:NSASCIIStringEncoding]);
                    valModel = [modelCalss mj_objectWithKeyValues:model];
                }else if ([model isKindOfClass:[NSArray class]]){
                    Class modelCalss = objc_getClass([propertyClassName cStringUsingEncoding:NSASCIIStringEncoding]);
                    valModel = [modelCalss mj_objectArrayWithKeyValuesArray:model];
                }
                
                [instance setValue:valModel forKey:modelKey];
            }
        }
    }
    if (callback) {
        [instance setCallback:callback];
    }
    UIViewController *vc = controller == nil ? [self topViewController] : controller;
    [[vc navigationController] pushViewController:instance animated:YES];
}

#pragma mark - private method

- (NSString *) checkPropertyIsSystemClassWidthInstance:(id) instance propertyName:(NSString *) propertyName {
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    objc_property_t property = NULL;
    for (i = 0; i < outCount; i++) {
        property = properties[i];
        //  属性名转成字符串
        unsigned int attrCount = 0;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
        objc_property_attribute_t attr = attrs[0];
        NSString *tempPropertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([tempPropertyName isEqualToString:propertyName]) {
            NSString *propertyClassName = [[NSString alloc] initWithCString:attr.value encoding:NSUTF8StringEncoding];
            propertyClassName = [[propertyClassName stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            free(properties);
            return propertyClassName;
        }
    }
    free(properties);
    
    return nil;
}

/**
 检测属性是否存在

 @param instance 对象
 @param verifyPropertyName 验证属性名
 @return true false
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

- (void) alertMsg:(NSString *) msg {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示"
                                                                message:msg
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [[[self topViewController] navigationController] presentViewController:vc animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [vc dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - 获取当前活动控制器

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


@end
