//
//  UIScrollView+WLEmptyDataSet.h
//  WLEmptyDataSet
//  https://github.com/dzenbot/WLEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2016 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WLEmptyDataSetSource;
@protocol WLEmptyDataSetDelegate;

#define WLEmptyDataSetDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

/**
 A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display.
 @discussion It will work automatically, by just conforming to WLEmptyDataSetSource, and returning the data you want to show.
 */
@interface UIScrollView (WLEmptyDataSet)

/** The empty datasets data source. */
@property (nonatomic, weak, nullable) IBOutlet id <WLEmptyDataSetSource> WLEmptyDataSetSource;
/** The empty datasets delegate. */
@property (nonatomic, weak, nullable) IBOutlet id <WLEmptyDataSetDelegate> WLEmptyDataSetDelegate;
/** YES if any empty dataset is visible. */
@property (nonatomic, readonly, getter = isWLEmptyDataSetVisible) BOOL WLEmptyDataSetVisible;

/**
 Reloads the empty dataset content receiver.
 @discussion Call this method to force all the data to refresh. Calling -reloadData is similar, but this forces only the empty dataset to reload, not the entire table view or collection view.
 */
- (void)reloadWLEmptyDataSet;

@end


/**
 The object that acts as the data source of the empty datasets.
 @discussion The data source must adopt the WLEmptyDataSetSource protocol. The data source is not retained. All data source methods are optional.
 */
@protocol WLEmptyDataSetSource <NSObject>
@optional

/**
 Asks the data source for the title of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset title, combining font, text color, text pararaph style, etc.
 */
- (nullable NSAttributedString *)titleForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 Asks the data source for the description of the dataset.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass informing the data source.
 @return An attributed string for the dataset description text, combining font, text color, text pararaph style, etc.
 */
- (nullable NSAttributedString *)descriptionForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 ?????????????????????
 
 @param scrollView A scrollView subclass informing the data source.
 @return An image for the dataset.
 */
- (nullable UIImage *)imageForWLEmptyDataSet:(UIScrollView *)scrollView;


/**
 ??????????????? tintColor
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to tint the image of the dataset.
 */
- (nullable UIColor *)imageTintColorForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 *  ??????????????????
 *
 *  @param scrollView A scrollView subclass object informing the delegate.
 *
 *  @return image animation
 */
- (nullable CAAnimation *)imageAnimationForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 ?????????????????????
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (nullable NSAttributedString *)buttonTitleForWLEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 ?????????????????????????????????
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An image for the dataset button imageview.
 */
- (nullable UIImage *)buttonImageForWLEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 ???????????????????????????
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (nullable UIImage *)buttonBackgroundImageForWLEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 ??????????????????????????????
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color to be applied to the dataset background view.
 */
- (nullable UIColor *)backgroundColorForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 ?????????????????????????????????????????????????????????????????????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The custom view.
 */
- (nullable UIView *)customViewForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 ?????????????????????????????????????????????????????????????????????????????????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The offset for vertical and horizontal alignment.
 */
- (CGPoint)offsetForWLEmptyDataSet:(UIScrollView *)scrollView WLEmptyDataSetDeprecated(-verticalOffsetForWLEmptyDataSet:);
- (CGFloat)verticalOffsetForWLEmptyDataSet:(UIScrollView *)scrollView;

/**
 ??????????????????????????????????????????????????????11????????????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The space height between elements.
 */
- (CGFloat)spaceHeightForWLEmptyDataSet:(UIScrollView *)scrollView;

@end


/**
 The object that acts as the delegate of the empty datasets.
 @discussion The delegate can adopt the WLEmptyDataSetDelegate protocol. The delegate is not retained. All delegate methods are optional.
 
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol WLEmptyDataSetDelegate <NSObject>
@optional

/**
 ????????????????????????????????????????????????????????? (????????????YES)
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should fade in.
 */
- (BOOL)WLEmptyDataSetShouldFadeIn:(UIScrollView *)scrollView;

/**
 ????????????????????????????????????????????????0??????????????????????????????????????????????????????????????????NO???
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if empty dataset should be forced to display
 */
- (BOOL)WLEmptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView;

/**
 ?????????????????????????????????????????????????????????YES??????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset should show.
 */
- (BOOL)WLEmptyDataSetShouldDisplay:(UIScrollView *)scrollView;

/**
 ????????????????????????????????????YES??????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset receives touch gestures.
 */
- (BOOL)WLEmptyDataSetShouldAllowTouch:(UIScrollView *)scrollView;

/**
 ???????????????????????????????????????NO??????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to be scrollable.
 */
- (BOOL)WLEmptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;

/**
 ?????????????????????????????????????????????NO??????
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the empty dataset is allowed to animate
 */
- (BOOL)WLEmptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)WLEmptyDataSetDidTapView:(UIScrollView *)scrollView WLEmptyDataSetDeprecated(-WLEmptyDataSet:didTapView:);

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)WLEmptyDataSetDidTapButton:(UIScrollView *)scrollView WLEmptyDataSetDeprecated(-WLEmptyDataSet:didTapButton:);

/**
 Tells the delegate that the empty dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param view the view tapped by the user
 */
- (void)WLEmptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)WLEmptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/**
 Tells the delegate that the empty data set will appear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)WLEmptyDataSetWillAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set did appear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)WLEmptyDataSetDidAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set will disappear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)WLEmptyDataSetWillDisappear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the empty data set did disappear.

 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)WLEmptyDataSetDidDisappear:(UIScrollView *)scrollView;

@end

#undef WLEmptyDataSetDeprecated

NS_ASSUME_NONNULL_END
