//
//  WLBaseCollectionReusable.h
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WLBaseCollectionReusableModel : NSObject
#pragma mark -- section 头视图或者脚视图模型
/** section 头试图大小 */
@property(nonatomic,assign) CGSize size;
/** 默认的 头试图 的Class */
@property (readwrite) Class viewClass;
/** 默认的 头试图 的Nic创建的Class */
@property (readwrite) Class nibClass;
/** section 头试图数据 */
@property(nonatomic,strong) id data;

@end
