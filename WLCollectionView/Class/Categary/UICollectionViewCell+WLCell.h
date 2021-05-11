//
//  UICollectionViewCell+WLCell.h
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import <UIKit/UIKit.h>
#import "WLBaseCollectionViewLayerModel.h"


@interface UICollectionViewCell (WLCell)
/** 生成对应的Cell 模型*/
+(WLBaseCollectionViewLayerRow *)toClass:(Class)cls rowData:(id)data cellSize:(CGSize)size;
@end
