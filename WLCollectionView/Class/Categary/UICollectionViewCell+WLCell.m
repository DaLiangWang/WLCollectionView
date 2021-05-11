//
//  UICollectionViewCell+WLCell.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "UICollectionViewCell+WLCell.h"

@implementation UICollectionViewCell (WLCell)
+(WLBaseCollectionViewLayerRow *)toClass:(Class)cls rowData:(id)data cellSize:(CGSize)size{
    WLBaseCollectionViewLayerRow *row = [[WLBaseCollectionViewLayerRow alloc] init];
    row.type = NSStringFromClass(cls);
    row.viewClass = cls;
    row.data = data;
    row.cellSize = size;
    return row;
}
@end
