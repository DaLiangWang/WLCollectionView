//
//  NSObject+WLSel.h
//  Yule
//
//  Created by 王亮 on 2021/1/19.
//  Copyright © 2021 yule.dating. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WLSel)
/** 字符串方法调用 */
-(void)wl_classMethod:(SEL)selector;
/** 带参数的字符串方法调用 */
-(void)wl_classMethod:(SEL)selector object:(id)object;

/** 带返回值的字符串方法调用 */
-(id)wl_classReturnMethod:(SEL)selector;
/** 带参数和返回值的字符串方法调用 */
-(id)wl_classReturnMethod:(SEL)selector object:(id)object;
@end

NS_ASSUME_NONNULL_END
