//
//  KCToastView.m
//  KCCommon
//
//  Created by Erica on 2018/8/2.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCToastView.h"

@interface KCToastView()

@property (nonatomic,strong) UIVisualEffectView *contentView;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) UIControl *controlView;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation KCToastView



+ (instancetype)appearance
{
    static id instance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor
{
    self.contentView.backgroundColor = contentBackgroundColor;
}

- (UIColor *)contentBackgroundColor
{
    return self.contentView.backgroundColor;
}

- (void)setTextFont:(UIFont *)textFont {
    self.textLabel.font = textFont;
}
- (UIFont *)textFont
{
    return self.textLabel.font;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}

- (UIColor *)textColor
{
    return self.textLabel.textColor;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

- (NSString *)text
{
    return self.textLabel.text;
}

- (void)setProgress:(float)progress
{
    self.progressView.progress = progress;
}

- (float)progress
{
    return self.progressView.progress;
}

+ (instancetype)toastView
{
    KCToastView *toastView = [self new];
    
    KCToastView *appearance = [self appearance];
    
    toastView.textColor = appearance.textColor;
    toastView.textFont = appearance.textFont;
    toastView.layoutDirection = appearance.layoutDirection;
    toastView.position = appearance.position;
    toastView.loadingType = appearance.loadingType;
    toastView.errorImage = appearance.errorImage;
    toastView.successImage = appearance.successImage;
    toastView.loadingImages = appearance.loadingImages;
    toastView.infoImage = appearance.infoImage;
    toastView.contentBackgroundColor = appearance.contentBackgroundColor;
    toastView.maskType = appearance.maskType;
    toastView.imageSize = appearance.imageSize;
    toastView.progressSize = appearance.progressSize;
    toastView.loadingSize = appearance.loadingSize;
    
    return toastView;
}

- (void)showInView:(UIView *)view
{
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [view addSubview:self];
    self.frame = view.bounds;
    
    switch (self.style) {
        case KCToastViewStyleInfo:
            self.imageView.hidden = NO;
            self.textLabel.hidden = NO;
            self.progressView.hidden = YES;
            [self.indicatorView stopAnimating];
            self.imageView.image = self.infoImage;
            break;
        case KCToastViewStyleSuccess:
            self.imageView.hidden = NO;
            self.textLabel.hidden = NO;
            self.progressView.hidden = YES;
            [self.indicatorView stopAnimating];
            self.imageView.image = self.successImage;
            break;
        case KCToastViewStyleError:
            self.imageView.hidden = NO;
            self.textLabel.hidden = NO;
            self.progressView.hidden = YES;
            [self.indicatorView stopAnimating];
            self.imageView.image = self.errorImage;
            
            break;
        case KCToastViewStyleLoading:
            
            if (self.loadingType == KCToastViewLoadingTypeDefault) {
                
                self.imageView.hidden = YES;
                [self.indicatorView startAnimating];
                self.imageView.animationImages = nil;
                [self.imageView stopAnimating];
                
            }else {
                
                self.imageView.hidden = NO;
                [self.indicatorView stopAnimating];
                self.imageView.animationImages = self.loadingImages;
                [self.imageView startAnimating];
                
            }
            
            self.textLabel.hidden = NO;
            self.progressView.hidden = YES;
            break;
        case KCToastViewStyleProgress:
            self.imageView.hidden = YES;
            self.textLabel.hidden = NO;
            self.progressView.hidden = NO;
            [self.indicatorView stopAnimating];
            break;
            
        default:
            break;
    }
    
    switch (self.maskType) {
        case KCToastViewMaskTypeNone:
            
            self.userInteractionEnabled = NO;
            self.backgroundColor = [UIColor clearColor];
            break;
        case KCToastViewMaskTypeClear:
            
            self.userInteractionEnabled = YES;
            self.backgroundColor = [UIColor clearColor];
            break;
        case KCToastViewMaskTypeBlack:
            
            self.userInteractionEnabled = YES;
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            break;
            
        default:
            break;
    }
    
//    [self setNeedsLayout];
    
    [self layoutIfNeeded];
    
//    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{

//        self.contentView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
        
//        switch (self.style) {
//            case KCToastViewStyleInfo:
//            case KCToastViewStyleSuccess:
//            case KCToastViewStyleError:
//                {
                    if (self.duration > 0) {
                        
                        [self addTimer];
                    }
//                }
//                break;
//
//            default:
//                break;
//        }
        
    }];
    
    [self removeTimer];
    
}



- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addTimer
{
    
    self.timer = [NSTimer timerWithTimeInterval:self.duration target:self selector:@selector(fire) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]  addTimer:self.timer forMode:NSRunLoopCommonModes];
  
}

- (void)fire
{
    [self removeTimer];
    [self dismiss];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}



#pragma mark - Event handling

- (void)controlViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent*)event {

}

- (UIVisualEffectView *)contentView
{
    if (!_contentView) {
       UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView  alloc] initWithEffect:effect];
        effectView.clipsToBounds = YES;
        effectView.layer.cornerRadius = 5;
        
        _contentView = effectView;
    }
    return _contentView;
}

- (KCProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[KCProgressView alloc] init];
        _progressView.style = KCProgressViewStyleCircle;
        _progressView.frame = CGRectMake(0, 0, 30, 30);
        _progressView.trackTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        _progressView.progressTextFont = [UIFont systemFontOfSize:10];
        _progressView.lineWidth = 3;
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.progressTextColor = [UIColor whiteColor];
        
    }
    return _progressView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}


- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.controlView];
        [self addSubview:self.contentView];
        [self.contentView.contentView addSubview:self.textLabel];
        [self.contentView.contentView addSubview:self.imageView];
        [self.contentView.contentView addSubview:self.progressView];
        [self.contentView.contentView addSubview:self.indicatorView];
//        self.duration = 3;
        self.alpha = 0;
        
        [self addTarget:self action:@selector(controlViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.controlView.frame = self.bounds;
    
    CGFloat contentW = 0;
    CGFloat contentH = 0;
    
    CGSize maxSize = CGSizeMake(self.bounds.size.width * 0.8, CGFLOAT_MAX);
    CGSize textSize = [self.textLabel sizeThatFits:maxSize];
    
    CGSize imageSize = [self.imageView sizeThatFits:maxSize];
    if (!CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
        imageSize = self.imageSize;
//        if (imageSize.width > self.maxImageSize.width && imageSize.height > self.maxImageSize.height) {
//            imageSize = self.maxImageSize;
//        }
        
    }
    
    CGSize indicatorSize = [self.indicatorView sizeThatFits:maxSize];
    CGSize progressSize = self.progressView.frame.size;
    
    if (!CGSizeEqualToSize(self.progressSize, CGSizeZero)) {
        progressSize = self.progressSize;
        
    }
    
    CGFloat marginH = 15;
    CGFloat marginV = 10;
    
    if (self.layoutDirection == KCToastViewLayoutDirectionHorizontal) {
     
        switch (self.style) {
            case KCToastViewStyleLoading:
                
                if (self.loadingType == KCToastViewLoadingTypeDefault) {
                    contentH = MAX(indicatorSize.height, textSize.height) + 2 * marginV;
                    
                    contentW = marginH;
                    if (!CGSizeEqualToSize(indicatorSize, CGSizeZero)) {
                        self.indicatorView.frame = CGRectMake(contentW, (contentH - indicatorSize.height) * 0.5, indicatorSize.width, indicatorSize.height);
                        contentW += indicatorSize.width + marginH;
                    }
                    if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                        self.textLabel.frame = CGRectMake(contentW, (contentH - textSize.height) * 0.5, textSize.width, textSize.height);
                        contentW += textSize.width + marginH;
                    }
                    
                }else {
                    contentH = MAX(imageSize.height, textSize.height) + 2 * marginV;
                    
                    contentW = marginH;
                    if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
                        self.imageView.frame = CGRectMake(contentW, (contentH - imageSize.height) * 0.5, imageSize.width, imageSize.height);
                        contentW += imageSize.width + marginH;
                    }
                    if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                        self.textLabel.frame = CGRectMake(contentW, (contentH - textSize.height) * 0.5, textSize.width, textSize.height);
                        contentW += textSize.width + marginH;
                    }
                    
                }
                
                break;
            case KCToastViewStyleProgress:
                
                contentW = marginH;
                contentH = MAX(progressSize.height, textSize.height) + 2 * marginV;
                
                contentW = marginH;
                if (!CGSizeEqualToSize(progressSize, CGSizeZero)) {
                    self.progressView.frame = CGRectMake(contentW, (contentH - progressSize.height) * 0.5, progressSize.width, progressSize.height);
                    contentW += progressSize.width + marginH;
                }
                if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                    self.textLabel.frame = CGRectMake(contentW, (contentH - textSize.height) * 0.5, textSize.width, textSize.height);
                    contentW += textSize.width + marginH;
                }
                
                
                
                
                break;
                
            case KCToastViewStyleSuccess:
            case KCToastViewStyleError:
            case KCToastViewStyleInfo:
                
                contentH = MAX(imageSize.height, textSize.height) + 2 * marginV;
                
                contentW = marginH;
                
                if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
                    
                    self.imageView.frame = CGRectMake(contentW, (contentH - imageSize.height) * 0.5, imageSize.width, imageSize.height);
                    contentW += imageSize.width + marginH;
                    
                }
                
                if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                    
                    self.textLabel.frame = CGRectMake(contentW, (contentH - textSize.height) * 0.5, textSize.width, textSize.height);
                    contentW += textSize.width + marginH;
                }
                
                
                
                
                break;
                
            default:
                break;
        }
        
    }else {
//        CGFloat marginH = 8;
//        CGFloat marginV = 10;
        switch (self.style) {
            case KCToastViewStyleLoading:
                
                if (self.loadingType == KCToastViewLoadingTypeDefault) {
                    contentW = MAX(indicatorSize.width, textSize.width) + 2 * marginH;
                    contentH = marginV;
                    
                    if (!CGSizeEqualToSize(indicatorSize, CGSizeZero)) {
                        self.indicatorView.frame = CGRectMake((contentW - indicatorSize.width) * 0.5, contentH, indicatorSize.width, indicatorSize.height);
                        contentH += indicatorSize.height + marginV;
                    }
                    if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                        self.textLabel.frame = CGRectMake((contentW - textSize.width) * 0.5, contentH, textSize.width, textSize.height);
                        contentH += textSize.height + marginV;
                    }
                    
                }else {
                    contentW = MAX(imageSize.width, textSize.width) + 2 * marginH;
                    contentH = marginV;
                    
                    if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
                        self.imageView.frame = CGRectMake((contentW - imageSize.width) * 0.5, contentH, imageSize.width, imageSize.height);
                        contentH += imageSize.height + marginV;
                    }
                    if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                        self.textLabel.frame = CGRectMake((contentW - textSize.width) * 0.5, contentH, textSize.width, textSize.height);
                        contentH += textSize.height + marginV;
                    }
                    
                }
                
                
                break;
            case KCToastViewStyleProgress:
                
                
                contentW = MAX(progressSize.width, textSize.width) + 2 * marginH;
                contentH = marginV;
                
                if (!CGSizeEqualToSize(progressSize, CGSizeZero)) {
                    self.progressView.frame = CGRectMake((contentW - progressSize.width) * 0.5, contentH, progressSize.width, progressSize.height);
                    contentH += progressSize.height + marginV;
                }
                if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                    self.textLabel.frame = CGRectMake((contentW - textSize.width) * 0.5, contentH, textSize.width, textSize.height);
                    contentH += textSize.height + marginV;
                }
                
               
                
                break;
                
            case KCToastViewStyleSuccess:
            case KCToastViewStyleError:
            case KCToastViewStyleInfo:
                
                contentW = MAX(imageSize.width, textSize.width) + 2 * marginH;
                contentH = marginV;
                
                if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
                    self.imageView.frame = CGRectMake((contentW - imageSize.width) * 0.5, contentH, imageSize.width, imageSize.height);
                    contentH += imageSize.height + marginV;
                }
                if (!CGSizeEqualToSize(textSize, CGSizeZero)) {
                    self.textLabel.frame = CGRectMake((contentW - textSize.width) * 0.5, contentH, textSize.width, textSize.height);
                    contentH += textSize.height + marginV;
                }
                
                break;
                
            default:
                break;
        }
        
        
    }
    
    self.contentView.frame = CGRectMake(0, 0, contentW, contentH);
    
    
    switch (self.position) {
        case KCToastViewPositionTop:
            
            
            self.contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.contentView.frame.size.height * 0.5 + self.bounds.size.height * 0.1);
            
            break;
        case KCToastViewPositionCenter:
            
            self.contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
            
            break;
        case KCToastViewPositionBottom:
            
            self.contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.9 - self.contentView.frame.size.height * 0.5);
            
            break;
            
        default:
            break;
    }
    
    
}


@end
