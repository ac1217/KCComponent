//
//  SSSlider.m
//  TTReading
//
//  Created by zhangweiwei on 2019/3/19.
//  Copyright © 2019 ByteDance. All rights reserved.
//

#import "SSSlider.h"
#import "UIImage+Rotation.h"
#import "UIViewAdditions.h"
#import "NSTimer+KCExtension.h"
//#import "SSCommonMacro.h"

@interface SSSlider() {
    BOOL _tracking;
}


@property (nonatomic, weak)  UIPanGestureRecognizer * panGes;

@property (nonatomic, strong)  UIImageView * trackView;
@property (nonatomic, strong)  UIImageView * progressView;

@property (nonatomic, strong)  NSMutableArray * segmentViews;


@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SSSlider

- (instancetype)initWithDirection:(SSSliderDirection)direction
{
    if (self = [super init]) {

        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}


- (void)setup
{

    self.lineWidth = 3;
    self.minValue = 0;
    self.maxValue = 1;
    self.segmentViews = @[].mutableCopy;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderValueChange:)];

    [self addGestureRecognizer:pan];

    [self addSubview:self.trackView];
    [self addSubview:self.progressView];

    [self addSubview:self.sliderView];

    [self setupLayout];

}

- (void)setSegmentCount:(NSInteger)segmentCount
{
    _segmentCount = segmentCount;

    [self.segmentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.segmentViews removeAllObjects];


    NSInteger count = segmentCount + 1;

    for (int i = 0; i < count; i++) {
        UIView *tview = [UIView new];
        [self insertSubview:tview belowSubview:self.progressView];

        [self.segmentViews addObject:tview];

    }

}

- (void)setupLayout
{


    CGPoint sliderViewCenter = self.sliderView.center;
    switch (self.direction) {
        case SSSliderDirectionHorizantial: {

            float progress = (_value - self.minValue) / (self.maxValue - self.minValue);

            CGFloat lineW = progress * self.bounds.size.width;
            CGFloat lineH = self.lineWidth;

            CGFloat lineX = 0;
            CGFloat lineY = (self.bounds.size.height - lineH) * 0.5;

            self.trackView.frame = CGRectMake(lineX, lineY, self.bounds.size.width , lineH);

            self.progressView.frame = CGRectMake(lineX, lineY, lineW, lineH);

            sliderViewCenter.x = lineW;
            sliderViewCenter.y = self.trackView.center.y;

            if (self.segmentCount) {

                CGFloat segW = 2;
                CGFloat segH = 5;
                CGFloat startX = self.trackView.frame.origin.x;

                CGFloat preW = self.trackView.frame.size.width / self.segmentCount;

                for (int i = 0; i < self.segmentViews.count; i++) {

                    UIView *tv = self.segmentViews[i];
                    tv.layer.cornerRadius = segW * 0.5;
                    tv.clipsToBounds = YES;
                    CGRect tvFrame = tv.frame;
                    tvFrame.size = CGSizeMake(segW, segH);
                    tv.frame = tvFrame;

                    tv.center = CGPointMake(preW * i + startX, self.trackView.center.y);

                    if (tv.center.x <= self.progressView.frame.size.width) {

                        tv.backgroundColor = self.progressView.backgroundColor;
                    }else {

                        tv.backgroundColor = self.trackView.backgroundColor;
                    }

                }


            }


        }

            break;
        case SSSliderDirectionVertical: {

            float progress = (_value - self.minValue) / (self.maxValue - self.minValue);

            CGFloat lineH = progress * self.bounds.size.height;
            CGFloat lineW = self.lineWidth;

            CGFloat lineY = 0;
            CGFloat lineX = (self.bounds.size.width - lineW) * 0.5;

            self.trackView.frame = CGRectMake(lineX, lineY, lineW , self.bounds.size.height);

            self.progressView.frame = CGRectMake(lineX, lineY, lineW, lineH);

            sliderViewCenter.y = lineH;
            sliderViewCenter.x = self.trackView.center.x;

            if (self.segmentCount) {

                CGFloat segW = 5;
                CGFloat segH = 2;
                CGFloat startY = self.trackView.frame.origin.y;

                CGFloat preH = self.trackView.frame.size.height / self.segmentCount;

                for (int i = 0; i < self.segmentViews.count; i++) {

                    UIView *tv = self.segmentViews[i];
                    tv.layer.cornerRadius = segH * 0.5;
                    tv.clipsToBounds = YES;
                    CGRect tvFrame = tv.frame;
                    tvFrame.size = CGSizeMake(segW, segH);
                    tv.frame = tvFrame;

                    tv.center = CGPointMake(preH * i + startY, self.trackView.center.y);

                    if (tv.center.y <= self.progressView.frame.size.height) {

                        tv.backgroundColor = self.progressView.backgroundColor;
                    }else {

                        tv.backgroundColor = self.trackView.backgroundColor;
                    }

                }


            }

        }

            break;

        default:
            break;
    }

    self.sliderView.center = sliderViewCenter;

    self.trackView.layer.cornerRadius = self.lineWidth * 0.5;
    self.progressView.layer.cornerRadius = self.lineWidth * 0.5;

}

#pragma mark -Timer
- (void)addTimer
{
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer kc_timerWithTimeInterval:2 block:^(NSTimer *timer) {

        if (!weakSelf.isTracking) {

            [weakSelf hideSlider];

        }

        [weakSelf removeTimer];

    } repeats:NO];


    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)hideSlider
{
    if (!self.sliderView.alpha) {
        return;
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

        switch (self.direction) {
            case SSSliderDirectionVertical:
            {

                self.sliderView.transform = CGAffineTransformMakeTranslation(self.sliderView.frame.size.width, 0);
            }
                break;
            case SSSliderDirectionHorizantial:
            {

                self.sliderView.transform = CGAffineTransformMakeTranslation(0, self.sliderView.frame.size.height);
            }
                break;

            default:
                break;
        }
        self.sliderView.alpha = 0;

    } completion:^(BOOL finished) {

    }];
}

- (void)showSlider
{
    if (self.sliderView.alpha) {
        return;
    }

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.sliderView.transform = CGAffineTransformIdentity;
        self.sliderView.alpha = 1;

    } completion:^(BOOL finished) {

    }];
}

#pragma mark - Setter

- (void)setAutoHideSlider:(BOOL)autoHideSlider
{
    _autoHideSlider = autoHideSlider;

    [self removeTimer];
    if (autoHideSlider) {
        [self addTimer];
    }
}

- (void)setMinValue:(float)minValue
{
    _minValue = minValue;

    if (_value < minValue) {
        _value = minValue;
    }
}

- (void)setMaxValue:(float)maxValue
{
    _maxValue = maxValue;

    if (_value > maxValue) {
        _value = maxValue;
    }
}


- (void)setTrackColor:(UIColor *)tc
{
    self.trackView.backgroundColor = tc;
}

- (void)setProgressColor:(UIColor *)pc
{
    self.progressView.backgroundColor = pc;
}

- (void)setValue:(float)value
{
    if (self.isTracking || isnan(value)) {
        return;
    }

    if (value <= self.minValue) {
        value = self.minValue;
    }

    if (value >= self.maxValue) {
        value = self.maxValue;
    }


    _value = value;

    [self setupLayout];

    [self showSlider];
    [self removeTimer];
    if (self.autoHideSlider) {
        [self addTimer];
    }
}

- (void)setThumbImage:(UIImage *)image
{
    self.sliderView.image = image;
    [self.sliderView sizeToFit];
    [self setupLayout];
}

#pragma mark - Action

- (void)tap:(UITapGestureRecognizer *)tap
{

    if (self.tapDisabled) {
        return;
    }

    CGPoint location = [tap locationInView:tap.view];

    switch (self.direction) {
        case SSSliderDirectionHorizantial: {

            CGFloat x = location.x;
            if (x <= self.trackView.frame.origin.x) {
                x = self.trackView.frame.origin.x;
            }else if (x >= CGRectGetMaxX(self.trackView.frame)) {
                x = CGRectGetMaxX(self.trackView.frame);
            }

            CGFloat w = x - self.progressView.frame.origin.x;

            float progress = w / self.trackView.frame.size.width;

            _value = (self.maxValue - self.minValue) * progress + self.minValue;

        }

            break;
        case SSSliderDirectionVertical:
        {

            CGFloat y = location.y;
            if (y <= self.trackView.frame.origin.y) {
                y = self.trackView.frame.origin.y;
            }else if (y >= CGRectGetMaxY(self.trackView.frame)) {
                y = CGRectGetMaxY(self.trackView.frame);
            }

            CGFloat w = y - self.progressView.frame.origin.y;

            float progress = w / self.trackView.frame.size.height;

            _value = (self.maxValue - self.minValue) * progress + self.minValue;

        }
            break;

        default:
            break;
    }

    [self setupLayout];

    if ([self.delegate respondsToSelector:@selector(slider:valueDidChanged:)]) {

        [self.delegate slider:self valueDidChanged:self.value];
    }

    if ([self.delegate respondsToSelector:@selector(sliderDidTap:)]) {
        [self.delegate sliderDidTap:self];
    }

    [self autoAdjustValue];

}

- (void)sliderValueChange:(UIPanGestureRecognizer *)pan
{

    CGPoint t = [pan translationInView:pan.view];

    CGRect progressViewFrame = self.progressView.frame;

    switch (self.direction) {
        case SSSliderDirectionHorizantial: {

            progressViewFrame.size.width += t.x;
            if (progressViewFrame.size.width <= 0) {
                progressViewFrame.size.width = 0;
            }else if (progressViewFrame.size.width >= self.trackView.bounds.size.width) {
                progressViewFrame.size.width = self.trackView.bounds.size.width;
            }


            float progress = progressViewFrame.size.width / self.trackView.bounds.size.width;

            _value = (self.maxValue - self.minValue) * progress + self.minValue;


        }

            break;
        case SSSliderDirectionVertical:
        {


            progressViewFrame.size.height += t.y;
            if (progressViewFrame.size.height <= 0) {
                progressViewFrame.size.height = 0;
            }else if (progressViewFrame.size.height >= self.trackView.bounds.size.height) {
                progressViewFrame.size.height = self.trackView.bounds.size.height;
            }

            float progress = progressViewFrame.size.height / self.trackView.bounds.size.height;
            _value = (self.maxValue - self.minValue) * progress + self.minValue;

        }
            break;

        default:
            break;
    }

    [self setupLayout];

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            {
                _tracking = YES;
                if ([self.delegate respondsToSelector:@selector(sliderWillBeginDraging:)]) {
                    [self.delegate sliderWillBeginDraging:self];
                }
                if (self.autoHideSlider) {
                    [self showSlider];
                }
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            _tracking = NO;
            if ([self.delegate respondsToSelector:@selector(sliderDidEndDraging:)]) {
                [self.delegate sliderDidEndDraging:self];
            }

            [self autoAdjustValue];

            [self removeTimer];
            if (self.autoHideSlider) {
                [self addTimer];
            }

        }
            break;

        default:
            break;
    }

    [pan setTranslation:CGPointZero inView:pan.view];

    if ([self.delegate respondsToSelector:@selector(slider:valueDidChanged:)]) {
        [self.delegate slider:self valueDidChanged:self.value];
    }
}

- (void)autoAdjustValue
{

    if (self.autoAdjustWhenEndDragging && self.segmentCount) {

        CGFloat progressW = self.progressView.frame.size.width;

        CGFloat preW = self.trackView.frame.size.width / self.segmentCount;

        NSInteger count = progressW / preW;

        float value = 0;
        if ((progressW - count * preW) / preW >= 0.5) {

            float p = (count + 1) * preW / self.trackView.frame.size.width;

            value = self.minValue + (self.maxValue - self.minValue) * p;

        }else {

            float p = (count * preW) / self.trackView.frame.size.width;

            value = self.minValue + (self.maxValue - self.minValue) * p;

        }

        if ([self.delegate respondsToSelector:@selector(slider:didAutoAdjustValue:)]) {
            [self.delegate slider:self didAutoAdjustValue:value];
        }

        _value = value;

        [UIView animateWithDuration:0.25 animations:^{


            [self setupLayout];
        }];


    }


}



#pragma mark - Getter

- (BOOL)isTracking
{

    return _tracking;
//    return self.panGes.state == UIGestureRecognizerStateChanged;


}


- (UIImageView *)trackView
{
    if (!_trackView) {
        _trackView = [UIImageView new];
        _trackView.clipsToBounds = YES;
    }
    return _trackView;
}

- (UIImageView *)progressView
{
    if (!_progressView) {
        _progressView = [UIImageView new];
        _progressView.clipsToBounds = YES;
    }
    return _progressView;
}

- (UIImageView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIImageView alloc] init];
        _sliderView.userInteractionEnabled = YES;
        _sliderView.clipsToBounds = NO;
        _sliderView.contentMode = UIViewContentModeCenter;
        
        _sliderView.layer.shadowOpacity = 0.12; // 阴影透明度
        _sliderView.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影的颜色
        _sliderView.layer.shadowRadius = self.shadowRadius; // 阴影扩散的范围控制
        _sliderView.layer.shadowOffset = CGSizeMake(0, 0); // 阴影的范围
    }
    return _sliderView;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius != shadowRadius) {
        _shadowRadius = shadowRadius;
        self.sliderView.layer.shadowRadius = shadowRadius;
    }
}

@end
