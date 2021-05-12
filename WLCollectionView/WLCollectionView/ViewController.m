//
//  ViewController.m
//  WLCollectionView
//
//  Created by MAC on 2021/5/11.
//

#import "ViewController.h"
#import "WLCollectionView.h"
#import "ItemCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "FootCollectionReusableView.h"

@interface ViewController ()
@property (nonatomic,strong) WLCollectionView *wlclass_collection_view;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wlclass_collection_view.frame = self.view.frame;
    
    [self.view addSubview:self.wlclass_collection_view];
    [self reload];
}
-(void)reload{
    
    NSMutableArray *array = [NSMutableArray array];
    
    while (array.count < 5) {
        WLBaseCollectionViewLayerSection *section = [[WLBaseCollectionViewLayerSection alloc]init];
        section.insetForSection = UIEdgeInsetsMake(1, 0, 1, 0);
        section.horizontalSection = 0;
        section.horizontalCount = 1;
        section.horizontalMaxWidth = self.view.frame.size.width;
        section.verticalSection = 1;
        
        CGSize itemSize = [section getCellSizeHeight:45];

        section.headerItem = [UICollectionReusableView toClass:HeaderCollectionReusableView.class rowData:@{
            @"title":[NSString stringWithFormat:@"headerItem-%ld",array.count]
        } cellSize:itemSize];
        
        section.footItem = [UICollectionReusableView toClass:FootCollectionReusableView.class rowData:@{
            @"title":[NSString stringWithFormat:@"footItem-%ld",array.count]
        } cellSize:itemSize];

        
        while (section.item.count < 5) {
            ItemCollectionViewCellModel *model = [[ItemCollectionViewCellModel alloc]init];
            model.string = [NSString stringWithFormat:@"item-%ld-%ld",array.count,section.item.count];
            
            WLBaseCollectionViewLayerRow *row = [UICollectionViewCell toClass:ItemCollectionViewCell.class rowData:model cellSize:itemSize];
            [section.item addObject:row];
        }
        
        [array addObject:section];
    }

    
    [self.wlclass_collection_view setAllSection:array];
}
#pragma mark -- 懒加载
-(WLCollectionView *)wlclass_collection_view{
    if (!_wlclass_collection_view){
        _wlclass_collection_view = [WLCollectionView initWithVerticalDelegate:self];
        _wlclass_collection_view.backgroundColor = UIColor.blueColor;
    }
    return _wlclass_collection_view;
}


@end
