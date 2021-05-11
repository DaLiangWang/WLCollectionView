//
//  WLBaseCollectionViewLayerRow.h
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WLBaseCollectionViewLayerRow : NSObject
/** row 单个cell 的标签 区分cell用途 */
@property (nonatomic,strong) id type;
/** row 当前坐标 */
@property (nonatomic,strong) NSIndexPath *indexPath;
/** row 单个cell 的 Key */
@property(nonatomic,strong) NSString *keyId;
/** 默认的cell的Class */
@property (readwrite) Class viewClass;
/** 默认的cell的Nic创建的Class */
@property (readwrite) Class nibClass;
/** row 单个cell 大小 */
@property (nonatomic,assign) CGSize cellSize;
/** 单个cell 的数据 */
@property (nonatomic,strong) id data;
/** 单个cell 额外 数据 */
@property (nonatomic,strong) id otherData;
@end
