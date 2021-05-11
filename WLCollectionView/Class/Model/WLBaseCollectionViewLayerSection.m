//
//  WLBaseCollectionViewLayerSection.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "WLBaseCollectionViewLayerSection.h"

@implementation WLBaseCollectionViewLayerSection
-(NSMutableArray<WLBaseCollectionViewLayerRow *> *)item{
    if (!_item){
        _item = [NSMutableArray array];
    }
    return _item;
}
-(CGFloat)getCellWidth{
    NSInteger count = self.horizontalCount;
    CGFloat maxWidth = self.horizontalMaxWidth ? self.horizontalMaxWidth : [[UIScreen mainScreen] bounds].size.width;
    CGFloat w = (maxWidth - self.insetForSection.left - self.insetForSection.right - (self.verticalSection * (count - 1)))/count;
    return w;
}
-(CGSize)getCellSizeHeight:(CGFloat)height{
    CGFloat w = [self getCellWidth];
    CGFloat h = height;
    return CGSizeMake(w, h);
}

@end
