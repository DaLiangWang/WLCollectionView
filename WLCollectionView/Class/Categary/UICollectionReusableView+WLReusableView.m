//
//  WLBaseCollectionReusableView+WLReusableView.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "UICollectionReusableView+WLReusableView.h"
#import "WLBaseCollectionReusableModel.h"

@implementation UICollectionReusableView (WLReusableView)
+(WLBaseCollectionReusableModel *)toClass:(Class)cls rowData:(id)data cellSize:(CGSize)size{
    WLBaseCollectionReusableModel *row = [[WLBaseCollectionReusableModel alloc] init];
    row.viewClass = cls;
    row.data = data;
    row.size = size;
    return row;
}
@end
