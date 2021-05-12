//
//  ItemCollectionViewCell.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "ItemCollectionViewCell.h"
#import "WLBaseCollectionViewLayerRow.h"

@interface ItemCollectionViewCell()
@property (strong,nonatomic) UILabel *title_label;
@end

@implementation ItemCollectionViewCell
/** 绑定数据 */
-(void)bind_row_data:(WLBaseCollectionViewLayerRow *)sender{
    if ([sender.data isKindOfClass:ItemCollectionViewCellModel.class]){
        ItemCollectionViewCellModel *model = sender.data;
//        NSLog(@"%@", model.string);
        self.title_label.text = model.string;
    }
}
/** 绑定代理 */
-(void)bind_delegate:(id)sender{
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.orangeColor;
        self.title_label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        self.title_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title_label];
    }
    return self;
}

@end


@implementation ItemCollectionViewCellModel

@end
