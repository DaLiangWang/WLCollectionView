//
//  WLCollectionView.h
//  LookNovel
//
//  Created by chuangqi on 2021/3/19.
//  Copyright © 2021 cq Co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLCollectionViewDelegate.h"
#import "UICollectionViewCell+WLCell.h"
#import "UICollectionReusableView+WLReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLCollectionView : UICollectionView
@property (nonatomic,strong) WLCollectionViewDelegate *collection_delegate;
/** 初始化对象   默认的FlowLayout 水平*/
+ (instancetype)initWithHorizontalDelegate:(id)delegate;
/** 初始化对象    默认的FlowLayout  垂直*/
+ (instancetype)initWithVerticalDelegate:(id)delegate;
/** 初始化对象  自定义的FlowLayout */
+ (instancetype)initWithDelegate:(id)delegate layout:(UICollectionViewFlowLayout *)layout;


/** 页面是处于初始化状态 */
- (BOOL)initReload;

/** 获取所有的Section数据 */
- (NSArray <WLBaseCollectionViewLayerSection *> *)getAllSection;
/** 获取所有的Row数据 */
- (NSArray <WLBaseCollectionViewLayerRow *> *)getAllRow;


/**
 第一次初始化必须使用这个,否则 请在每个视图模型上添加 IndexSet 或者 IndexPath 坐标
 重新设置所有分组 并刷新
 */
- (void)setAllSection:(NSArray<WLBaseCollectionViewLayerSection *> *)sectionList;

/** 重新设置多个个分组  并刷新多个分组 只刷新分组item 不刷新分组数据 */
- (void)setSection:(WLBaseCollectionViewLayerSection *)section;
/** 重新设置单个分组  并刷新单个分组 只刷新分组item 不刷新分组数据 */
- (void)setSectionList:(NSArray<WLBaseCollectionViewLayerSection *> *)sections;

/** 重新设置单个item  并刷新单个item */
- (void)setRow:(WLBaseCollectionViewLayerRow *)row;
/** 重新设置多个item  并刷新多个item */
- (void)setRowList:(NSArray <WLBaseCollectionViewLayerRow *> *)rows;
@end

NS_ASSUME_NONNULL_END
