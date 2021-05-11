//
//  WLCollectionView.m
//  链式语法
//
//  Created by shushui on 2018/8/16.
//  Copyright © 2018年 shushui. All rights reserved.
//

#import "WLCollectionViewDelegate.h"
#import "NSObject+WLSel.h"

@interface WLCollectionViewDelegate ()

@end
@implementation WLCollectionViewDelegate
-(WLBaseCollectionViewLayerModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[WLBaseCollectionViewLayerModel alloc]init];
    }
    return _viewModel;
}

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.delegateTie = delegate;
    }
    return self;
}
- (instancetype)initWithDelegate:(id)delegate collection:(UICollectionView *)collection
{
    self = [super init];
    if (self) {
        self.collection = collection;
        
        self.collection.showsVerticalScrollIndicator = NO;
        self.collection.showsHorizontalScrollIndicator = NO;
        self.collection.delegate = self;
        self.collection.dataSource = self;
        self.collection.WLEmptyDataSetSource = self;
        self.collection.WLEmptyDataSetDelegate = self;
        //防止下移出现
        self.collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.delegate = delegate;
        self.delegateTie = delegate;
    }
    return self;
}
- (instancetype)initWithCollection:(UICollectionView *)collection{
    self = [super init];
    if (self) {
        self.collection = collection;
        //防止下移出现
        self.collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.collection.showsVerticalScrollIndicator = NO;
        self.collection.showsHorizontalScrollIndicator = NO;
        self.collection.delegate = self;
        self.collection.dataSource = self;
        self.collection.WLEmptyDataSetSource = self;
        self.collection.WLEmptyDataSetDelegate = self;
    }
    return self;
}
-(void)setDelegate:(id<WLCollectionDelegate>)delegate{
    _delegate = delegate;
}
-(void)setDelegateTie:(id)delegateTie{
    _delegateTie = delegateTie;
}
#pragma mark -CollectionView代理-
//返回4个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel viewLayer].count;
}
//每个section的数量由数据源的count值确定
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.viewModel viewLayer] objectAtIndex:section].item.count;
}
//创建 cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(wl_collectionView:layerModel:cellIndexPath:)]){
        return [self.delegate wl_collectionView:collectionView layerModel:self.viewModel cellIndexPath:indexPath];
    } else {
        WLBaseCollectionViewLayerRow *row = [self.viewModel getCellModel:indexPath];
        NSString *cellT = [NSString stringWithFormat:@"CollectView-%ld-%ld",indexPath.section,indexPath.row];
        NSLog(@"%@",cellT);
        UICollectionViewCell  *otherCell = nil;
        if (row.viewClass) {
            [collectionView registerClass:row.viewClass forCellWithReuseIdentifier:cellT];
            otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellT forIndexPath:indexPath];
            [otherCell wl_classMethod:@selector(bind_row_data:) object:row];
            [otherCell wl_classMethod:@selector(bind_delegate:) object:self.delegateTie];
        } else if (row.nibClass){
            [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(row.nibClass) bundle:nil] forCellWithReuseIdentifier:cellT];
            otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellT forIndexPath:indexPath];
            [otherCell wl_classMethod:@selector(bind_row_data:) object:row];
            [otherCell wl_classMethod:@selector(bind_delegate:) object:self.delegateTie];
        } else {
            [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:cellT];
            otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellT forIndexPath:indexPath];
        }
        return otherCell;
    }
}
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLBaseCollectionViewLayerSection *sectionData = [[self.viewModel viewLayer] objectAtIndex:indexPath.section];
    WLBaseCollectionViewLayerRow *rowData = [sectionData.item objectAtIndex:indexPath.row];
    return rowData.cellSize;
}
//section的边距(上，左，下，右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    WLBaseCollectionViewLayerSection *sectionData = [[self.viewModel viewLayer] objectAtIndex:section];
    return sectionData.insetForSection;
}
//section内，cell的间距 纵向
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    WLBaseCollectionViewLayerSection *sectionData = [[self.viewModel viewLayer] objectAtIndex:section];
    return sectionData.verticalSection;
}
//section内，cell的间距 水平
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    WLBaseCollectionViewLayerSection *sectionData = [[self.viewModel viewLayer] objectAtIndex:section];
    return sectionData.horizontalSection;
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [UICollectionReusableView new];
    WLBaseCollectionViewLayerSection *section = [self.viewModel.viewLayer objectAtIndex:indexPath.section];
    if([self.delegate respondsToSelector:
        @selector(wl_collectionView:viewForSupplementaryElementOfKind:layersectionModel:atIndexPath:)]){
        if (!section.headerItem){
            return reusableView;
        }
        if (!section.footItem){
            return reusableView;
        }
        reusableView = [self.delegate wl_collectionView:collectionView
                      viewForSupplementaryElementOfKind:kind
                                      layersectionModel:section
                                            atIndexPath:indexPath];
    } else {
        NSString *cellT = [NSString stringWithFormat:@"WDL%@-%ld-%ld",kind,indexPath.section,indexPath.row];
        
        WLBaseCollectionReusableModel *model = [kind isEqualToString:UICollectionElementKindSectionHeader]?section.headerItem:section.footItem;
        
        if (CGSizeEqualToSize(model.size, CGSizeZero)) {
            return reusableView;
        } else if (model.viewClass){
            [collectionView registerClass:model.viewClass forSupplementaryViewOfKind:kind withReuseIdentifier:cellT];
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellT forIndexPath:indexPath];
            [reusableView wl_classMethod:@selector(bind_row_data:) object:model];
            [reusableView wl_classMethod:@selector(bind_delegate:) object:self.delegateTie];
        } else if (model.nibClass){
            [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(model.nibClass) bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:cellT];
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellT forIndexPath:indexPath];
            [reusableView wl_classMethod:@selector(bind_row_data:) object:model];
            [reusableView wl_classMethod:@selector(bind_delegate:) object:self.delegateTie];
        }
    }
    return reusableView?reusableView:[UICollectionReusableView new];
}
//头视图大小
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    WLBaseCollectionReusableModel *model = [self.viewModel.viewLayer objectAtIndex:section].headerItem;
    return model.size;
}
//脚视图大小
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    WLBaseCollectionReusableModel *model = [self.viewModel.viewLayer objectAtIndex:section].footItem;
    return model.size;
}
//点击cell的响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(wl_collectionView:layerModel:didIndexPath:)]){
        [self.delegate wl_collectionView:collectionView
                              layerModel:self.viewModel
                            didIndexPath:indexPath];
    }
    if([self.delegate respondsToSelector:@selector(wl_collectionView:layerModel:layerRowData:didIndexPath:)]){
        [self.delegate wl_collectionView:collectionView
                              layerModel:self.viewModel
                            layerRowData:[self.viewModel getCellData:indexPath]
                            didIndexPath:indexPath];
    }
}

// 结束拖拽时触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([self.delegate respondsToSelector:@selector(wl_scrollViewDidEndDragging:willDecelerate:)]){
        [self.delegate wl_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
// 结束减速时触发（停止）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(wl_changeDragging:pageNumber:)]){
//        CGSize contentSize = scrollView.contentSize;
        CGPoint contentOffset = scrollView.contentOffset;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//            CGFloat beginSize = (contentSize.height - scrollView.frame.size.height);
            NSInteger number = contentOffset.y / scrollView.frame.size.height;
//            BOOL isLost = (contentOffset.y == beginSize);
            [self.delegate wl_changeDragging:scrollView pageNumber:number];
        } else {
//            CGFloat beginSize = (contentSize.width - scrollView.frame.size.width);
            NSInteger number = contentOffset.x / scrollView.frame.size.width;
//            BOOL isLost = (contentOffset.x == beginSize);
            [self.delegate wl_changeDragging:scrollView pageNumber:number];
        }
    }
}
// 滚动就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(wl_scrollViewDidScroll:)]){
        [self.delegate wl_scrollViewDidScroll:scrollView];
    }
}

#pragma mark -- WLEmptyDataSet
// 自定义显示视图
- (UIView *)customViewForWLEmptyDataSet:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(wl_customViewForWLEmptyDataSet)]){
        return [self.delegate wl_customViewForWLEmptyDataSet];
    }
    if (!self.isNotReload){
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [activityIndicator startAnimating];
        return activityIndicator;
    }
    if([self.delegate respondsToSelector:@selector(wl_clickReloadButton)]){
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"点击刷新" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(clickReloadButton) forControlEvents:UIControlEventTouchUpInside];
        return button;
    }
    return [UIView new];
}
- (void)clickReloadButton{
    if([self.delegate respondsToSelector:@selector(wl_clickReloadButton)]){
        [self.delegate wl_clickReloadButton];
    }
}
/** 强制显示空数据集：当项目数量大于0时，请求代理是否仍应显示空数据集。（默认值为NO） */
- (BOOL)WLEmptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(wl_emptyDataSetShouldBeForcedToDisplay)]){
        return [self.delegate wl_emptyDataSetShouldBeForcedToDisplay];
    }
    return NO;
}

@end
