//
//  HeaderCollectionReusableView.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "HeaderCollectionReusableView.h"
#import "WLBaseCollectionReusableModel.h"
@interface HeaderCollectionReusableView()
@property (strong,nonatomic) UILabel *title_label;
@end

@implementation HeaderCollectionReusableView
/** 绑定数据 */
-(void)bind_row_data:(WLBaseCollectionReusableModel *)sender{
    if ([sender.data isKindOfClass:NSDictionary.class]){
        NSDictionary *model = sender.data;
        self.title_label.text = model[@"title"];
    }
}
/** 绑定代理 */
-(void)bind_delegate:(id)sender{
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        self.title_label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        self.title_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title_label];
    }
    return self;
}
@end
