//
//  WLBaseCollectionViewLayerSection.h
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLBaseCollectionReusableModel.h"
#import "WLBaseCollectionViewLayerRow.h"

@interface WLBaseCollectionViewLayerSection : NSObject
/** section 当前坐标 */
@property (nonatomic,strong) NSIndexPath *indexPath;

#pragma mark -- section 内视图位置
/** section 内边距 */
@property(nonatomic,assign) UIEdgeInsets insetForSection;
/** section内，cell的间距 垂直 间距 */
@property(nonatomic,assign) CGFloat verticalSection;

/** section内，cell的间距 水平 间距 */
@property(nonatomic,assign) CGFloat horizontalSection;
/** section内，cell的间距 水平 item个数 */
@property(nonatomic,assign) NSInteger horizontalCount;
/** section内，cell的 水平 最大宽度 */
@property(nonatomic,assign) CGFloat horizontalMaxWidth;

/** 获取单个itemCell 的宽度 */
-(CGFloat)getCellWidth;
/** 获取单个itemCell 的大小 */
-(CGSize)getCellSizeHeight:(CGFloat)height;

#pragma mark -- section 头视图
@property(nonatomic,strong) WLBaseCollectionReusableModel *headerItem;

#pragma mark -- section 脚视图
@property(nonatomic,strong) WLBaseCollectionReusableModel *footItem;

/** 组的数据 */
@property (nonatomic,strong) id data;


/** row 列表 数据 */
@property(nonatomic,strong) NSMutableArray <WLBaseCollectionViewLayerRow *> *item;
@end
