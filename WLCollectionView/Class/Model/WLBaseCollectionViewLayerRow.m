//
//  WLBaseCollectionViewLayerRow.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "WLBaseCollectionViewLayerRow.h"


@implementation WLBaseCollectionViewLayerRow
-(NSString *)keyId{
    if (!_keyId){
        if (self.viewClass){
            _keyId = NSStringFromClass(self.viewClass);
        } else if (self.nibClass){
            _keyId = NSStringFromClass(self.viewClass);
        } else {
            _keyId = @"cellName";
        }
    }
    return _keyId;
}
@end
