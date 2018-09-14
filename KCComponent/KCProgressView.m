//
//  KCProgressView.m
//  KCComponent
//
//  Created by Erica on 2018/8/10.
//  Copyright © 2018年 erica. All rights reserved.
//

#import "KCProgressView.h"

@interface KCProgressView()

@property (nonatomic,strong) UILabel *progressLabel;

@property (nonatomic,strong) CAShapeLayer *trackLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;

@end

@implementation KCProgressView

+ (instancetype)appearance
{
    static id instance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}


+ (instancetype)progressView
{
    KCProgressView *progress = [[self alloc] init];
    
    KCProgressView *appearance = [self appearance];
    progress.progressTextColor = appearance.progressTextColor;
    progress.progressTextFont = appearance.progressTextFont;
    progress.progressTintColor = appearance.progressTintColor;
    progress.lineWidth = appearance.lineWidth;
    progress.lineCap = appearance.lineCap;
    
    return progress;
}


- (void)setProgressTextFont:(UIFont *)progressTextFont
{
    self.progressLabel.font = progressTextFont;
}

- (UIFont *)progressTextFont
{
    return self.progressLabel.font;
}

- (void)setProgressTextColor:(UIColor *)progressTextColor
{
    self.progressLabel.textColor = progressTextColor;
}

- (UIColor *)progressTextColor
{
    return self.progressLabel.textColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.trackLayer.strokeColor = trackTintColor.CGColor;
}

- (UIColor *)trackTintColor
{
    return [UIColor colorWithCGColor:self.trackLayer.strokeColor];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.progressLayer.strokeColor = progressTintColor.CGColor;
}

- (UIColor *)progressTintColor
{
    return [UIColor colorWithCGColor:self.progressLayer.strokeColor];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    self.trackLayer.lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
}

- (CGFloat)lineWidth
{
    return self.trackLayer.lineWidth;
}

- (void)setLineCap:(NSString *)lineCap
{
    self.trackLayer.lineCap = lineCap;
    self.progressLayer.lineCap = lineCap;
}

- (NSString *)lineCap
{
    return self.trackLayer.lineCap;
}

- (void)setProgress:(float)progress
{
//    NSLog(@"%f", progress);
    
    self.progressLayer.strokeEnd = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
}

- (float)progress
{
    return self.progressLayer.strokeEnd;
}

- (void)setStyle:(KCProgressViewStyle)style
{
    if (_style == style) {
        return;
    }
    _style = style;
    
    [self setNeedsLayout];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.trackLayer];
        [self.layer addSublayer:self.progressLayer];
        
        [self addSubview:self.progressLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.trackLayer.frame = self.layer.bounds;
    self.progressLayer.frame = self.layer.bounds;
    
    self.progressLabel.frame = self.bounds;
    
    switch (self.style) {
        case KCProgressViewStyleLine:
        {
            CGSize textSize = [self.progressLabel.text sizeWithAttributes:@{NSFontAttributeName : self.progressLabel.font}];
            
            CGFloat startY = (self.bounds.size.height - 5 - textSize.height - self.lineWidth) * 0.5;
            
            CGPoint progressCenter = self.progressLabel.center;
            progressCenter.y = startY + textSize.height * 0.5;
            self.progressLabel.center = progressCenter;
            startY += textSize.height + 5;
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            [path moveToPoint:CGPointMake(0, startY)];
            [path addLineToPoint:CGPointMake(self.layer.bounds.size.width, startY)];
            
            self.trackLayer.path = path.CGPath;
            self.progressLayer.path = path.CGPath;
        }
            break;
        case KCProgressViewStyleCircle:
        {
            CGFloat startAngle = -M_PI / 2;
            CGFloat endAngle = startAngle + M_PI * 2;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.layer.bounds.size.width * 0.5, self.layer.bounds.size.height * 0.5) radius:self.layer.bounds.size.width * 0.5 startAngle:startAngle endAngle:endAngle clockwise:1];
            
            self.trackLayer.path = path.CGPath;
            self.progressLayer.path = path.CGPath;
            
        }
            break;
        case KCProgressViewStyleRect:
        {
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:self.layer.cornerRadius];
            
            self.trackLayer.path = path.CGPath;
            self.progressLayer.path = path.CGPath;
            
        }
            break;
        case KCProgressViewStyleCustom:
        {
            
            UIBezierPath *path = self.path;
            
            self.trackLayer.path = path.CGPath;
            self.progressLayer.path = path.CGPath;
            
        }
            break;
            
        default:
            break;
    }
    
}

- (CAShapeLayer *)trackLayer
{
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer new];
        _trackLayer.strokeColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        _trackLayer.fillColor = [UIColor clearColor].CGColor;
        
        _trackLayer.lineWidth = 3;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.strokeStart = 0;
        _trackLayer.strokeEnd = 1;
    }
    return _trackLayer;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer new];
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        
        _progressLayer.lineWidth = 3;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.font = [UIFont systemFontOfSize:10];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.text = @"0%";
    }
    return _progressLabel;
}


@end
