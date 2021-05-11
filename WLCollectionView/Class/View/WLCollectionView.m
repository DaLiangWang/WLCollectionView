//
//  WLCollectionView.m
//  LookNovel
//
//  Created by chuangqi on 2021/3/19.
//  Copyright © 2021 cq Co.,ltd. All rights reserved.
//

#import "WLCollectionView.h"

@implementation WLCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
/** 初始化对象   默认的FlowLayout 水平*/
+ (instancetype)initWithHorizontalDelegate:(id)delegate{
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc]init];
    [Layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    WLCollectionView *view = [[WLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:Layout];
    view.collection_delegate.delegate = delegate;
    view.collection_delegate.delegateTie = delegate;
    view.collection_delegate.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return view;
}
/** 初始化对象    默认的FlowLayout  垂直*/
+ (instancetype)initWithVerticalDelegate:(id)delegate{
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc]init];
    [Layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    WLCollectionView *view = [[WLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:Layout];
    view.collection_delegate.delegate = delegate;
    view.collection_delegate.delegateTie = delegate;
    view.collection_delegate.scrollDirection = UICollectionViewScrollDirectionVertical;
    return view;
}
/** 初始化对象  自定义的FlowLayout */
+ (instancetype)initWithDelegate:(id)delegate layout:(UICollectionViewFlowLayout *)layout{
    WLCollectionView *view = [[WLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    view.collection_delegate.delegate = delegate;
    view.collection_delegate.delegateTie = delegate;
    return view;
}



/** 页面是处于初始化状态 */
- (BOOL)initReload{
    return !self.collection_delegate.isNotReload;
}
/** 获取所有的Section数据 */
- (NSArray <WLBaseCollectionViewLayerSection *> *)getAllSection{
    return self.collection_delegate.viewModel.viewLayer;
}
/** 获取所有的Row数据 */
- (NSArray <WLBaseCollectionViewLayerRow *> *)getAllRow{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.collection_delegate.viewModel.viewLayer.count ; i++) {
        WLBaseCollectionViewLayerSection *section = [self.collection_delegate.viewModel.viewLayer objectAtIndex:i];
        [array addObjectsFromArray:section.item];
    }
    return array;
}



/** 重新设置所有分组 并刷新 */
- (void)setAllSection:(NSArray<WLBaseCollectionViewLayerSection *> *)sectionList{
    [sectionList enumerateObjectsUsingBlock:^(WLBaseCollectionViewLayerSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
        [obj.item enumerateObjectsUsingBlock:^(WLBaseCollectionViewLayerRow * _Nonnull objs, NSUInteger idxs, BOOL * _Nonnull stops) {
            objs.indexPath = [NSIndexPath indexPathForRow:idxs inSection:idx];
        }];
    }];
    self.collection_delegate.viewModel.viewLayer = [NSMutableArray arrayWithArray:sectionList];
    [self reloadData_wl];
}


/** 重新设置多个个分组  并刷新多个分组 只刷新分组item  */
- (void)setSection:(WLBaseCollectionViewLayerSection *)section{
    [self setSectionList:@[section]];
}
/** 重新设置单个分组  并刷新单个分组 只刷新分组item  */
- (void)setSectionList:(NSArray<WLBaseCollectionViewLayerSection *> *)sections{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    BOOL isReloadAll = NO;
    for (WLBaseCollectionViewLayerSection *section in sections) {
        while (self.collection_delegate.viewModel.viewLayer.count < ([section.indexPath section] + 1)) {
            [self.collection_delegate.viewModel.viewLayer addObject:[WLBaseCollectionViewLayerSection new]];
            isReloadAll = YES;
        }
        [section.item enumerateObjectsUsingBlock:^(WLBaseCollectionViewLayerRow * _Nonnull objs, NSUInteger idxs, BOOL * _Nonnull stops) {
            objs.indexPath = [NSIndexPath indexPathForRow:idxs inSection:[section.indexPath section]];
        }];
        [self.collection_delegate.viewModel.viewLayer replaceObjectAtIndex:[section.indexPath section] withObject:section];
        [set addIndex:[section.indexPath section]];
    }
    isReloadAll?[self reloadData_wl]:[self reloadSections_wl:set];
}


/** 重新设置单个item  并刷新单个item */
- (void)setRow:(WLBaseCollectionViewLayerRow *)row{
    [self setRowList:@[row]];
}
/** 重新设置多个item  并刷新多个item */
- (void)setRowList:(NSArray <WLBaseCollectionViewLayerRow *> *)rows{
    NSMutableArray *array = [NSMutableArray array];
    [rows enumerateObjectsUsingBlock:^(WLBaseCollectionViewLayerRow * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
        WLBaseCollectionViewLayerSection *section = [self.collection_delegate.viewModel getSectionModel:row.indexPath];
        [section.item replaceObjectAtIndex:row.indexPath.row withObject:row];
        [array addObject:row.indexPath];
    }];
    [self reloadItemsAtIndexPaths_wl:array];
}
/** 刷新collection的时候 */
-(void)reloadData_wl{
    self.collection_delegate.isNotReload = YES;
    [super reloadData];
}
-(void)reloadSections_wl:(NSIndexSet *)sections{
    self.collection_delegate.isNotReload = YES;
    [super reloadSections:sections];
}
-(void)reloadItemsAtIndexPaths_wl:(NSArray<NSIndexPath *> *)indexPaths{
    self.collection_delegate.isNotReload = YES;
    [super reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark -- 懒加载
-(WLCollectionViewDelegate *)collection_delegate{
    if (!_collection_delegate){
        _collection_delegate = [[WLCollectionViewDelegate alloc] initWithCollection:self];
        _collection_delegate.viewModel.viewLayer = [NSMutableArray array];
    }
    return _collection_delegate;
}
@end
