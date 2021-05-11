//
//  NSObject+WLSel.m
//  Yule
//
//  Created by 王亮 on 2021/1/19.
//  Copyright © 2021 yule.dating. All rights reserved.
//

#import "NSObject+WLSel.h"

@implementation NSObject (WLSel)
/** 字符串方法调用 */
-(void)wl_classMethod:(SEL)selector{
    if (!self) { return; }
    if (![self respondsToSelector:selector]){
        NSLog(@"!!!warning!!!--->目标类：%@<-->未实现：%@ 方法定义",NSStringFromClass(self.class),NSStringFromSelector(selector));
        return;
    }
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
}
/** 带参数的字符串方法调用 */
-(void)wl_classMethod:(SEL)selector object:(id)object{
    if (!self) { return; }
    if (![self respondsToSelector:selector]){
        NSLog(@"!!!warning!!!--->目标类：%@<-->未实现：%@ 方法定义",NSStringFromClass(self.class),NSStringFromSelector(selector));
        return;
    }
    IMP imp = [self methodForSelector:selector];
    id (*func)(id, SEL, id) = (void *)imp;
    func(self, selector, object);
}

/** 带返回值的字符串方法调用 */
-(id)wl_classReturnMethod:(SEL)selector{
    if (!self) { return nil; }
    if (![self respondsToSelector:selector]){
        NSLog(@"!!!warning!!!--->目标类：%@<-->未实现：%@ 方法定义",NSStringFromClass(self.class),NSStringFromSelector(selector));
        return nil;
    }
    IMP imp = [self methodForSelector:selector];
    id (*func)(id, SEL) = (void *)imp;
    return func(self, selector);
}
/** 带参数和返回值的字符串方法调用 */
-(id)wl_classReturnMethod:(SEL)selector object:(id)object{
    if (!self) { return nil; }
    if (![self respondsToSelector:selector]){
        NSLog(@"!!!warning!!!--->目标类：%@<-->未实现：%@ 方法定义",NSStringFromClass(self.class),NSStringFromSelector(selector));
        return nil;
    }
    IMP imp = [self methodForSelector:selector];
    id (*func)(id, SEL, id) = (void *)imp;
    return func(self, selector, object);
}
@end
