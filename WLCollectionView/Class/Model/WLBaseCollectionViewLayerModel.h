//
//  WLBaseCollectionViewLayerModel.h
//  xiacai_ios_v6
//
//  Created by shushui on 2018/4/18.
//  Copyright © 2018年 王振标. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLBaseCollectionViewLayerSection.h"

@class WLBaseCollectionViewLayerSection,WLBaseCollectionViewLayerRow;
@interface WLBaseCollectionViewLayerModel : NSObject
/** section数量 */
@property(nonatomic,strong) NSMutableArray<WLBaseCollectionViewLayerSection *> *viewLayer;

-(id)getCellData:(NSIndexPath *)indexPath;
-(WLBaseCollectionViewLayerRow *)getCellModel:(NSIndexPath *)indexPath;
-(WLBaseCollectionViewLayerSection *)getSectionModel:(NSIndexPath *)indexPath;
@end

