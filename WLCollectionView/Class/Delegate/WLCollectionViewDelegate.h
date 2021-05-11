//
//  WLCollectionView.h
//  链式语法
//
//  Created by shushui on 2018/8/16.
//  Copyright © 2018年 shushui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLBaseCollectionViewLayerModel.h"
#import "UIScrollView+WLEmptyDataSet.h"

@protocol WLCollectionDelegate <NSObject>
@required

@optional
//cell创建
-(UICollectionViewCell *)wl_collectionView:(UICollectionView *)collectionView
                                layerModel:(WLBaseCollectionViewLayerModel *)model
                             cellIndexPath:(NSIndexPath *)indexPath;

//头脚视图创建
- (UICollectionReusableView *)wl_collectionView:(UICollectionView *)collectionView
              viewForSupplementaryElementOfKind:(NSString *)kind
                              layersectionModel:(id)section
                                    atIndexPath:(NSIndexPath *)indexPath;
//点击cell的响应
- (void)wl_collectionView:(UICollectionView *)collectionView
               layerModel:(WLBaseCollectionViewLayerModel *)layerModel
             didIndexPath:(NSIndexPath *)indexPath;
- (void)wl_collectionView:(UICollectionView *)collectionView
               layerModel:(WLBaseCollectionViewLayerModel *)layerModel
             layerRowData:(id)rowData
             didIndexPath:(NSIndexPath *)indexPath;

// 结束拖拽时触发
- (void)wl_scrollViewDidEndDragging:(UIScrollView *)scrollView  willDecelerate:(BOOL)decelerate;

// 换页
- (void)wl_changeDragging:(UIScrollView *)scrollView pageNumber:(NSInteger)pageNumber;

// 滚动就会触发
- (void)wl_scrollViewDidScroll:(UIScrollView *)scrollView;

#pragma mark --缺省页
/** 自定义显示视图 */
- (UIView *)wl_customViewForWLEmptyDataSet;
/** 强制显示空数据集：当项目数量大于0时，请求代理是否仍应显示空数据集。（默认值为NO） */
- (BOOL)wl_emptyDataSetShouldBeForcedToDisplay;
/** 点击刷新按钮 */
- (void )wl_clickReloadButton;
@end


@interface WLCollectionViewDelegate : NSObject <UICollectionViewDelegate,UICollectionViewDataSource,WLEmptyDataSetSource, WLEmptyDataSetDelegate>
/** cell需要绑定代理的对象 */
@property(nonatomic,strong) id delegateTie;
/** 资深代理对象 */
@property(nonatomic,weak) id<WLCollectionDelegate> delegate;
/** collection 对象 */
@property(nonatomic,strong) UICollectionView *collection;
/** 判断是否为初次初始化，用于判断空白页样式 */
@property(nonatomic,assign) BOOL isNotReload;
/** 滚动方向，根据滚动方向进行滑动换页计算 */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
/** 初始化对象 待废弃 */
- (instancetype)initWithDelegate:(id)delegate collection:(UICollectionView *)collection;
/** 初始化对象 新 */
- (instancetype)initWithCollection:(UICollectionView *)collection;
/** 视图展示模型 */
@property(nonatomic,strong) WLBaseCollectionViewLayerModel *viewModel;

@end
