//
//  WLBaseCollectionReusableView+WLReusableView.h
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import <UIKit/UIKit.h>
#import "WLBaseCollectionReusableModel.h"

@interface UICollectionReusableView (WLReusableView)
+(WLBaseCollectionReusableModel *)toClass:(Class)cls rowData:(id)data cellSize:(CGSize)size;
@end
