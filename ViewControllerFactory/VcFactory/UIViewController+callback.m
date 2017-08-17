//
//  UIViewController+callback.m
//  VcFactory
//
//  Created by tz on 2017/7/22.
//  Copyright © 2017年 zk. All rights reserved.
//

#import "UIViewController+callback.h"
#import <objc/runtime.h>

@implementation UIViewController (callback)

@dynamic callback;

-(void (^)(id))callback{
    return objc_getAssociatedObject(self, @"callback");
}

-(void)setCallback:(void (^)(id))callback{
    objc_setAssociatedObject(self, @"callback", callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
