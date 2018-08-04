//
//  KCEmptyView.m
//  KCCommon
//
//  Created by Erica on 2018/8/1.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCEmptyView.h"

@interface KCEmptyView()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIButton *refreshBtn;

@end

@implementation KCEmptyView

+ (instancetype)emptyView
{
    KCEmptyView *empty = [[self alloc] init];
    
    KCEmptyView *appearance = [self appearance];
    empty.titleColor = appearance.titleColor;
    empty.titleFont = appearance.titleFont;
    empty.descColor = appearance.descColor;
    empty.descFont = appearance.descFont;
    empty.refreshTitleColor = appearance.refreshTitleColor;
    empty.refreshTitleFont = appearance.refreshTitleFont;
    
    return empty;
}

+ (instancetype)appearance
{
    static id instance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    self.titleLabel.attributedText = attributedTitle;
}

- (NSAttributedString *)attributedTitle
{
    return self.titleLabel.attributedText;
}

- (void)setAttributedDesc:(NSAttributedString *)attributedDesc
{
    self.descLabel.attributedText = attributedDesc;
}

- (NSAttributedString *)attributedDesc
{
    return self.descLabel.attributedText;
}

- (void)setAttributedreRreshTitle:(NSAttributedString *)attributedreRreshTitle
{
    [self.refreshBtn setAttributedTitle:attributedreRreshTitle forState:0];
}

- (NSAttributedString *)attributedreRreshTitle
{
    return self.refreshBtn.currentAttributedTitle;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.titleLabel.textColor = titleColor;
}

- (UIColor *)titleColor
{
    return self.titleLabel.textColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    self.titleLabel.font = titleFont;
}

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setDescColor:(UIColor *)descColor
{
    self.descLabel.textColor = descColor;
}

- (UIColor *)descColor
{
    return self.descLabel.textColor;
}

- (void)setDescFont:(UIFont *)descFont
{
    self.descLabel.font = descFont;
}

- (UIFont *)descFont
{
    return self.descLabel.font;
}

- (void)setRefreshTitleFont:(UIFont *)refreshTitleFont
{
    self.refreshBtn.titleLabel.font = refreshTitleFont;
}

- (UIFont *)refreshTitleFont
{
    return self.refreshBtn.titleLabel.font;
}

- (void)setRefreshTitleColor:(UIColor *)refreshTitleColor
{
    [self.refreshBtn setTitleColor:refreshTitleColor forState:0];
}

- (UIColor *)refreshTitleColor
{
    return self.refreshBtn.currentTitleColor;
}

- (void)setImage:(UIImage *)image
{
    
    self.imageView.image = image;
    
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setDesc:(NSString *)desc
{
    self.descLabel.text = desc;
}

- (NSString *)desc
{
    return self.descLabel.text;
}

- (void)setRefreshTitle:(NSString *)refreshTitle
{
    [self.refreshBtn setTitle:refreshTitle forState:0];
}

- (NSString *)refreshTitle
{
    return [self.refreshBtn currentTitle];
}

- (void)showInView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    self.frame = view.bounds;
    
    
    [self layoutIfNeeded];
//    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UIButton *)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton new];
        [_refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setTitleColor:[UIColor darkGrayColor] forState:0];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _refreshBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.refreshBtn];
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)refreshBtnClick
{
    if ([self.delegate respondsToSelector:@selector(emptyViewDidClickRefreshBtn:)]) {
        [self.delegate emptyViewDidClickRefreshBtn:self];
    }
}

- (void)tap
{
    if ([self.delegate respondsToSelector:@selector(emptyViewDidClick:)]) {
        [self.delegate emptyViewDidClick:self];
    }
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(self.bounds.size.width * 0.8, CGFLOAT_MAX);
    
    CGSize imageSize = [self.imageView sizeThatFits:maxSize];
    CGSize descSize = [self.descLabel sizeThatFits:maxSize];
    CGSize titleSize = [self.titleLabel sizeThatFits:maxSize];
    CGSize refreshSize = [self.refreshBtn sizeThatFits:maxSize];
    
    CGFloat marginV = 5;
    CGFloat contentHeight = marginV;
    CGFloat contentWidth = 0;
    self.imageView.frame = CGRectMake(0, contentHeight, imageSize.width, imageSize.height);
    
    if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
        
        contentHeight += imageSize.height;
        contentHeight += marginV;
        
        if (imageSize.width > contentWidth) {
            contentWidth = imageSize.width;
        }
        
    }
    
    self.titleLabel.frame = CGRectMake(0, contentHeight, titleSize.width, titleSize.height);
    
    if (!CGSizeEqualToSize(titleSize, CGSizeZero)) {
        
        contentHeight += titleSize.height;
        contentHeight += marginV;
        
        if (titleSize.width > contentWidth) {
            contentWidth = titleSize.width;
        }
    }
    
    self.descLabel.frame = CGRectMake(0, contentHeight, descSize.width, descSize.height);
    
    if (!CGSizeEqualToSize(descSize, CGSizeZero)) {
        
        contentHeight += descSize.height;
        contentHeight += marginV;
        
        if (descSize.width > contentWidth) {
            contentWidth = descSize.width;
        }
    }
    
    self.refreshBtn.frame = CGRectMake(0, contentHeight, refreshSize.width, refreshSize.height);
    
    if (!CGSizeEqualToSize(refreshSize, CGSizeZero)) {
        
        contentHeight += refreshSize.height;
        contentHeight += marginV;
        
        if (refreshSize.width > contentWidth) {
            contentWidth = refreshSize.width;
        }
    }
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = (contentWidth - imageFrame.size.width) * 0.5;
    self.imageView.frame = imageFrame;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = (contentWidth - titleFrame.size.width) * 0.5;
    self.titleLabel.frame = titleFrame;
    
    CGRect descFrame = self.descLabel.frame;
    descFrame.origin.x = (contentWidth - descFrame.size.width) * 0.5;
    self.descLabel.frame = descFrame;
    
    CGRect refreshFrame = self.refreshBtn.frame;
    refreshFrame.origin.x = (contentWidth - refreshFrame.size.width) * 0.5;
    self.refreshBtn.frame = refreshFrame;
    
    self.contentView.frame = CGRectMake((self.bounds.size.width - contentWidth) * 0.5, (self.bounds.size.height - contentHeight) * 0.5, contentWidth, contentHeight);
    
    
    
}


@end
