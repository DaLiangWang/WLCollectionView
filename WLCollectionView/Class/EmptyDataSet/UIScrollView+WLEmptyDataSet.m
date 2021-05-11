//
//  UIScrollView+WLEmptyDataSet.m
//  WLEmptyDataSet
//
//  Created by Ignacio Romero Zurbuchen on 6/20/14.
//  Copyright (c) 2016 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIScrollView+WLEmptyDataSet.h"
#import <objc/runtime.h>

@interface UIView (DZNConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;

@end

@interface WLWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end

@interface WLEmptyDataSetView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


#pragma mark - UIScrollView+WLEmptyDataSet

static char const * const kWLEmptyDataSetSource =     "WLEmptyDataSetSource";
static char const * const kWLEmptyDataSetDelegate =   "WLEmptyDataSetDelegate";
static char const * const kWLEmptyDataSetView =       "WLEmptyDataSetView";

#define kEmptyImageViewAnimationKey @"com.dzn.WLEmptyDataSet.imageViewAnimation"

@interface UIScrollView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) WLEmptyDataSetView *WLEmptyDataSetView;
@end

@implementation UIScrollView (WLEmptyDataSet)

#pragma mark - Getters (Public)

- (id<WLEmptyDataSetSource>)WLEmptyDataSetSource
{
    WLWeakObjectContainer *container = objc_getAssociatedObject(self, kWLEmptyDataSetSource);
    return container.weakObject;
}

- (id<WLEmptyDataSetDelegate>)WLEmptyDataSetDelegate
{
    WLWeakObjectContainer *container = objc_getAssociatedObject(self, kWLEmptyDataSetDelegate);
    return container.weakObject;
}

- (BOOL)isWLEmptyDataSetVisible
{
    UIView *view = objc_getAssociatedObject(self, kWLEmptyDataSetView);
    return view ? !view.hidden : NO;
}


#pragma mark - Getters (Private)

- (WLEmptyDataSetView *)WLEmptyDataSetView
{
    WLEmptyDataSetView *view = objc_getAssociatedObject(self, kWLEmptyDataSetView);
    
    if (!view)
    {
        view = [WLEmptyDataSetView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dzn_didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setWLEmptyDataSetView:view];
    }
    return view;
}

- (BOOL)dzn_canDisplay
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource conformsToProtocol:@protocol(WLEmptyDataSetSource)]) {
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSInteger)dzn_itemsCount
{
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;

        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    
    return items;
}


#pragma mark - Data Source Getters

- (NSAttributedString *)dzn_titleLabelString
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(titleForWLEmptyDataSet:)]) {
        NSAttributedString *string = [self.WLEmptyDataSetSource titleForWLEmptyDataSet:self];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -titleForWLEmptyDataSet:");
        return string;
    }
    return nil;
}

- (NSAttributedString *)dzn_detailLabelString
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(descriptionForWLEmptyDataSet:)]) {
        NSAttributedString *string = [self.WLEmptyDataSetSource descriptionForWLEmptyDataSet:self];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -descriptionForWLEmptyDataSet:");
        return string;
    }
    return nil;
}

- (UIImage *)dzn_image
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(imageForWLEmptyDataSet:)]) {
        UIImage *image = [self.WLEmptyDataSetSource imageForWLEmptyDataSet:self];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -imageForWLEmptyDataSet:");
        return image;
    }
    return nil;
}

- (CAAnimation *)dzn_imageAnimation
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(imageAnimationForWLEmptyDataSet:)]) {
        CAAnimation *imageAnimation = [self.WLEmptyDataSetSource imageAnimationForWLEmptyDataSet:self];
        if (imageAnimation) NSAssert([imageAnimation isKindOfClass:[CAAnimation class]], @"You must return a valid CAAnimation object for -imageAnimationForWLEmptyDataSet:");
        return imageAnimation;
    }
    return nil;
}

- (UIColor *)dzn_imageTintColor
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(imageTintColorForWLEmptyDataSet:)]) {
        UIColor *color = [self.WLEmptyDataSetSource imageTintColorForWLEmptyDataSet:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -imageTintColorForWLEmptyDataSet:");
        return color;
    }
    return nil;
}

- (NSAttributedString *)dzn_buttonTitleForState:(UIControlState)state
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(buttonTitleForWLEmptyDataSet:forState:)]) {
        NSAttributedString *string = [self.WLEmptyDataSetSource buttonTitleForWLEmptyDataSet:self forState:state];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -buttonTitleForWLEmptyDataSet:forState:");
        return string;
    }
    return nil;
}

- (UIImage *)dzn_buttonImageForState:(UIControlState)state
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(buttonImageForWLEmptyDataSet:forState:)]) {
        UIImage *image = [self.WLEmptyDataSetSource buttonImageForWLEmptyDataSet:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonImageForWLEmptyDataSet:forState:");
        return image;
    }
    return nil;
}

- (UIImage *)dzn_buttonBackgroundImageForState:(UIControlState)state
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(buttonBackgroundImageForWLEmptyDataSet:forState:)]) {
        UIImage *image = [self.WLEmptyDataSetSource buttonBackgroundImageForWLEmptyDataSet:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonBackgroundImageForWLEmptyDataSet:forState:");
        return image;
    }
    return nil;
}

- (UIColor *)dzn_dataSetBackgroundColor
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(backgroundColorForWLEmptyDataSet:)]) {
        UIColor *color = [self.WLEmptyDataSetSource backgroundColorForWLEmptyDataSet:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -backgroundColorForWLEmptyDataSet:");
        return color;
    }
    return [UIColor clearColor];
}

- (UIView *)dzn_customView
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(customViewForWLEmptyDataSet:)]) {
        UIView *view = [self.WLEmptyDataSetSource customViewForWLEmptyDataSet:self];
        if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -customViewForWLEmptyDataSet:");
        return view;
    }
    return nil;
}

- (CGFloat)dzn_verticalOffset
{
    CGFloat offset = 0.0;
    
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(verticalOffsetForWLEmptyDataSet:)]) {
        offset = [self.WLEmptyDataSetSource verticalOffsetForWLEmptyDataSet:self];
    }
    return offset;
}

- (CGFloat)dzn_verticalSpace
{
    if (self.WLEmptyDataSetSource && [self.WLEmptyDataSetSource respondsToSelector:@selector(spaceHeightForWLEmptyDataSet:)]) {
        return [self.WLEmptyDataSetSource spaceHeightForWLEmptyDataSet:self];
    }
    return 0.0;
}

#pragma mark - Delegate Getters & Events (Private)

- (BOOL)dzn_shouldFadeIn {
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetShouldFadeIn:)]) {
        return [self.WLEmptyDataSetDelegate WLEmptyDataSetShouldFadeIn:self];
    }
    return YES;
}

- (BOOL)dzn_shouldDisplay
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetShouldDisplay:)]) {
        return [self.WLEmptyDataSetDelegate WLEmptyDataSetShouldDisplay:self];
    }
    return YES;
}

- (BOOL)dzn_shouldBeForcedToDisplay
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetShouldBeForcedToDisplay:)]) {
        return [self.WLEmptyDataSetDelegate WLEmptyDataSetShouldBeForcedToDisplay:self];
    }
    return NO;
}

- (BOOL)dzn_isTouchAllowed
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetShouldAllowTouch:)]) {
        return [self.WLEmptyDataSetDelegate WLEmptyDataSetShouldAllowTouch:self];
    }
    return YES;
}

- (BOOL)dzn_isScrollAllowed
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetShouldAllowScroll:)]) {
        return [self.WLEmptyDataSetDelegate WLEmptyDataSetShouldAllowScroll:self];
    }
    return NO;
}

- (BOOL)dzn_isImageViewAnimateAllowed
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetShouldAnimateImageView:)]) {
        return [self.WLEmptyDataSetDelegate WLEmptyDataSetShouldAnimateImageView:self];
    }
    return NO;
}

- (void)dzn_willAppear
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetWillAppear:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSetWillAppear:self];
    }
}

- (void)dzn_didAppear
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetDidAppear:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSetDidAppear:self];
    }
}

- (void)dzn_willDisappear
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetWillDisappear:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSetWillDisappear:self];
    }
}

- (void)dzn_didDisappear
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetDidDisappear:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSetDidDisappear:self];
    }
}

- (void)dzn_didTapContentView:(id)sender
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSet:didTapView:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSet:self didTapView:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetDidTapView:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSetDidTapView:self];
    }
#pragma clang diagnostic pop
}

- (void)dzn_didTapDataButton:(id)sender
{
    if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSet:didTapButton:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSet:self didTapButton:sender];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (self.WLEmptyDataSetDelegate && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(WLEmptyDataSetDidTapButton:)]) {
        [self.WLEmptyDataSetDelegate WLEmptyDataSetDidTapButton:self];
    }
#pragma clang diagnostic pop
}


#pragma mark - Setters (Public)

- (void)setWLEmptyDataSetSource:(id<WLEmptyDataSetSource>)datasource
{
    if (!datasource || ![self dzn_canDisplay]) {
        [self dzn_invalidate];
    }
    
    objc_setAssociatedObject(self, kWLEmptyDataSetSource, [[WLWeakObjectContainer alloc] initWithWeakObject:datasource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // We add method sizzling for injecting -dzn_reloadData implementation to the native -reloadData implementation
    [self swizzleIfPossible:@selector(reloadData)];
    
    // Exclusively for UITableView, we also inject -dzn_reloadData to -endUpdates
    if ([self isKindOfClass:[UITableView class]]) {
        [self swizzleIfPossible:@selector(endUpdates)];
    }
}

- (void)setWLEmptyDataSetDelegate:(id<WLEmptyDataSetDelegate>)delegate
{
    if (!delegate) {
        [self dzn_invalidate];
    }
    
    objc_setAssociatedObject(self, kWLEmptyDataSetDelegate, [[WLWeakObjectContainer alloc] initWithWeakObject:delegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Setters (Private)

- (void)setWLEmptyDataSetView:(WLEmptyDataSetView *)view
{
    objc_setAssociatedObject(self, kWLEmptyDataSetView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Reload APIs (Public)

- (void)reloadWLEmptyDataSet
{
    [self dzn_reloadWLEmptyDataSet];
}


#pragma mark - Reload APIs (Private)

- (void)dzn_reloadWLEmptyDataSet
{
    if (![self dzn_canDisplay]) {
        return;
    }
    
    if (([self dzn_shouldDisplay] && [self dzn_itemsCount] == 0) || [self dzn_shouldBeForcedToDisplay])
    {
        // Notifies that the empty dataset view will appear
        [self dzn_willAppear];
        
        WLEmptyDataSetView *view = self.WLEmptyDataSetView;
        
        // Configure empty dataset fade in display
        view.fadeInOnDisplay = [self dzn_shouldFadeIn];
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }
            else {
                [self addSubview:view];
            }
        }
        
        // Removing view resetting the view and its constraints it very important to guarantee a good state
        [view prepareForReuse];
        
        UIView *customView = [self dzn_customView];
        
        // If a non-nil custom view is available, let's configure it instead
        if (customView) {
            view.customView = customView;
        }
        else {
            // Get the data from the data source
            NSAttributedString *titleLabelString = [self dzn_titleLabelString];
            NSAttributedString *detailLabelString = [self dzn_detailLabelString];
            
            UIImage *buttonImage = [self dzn_buttonImageForState:UIControlStateNormal];
            NSAttributedString *buttonTitle = [self dzn_buttonTitleForState:UIControlStateNormal];
            
            UIImage *image = [self dzn_image];
            UIColor *imageTintColor = [self dzn_imageTintColor];
            UIImageRenderingMode renderingMode = imageTintColor ? UIImageRenderingModeAlwaysTemplate : UIImageRenderingModeAlwaysOriginal;
            
            view.verticalSpace = [self dzn_verticalSpace];
            
            // Configure Image
            if (image) {
                if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
                    view.imageView.image = [image imageWithRenderingMode:renderingMode];
                    view.imageView.tintColor = imageTintColor;
                }
                else {
                    // iOS 6 fallback: insert code to convert imaged if needed
                    view.imageView.image = image;
                }
            }
            
            // Configure title label
            if (titleLabelString) {
                view.titleLabel.attributedText = titleLabelString;
            }
            
            // Configure detail label
            if (detailLabelString) {
                view.detailLabel.attributedText = detailLabelString;
            }
            
            // Configure button
            if (buttonImage) {
                [view.button setImage:buttonImage forState:UIControlStateNormal];
                [view.button setImage:[self dzn_buttonImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
            else if (buttonTitle) {
                [view.button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
                [view.button setAttributedTitle:[self dzn_buttonTitleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
                [view.button setBackgroundImage:[self dzn_buttonBackgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
                [view.button setBackgroundImage:[self dzn_buttonBackgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
        }
        
        // Configure offset
        view.verticalOffset = [self dzn_verticalOffset];
        
        // Configure the empty dataset view
        view.backgroundColor = [self dzn_dataSetBackgroundColor];
        view.hidden = NO;
        view.clipsToBounds = YES;
        
        // Configure empty dataset userInteraction permission
        view.userInteractionEnabled = [self dzn_isTouchAllowed];
        
        [view setupConstraints];
        
        [UIView performWithoutAnimation:^{
            [view layoutIfNeeded];
        }];
        
        // Configure scroll permission
        self.scrollEnabled = [self dzn_isScrollAllowed];
        
        // Configure image view animation
        if ([self dzn_isImageViewAnimateAllowed])
        {
            CAAnimation *animation = [self dzn_imageAnimation];
            
            if (animation) {
                [self.WLEmptyDataSetView.imageView.layer addAnimation:animation forKey:kEmptyImageViewAnimationKey];
            }
        }
        else if ([self.WLEmptyDataSetView.imageView.layer animationForKey:kEmptyImageViewAnimationKey]) {
            [self.WLEmptyDataSetView.imageView.layer removeAnimationForKey:kEmptyImageViewAnimationKey];
        }
        
        // Notifies that the empty dataset view did appear
        [self dzn_didAppear];
    }
    else if (self.isWLEmptyDataSetVisible) {
        [self dzn_invalidate];
    }
}

- (void)dzn_invalidate
{
    // Notifies that the empty dataset view will disappear
    [self dzn_willDisappear];
    
    if (self.WLEmptyDataSetView) {
        [self.WLEmptyDataSetView prepareForReuse];
        [self.WLEmptyDataSetView removeFromSuperview];
        
        [self setWLEmptyDataSetView:nil];
    }
    
    self.scrollEnabled = YES;
    
    // Notifies that the empty dataset view did disappear
    [self dzn_didDisappear];
}


#pragma mark - Method Swizzling

static NSMutableDictionary *_impLookupTable;
static NSString *const DZNSwizzleInfoPointerKey = @"pointer";
static NSString *const DZNSwizzleInfoOwnerKey = @"owner";
static NSString *const DZNSwizzleInfoSelectorKey = @"selector";

// Based on Bryce Buchanan's swizzling technique http://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
// And Juzzin's ideas https://github.com/juzzin/JUSEmptyViewController

void dzn_original_implementation(id self, SEL _cmd)
{
    // Fetch original implementation from lookup table
    Class baseClass = dzn_baseClassToSwizzleForTarget(self);
    NSString *key = dzn_implementationKey(baseClass, _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:DZNSwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for reloading the empty dataset
    // Doing it before calling the original implementation does update the 'isWLEmptyDataSetVisible' flag on time.
    [self dzn_reloadWLEmptyDataSet];
    
    // If found, call original implementation
    if (impPointer) {
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}

NSString *dzn_implementationKey(Class class, SEL selector)
{
    if (!class || !selector) {
        return nil;
    }
    
    NSString *className = NSStringFromClass([class class]);
    
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}

Class dzn_baseClassToSwizzleForTarget(id target)
{
    if ([target isKindOfClass:[UITableView class]]) {
        return [UITableView class];
    }
    else if ([target isKindOfClass:[UICollectionView class]]) {
        return [UICollectionView class];
    }
    else if ([target isKindOfClass:[UIScrollView class]]) {
        return [UIScrollView class];
    }
    
    return nil;
}

- (void)swizzleIfPossible:(SEL)selector
{
    // Check if the target responds to selector
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // Create the lookup table
    if (!_impLookupTable) {
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:3]; // 3 represent the supported base classes
    }
    
    // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
    for (NSDictionary *info in [_impLookupTable allValues]) {
        Class class = [info objectForKey:DZNSwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:DZNSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    Class baseClass = dzn_baseClassToSwizzleForTarget(self);
    NSString *key = dzn_implementationKey(baseClass, selector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:DZNSwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue || !key || !baseClass) {
        return;
    }
    
    // Swizzle by injecting additional implementation
    Method method = class_getInstanceMethod(baseClass, selector);
    IMP dzn_newImplementation = method_setImplementation(method, (IMP)dzn_original_implementation);
    
    // Store the new implementation in the lookup table
    NSDictionary *swizzledInfo = @{DZNSwizzleInfoOwnerKey: baseClass,
                                   DZNSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   DZNSwizzleInfoPointerKey: [NSValue valueWithPointer:dzn_newImplementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.WLEmptyDataSetView]) {
        return [self dzn_isTouchAllowed];
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIGestureRecognizer *tapGesture = self.WLEmptyDataSetView.tapGesture;
    
    if ([gestureRecognizer isEqual:tapGesture] || [otherGestureRecognizer isEqual:tapGesture]) {
        return YES;
    }
    
    // defer to WLEmptyDataSetDelegate's implementation if available
    if ( (self.WLEmptyDataSetDelegate != (id)self) && [self.WLEmptyDataSetDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [(id)self.WLEmptyDataSetDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    return NO;
}

@end


#pragma mark - WLEmptyDataSetView

@interface WLEmptyDataSetView ()
@end

@implementation WLEmptyDataSetView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

#pragma mark - Initialization Methods

- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    CGRect superviewBounds = self.superview.bounds;
    self.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(superviewBounds), CGRectGetHeight(superviewBounds));
    
    void(^fadeInBlock)(void) = ^{
        self->_contentView.alpha = 1.0;
    };
    
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }
    else {
        fadeInBlock();
    }
}


#pragma mark - Getters

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set background image";
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"empty set detail label";
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.clipsToBounds = YES;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"empty set button";
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowImage
{
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle
{
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail
{
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton
{
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}


#pragma mark - Setters

- (void)setCustomView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"dzn_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

- (void)prepareForReuse
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    
    [self removeAllConstraints];
}


#pragma mark - Auto-Layout Configuration

- (void)setupConstraints
{
    // First, configure the content view constaints
    // The content view must alway be centered to its superview
   
    // If applicable, set the custom view's constraints
    if (_customView) {
        NSLayoutConstraint *centerTConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeTop];
        NSLayoutConstraint *centerBConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeBottom];
        NSLayoutConstraint *centerLConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeLeft];
        NSLayoutConstraint *centerRConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeRight];
        
        [self addConstraint:centerTConstraint];
        [self addConstraint:centerBConstraint];
        [self addConstraint:centerLConstraint];
        [self addConstraint:centerRConstraint];
        
        
        NSLayoutConstraint *customTConstraint = [self.contentView equallyRelatedConstraintWithView:_customView attribute:NSLayoutAttributeTop];
        NSLayoutConstraint *customBConstraint = [self.contentView equallyRelatedConstraintWithView:_customView attribute:NSLayoutAttributeBottom];
        NSLayoutConstraint *customLConstraint = [self.contentView equallyRelatedConstraintWithView:_customView attribute:NSLayoutAttributeLeft];
        NSLayoutConstraint *customRConstraint = [self.contentView equallyRelatedConstraintWithView:_customView attribute:NSLayoutAttributeRight];
        
        [self.contentView addConstraint:customTConstraint];
        [self.contentView addConstraint:customBConstraint];
        [self.contentView addConstraint:customLConstraint];
        [self.contentView addConstraint:customRConstraint];
    }
    else {
        
        NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
        NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];
        
        [self addConstraint:centerXConstraint];
        [self addConstraint:centerYConstraint];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
        
        // When a custom offset is available, we adjust the vertical constraints' constants
        if (self.verticalOffset != 0 && self.constraints.count > 0) {
            centerYConstraint.constant = self.verticalOffset;
        }
        
        CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width/16.0);
        CGFloat verticalSpace = self.verticalSpace ? : 11.0; // Default is 11 pts
        
        NSMutableArray *subviewStrings = [NSMutableArray array];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        NSDictionary *metrics = @{@"padding": @(padding)};
        
        // Assign the image view's horizontal constraints
        if (_imageView.superview) {
            
            [subviewStrings addObject:@"imageView"];
            views[[subviewStrings lastObject]] = _imageView;
            
            [self.contentView addConstraint:[self.contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }
        
        // Assign the title label's horizontal constraints
        if ([self canShowTitle]) {
            
            [subviewStrings addObject:@"titleLabel"];
            views[[subviewStrings lastObject]] = _titleLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        // Assign the detail label's horizontal constraints
        if ([self canShowDetail]) {
            
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        // Assign the button's horizontal constraints
        if ([self canShowButton]) {
            
            [subviewStrings addObject:@"button"];
            views[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(100)-[button(>=0)]-(100)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }
        // or removes from its superview
        else {
            [_button removeFromSuperview];
            _button = nil;
        }
        
        
        NSMutableString *verticalFormat = [NSMutableString new];
        
        // Build a dynamic string format for the vertical constraints, adding a margin between each element. Default is 11 pts.
        for (int i = 0; i < subviewStrings.count; i++) {
            
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
            }
        }
        
        // Assign the vertical constraints to the content view
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0 metrics:metrics views:views]];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // Return any UIControl instance such as buttons, segmented controls, switches, etc.
    if ([hitView isKindOfClass:[UIControl class]]) {
        return hitView;
    }
    
    // Return either the contentView or customView
    if ([hitView isEqual:_contentView] || [hitView isEqual:_customView]) {
        return hitView;
    }
    
    return nil;
}
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    self.button.layer.cornerRadius = self.button.frame.size.height/2.f;
}

@end


#pragma mark - UIView+DZNConstraintBasedLayoutExtensions

@implementation UIView (DZNConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end

#pragma mark - WLWeakObjectContainer

@implementation WLWeakObjectContainer

- (instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end
