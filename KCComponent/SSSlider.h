//
//  SSSlider.h
//  TTReading
//
//  Created by zhangweiwei on 2019/3/19.
//  Copyright © 2019 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SSSliderDirectionHorizantial,
    SSSliderDirectionVertical

} SSSliderDirection;

NS_ASSUME_NONNULL_BEGIN

@class SSSlider;
@protocol SSSliderDelegate <NSObject>

@optional
- (void)slider:(SSSlider *)view valueDidChanged:(float)value;
- (void)slider:(SSSlider *)view didAutoAdjustValue:(float)value;

- (void)sliderWillBeginDraging:(SSSlider *)view;
- (void)sliderDidEndDraging:(SSSlider *)view;

- (void)sliderDidTap:(SSSlider *)view;

@end

@interface SSSlider : UIView

@property (nonatomic, strong) UIImageView * sliderView;
@property (nonatomic, weak) id<SSSliderDelegate>  delegate;

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat shadowRadius;

@property (nonatomic, assign) NSInteger segmentCount;
@property (nonatomic, assign) SSSliderDirection direction;

@property (nonatomic, assign) BOOL autoAdjustWhenEndDragging;
@property (nonatomic, assign, readonly) BOOL isTracking;


@property (nonatomic, assign) BOOL tapDisabled;

@property (nonatomic, assign) BOOL autoHideSlider;

- (instancetype)initWithDirection:(SSSliderDirection)direction;

- (void)setThumbImage:(UIImage *)image;
- (void)setTrackColor:(UIColor *)tc;
- (void)setProgressColor:(UIColor *)pc;

// 手动触发布局
- (void)setupLayout;

@end

NS_ASSUME_NONNULL_END
