//
//  WLBaseCollectionViewLayerModel.m
//  xiacai_ios_v6
//
//  Created by shushui on 2018/4/18.
//  Copyright © 2018年 王振标. All rights reserved.
//

#import "WLBaseCollectionViewLayerModel.h"

@implementation WLBaseCollectionViewLayerModel
-(NSMutableArray<WLBaseCollectionViewLayerSection *> *)viewLayer{
    if (!_viewLayer){
        _viewLayer = [NSMutableArray array];
    }
    return _viewLayer;
}

-(id)getCellData:(NSIndexPath *)indexPath{
    return [[[self.viewLayer objectAtIndex:indexPath.section].item objectAtIndex:indexPath.row] data];
}
-(WLBaseCollectionViewLayerRow *)getCellModel:(NSIndexPath *)indexPath{
    return [[self.viewLayer objectAtIndex:indexPath.section].item objectAtIndex:indexPath.row];
}

-(WLBaseCollectionViewLayerSection *)getSectionModel:(NSIndexPath *)indexPath{
    return [self.viewLayer objectAtIndex:indexPath.section];
}
@end
