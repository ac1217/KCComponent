//
//  KCLoadingView.m
//  KCComponent
//
//  Created by Erica on 2018/9/13.
//  Copyright © 2018年 erica. All rights reserved.
//

#import "KCLoadingView.h"

@interface KCLoadingView()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) UIImageView *gifView;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation KCLoadingView

+ (instancetype)appearance
{
    static id instance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

+ (instancetype)loadingView
{
    
    KCLoadingView *loading = [[self alloc] init];
    
    KCLoadingView *appearance = [self appearance];
    loading.style = appearance.style;
    loading.images = appearance.images;
//    progress.progressTextColor = appearance.progressTextColor;
//    progress.progressTextFont = appearance.progressTextFont;
//    progress.progressTintColor = appearance.progressTintColor;
//    progress.lineWidth = appearance.lineWidth;
//    progress.lineCap = appearance.lineCap;
    
    return loading;
}

- (void)setImages:(NSArray *)images
{
    self.gifView.animationImages = images;
}

- (NSArray *)images
{
    return self.gifView.animationImages;
}

- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        _gifView = [[UIImageView alloc] init];
        _gifView.contentMode = UIViewContentModeScaleAspectFill;
        _gifView.clipsToBounds = YES;
    }
    return _gifView;
}


- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.frame = self.bounds;
    self.indicatorView.frame = self.bounds;
    self.shapeLayer.frame = self.bounds;
}


- (void)setStyle:(KCLoadingViewStyle)style
{
    _style = style;
    
    switch (style) {
        case KCLoadingViewStyleDefault:
            self.indicatorView.hidden = NO;
            self.gifView.hidden = YES;
            self.shapeLayer.hidden = YES;
            break;
        case KCLoadingViewStyleGif:
            self.indicatorView.hidden = YES;
            self.gifView.hidden = NO;
            self.shapeLayer.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.indicatorView];
        [self addSubview:self.gifView];
        [self.layer addSublayer:self.shapeLayer];
        
        self.indicatorView.hidden = NO;
        self.gifView.hidden = YES;
        self.shapeLayer.hidden = YES;
    }
    return self;
}


- (void)startAnimating
{
    switch (self.style) {
        case KCLoadingViewStyleDefault:
            [self.indicatorView startAnimating];
            break;
        case KCLoadingViewStyleGif:
            [self.gifView startAnimating];
            break;
            
        default:
            break;
    }
    
    
}

- (void)stopAnimating
{
    switch (self.style) {
        case KCLoadingViewStyleDefault:
            
                [self.indicatorView stopAnimating];
            break;
        case KCLoadingViewStyleGif:
                [self.gifView stopAnimating];
            break;
            
        default:
            break;
    }
    
}

@end
