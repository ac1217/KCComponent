//
//  KCAlertView.m
//  KCCommon
//
//  Created by Erica on 2018/8/3.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "KCAlertView.h"


@implementation KCAlertAction
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleFont = [UIFont systemFontOfSize:18];
        self.titleColor = [UIColor darkTextColor];
        self.cancelTitleColor = [UIColor darkGrayColor];
        self.destructiveTitleColor = [UIColor redColor];
    }
    return self;
}
@end

@interface KCAlertView()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIControl *controlView;

@property (nonatomic,strong) UIVisualEffectView *contentView;

@property (nonatomic,strong) NSMutableArray *actionButtons;
@property (nonatomic,strong) NSMutableArray *actionSeperators;

@end

@implementation KCAlertView

+ (instancetype)alertViewWithStyle:(KCAlertViewStyle)style title:(NSString *)title detail:(NSString *)detail actions:(NSArray <KCAlertAction *>*)actions
{
    KCAlertView *alertView = [self alertView];
    alertView.title = title;
    alertView.style = style;
    alertView.detail = detail;
    alertView.actions = actions;
    
    return alertView;
}

+ (instancetype)alertView
{
    KCAlertView *alertView = [[self alloc] init];
    KCAlertView *appearance = [self appearance];
    alertView.titleFont = appearance.titleFont;
    alertView.titleColor = appearance.titleColor;
    alertView.detailFont = appearance.detailFont;
    alertView.detailColor = appearance.detailColor;
    alertView.actionDismiss = appearance.actionDismiss;
    alertView.separatorColor = appearance.separatorColor;
    alertView.contentBackgroundColor = appearance.contentBackgroundColor;
    
    return [self new];
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

- (UIControl *)controlView
{
    if (!_controlView) {
        _controlView = [UIControl new];
        _controlView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
//        [_controlView addTarget:self action:@selector(controlViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
        
        [_controlView addTarget:self action:@selector(controlViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlView;
}

- (void)controlViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent*)event {
    
    if (self.backgroundDismiss) {
        [self dismiss];
    }
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor
{
    self.contentView.contentView.backgroundColor = contentBackgroundColor;
}

- (UIColor *)contentBackgroundColor
{
    return self.contentView.contentView.backgroundColor;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setDetail:(NSString *)detail
{
    self.detailLabel.text = detail;
}

- (NSString *)detail
{
    return self.detailLabel.text;
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    self.titleLabel.attributedText = attributedTitle;
}
- (NSAttributedString *)attributedTitle
{
    return self.titleLabel.attributedText;
}
- (void)setAttributedDetail:(NSAttributedString *)attributedDetail
{
    self.detailLabel.attributedText = attributedDetail;
}
- (NSAttributedString *)attributedDetail
{
    return self.detailLabel.attributedText;
}
- (void)setTitleColor:(UIColor *)titleColor
{
    self.titleLabel.textColor = titleColor;
}
-(UIColor *)titleColor
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
- (void)setDetailColor:(UIColor *)detailColor
{
    self.detailLabel.textColor = detailColor;
}
-(UIColor *)detailColor
{
    return self.detailLabel.textColor;
}
- (void)setDetailFont:(UIFont *)detailFont
{
    self.detailLabel.font = detailFont;
}
- (UIFont *)detailFont
{
    return self.detailLabel.font;
}



- (NSMutableArray *)actionButtons
{
    if (!_actionButtons) {
        _actionButtons = @[].mutableCopy;
    }
    return _actionButtons;
}

- (NSMutableArray *)actionSeperators
{
    if (!_actionSeperators) {
        _actionSeperators = @[].mutableCopy;
    }
    return _actionSeperators;
}

- (UIVisualEffectView *)contentView
{
    if (!_contentView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView  alloc] initWithEffect:effect];
//        effectView.backgroundColor = [UIColor whiteColor];
//        effectView.contentView.backgroundColor = [UIColor whiteColor];
        effectView.clipsToBounds = YES;
        _contentView = effectView;
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (void)setShowView:(UIView *)showView
{
    [_showView removeFromSuperview];
    _showView = showView;
    [self.contentView.contentView addSubview:showView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.controlView];
        [self addSubview:self.contentView];
        [self.contentView.contentView addSubview:self.titleLabel];
        [self.contentView.contentView addSubview:self.detailLabel];
        self.separatorColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.actionDismiss = YES;
        self.controlView.alpha = 0;
    }
    return self;
}

- (void)setupLayout
{
//    [super layoutSubviews];
    
    self.controlView.frame = self.bounds;
    
    CGFloat contentW = 0;
    CGFloat contentH = 0;
    if (self.style == KCAlertViewStyleAlert) { // alert
        contentW = self.bounds.size.width * 0.8;
        
    }else { // actionsheet
        contentW = self.bounds.size.width;
    }
    
    CGFloat marginV = 8;
//    CGFloat marginH = 10;
    CGFloat insetV = 25;
    CGFloat insetH = 20;
    
    CGSize maxSize = CGSizeMake(contentW - 2 * insetH, CGFLOAT_MAX);
    
    CGSize titleSize = [self.titleLabel sizeThatFits:maxSize];
    CGSize detailSize = [self.detailLabel sizeThatFits:maxSize];
    
    CGSize showSize = self.showView.frame.size;
    
    CGFloat startX = insetH;
    CGFloat startY = 0;
    
    if (!CGSizeEqualToSize(CGSizeZero, titleSize)) {
        
         startY = insetV;
        
        self.titleLabel.frame = CGRectMake(startX, startY, maxSize.width, titleSize.height);
        startY += titleSize.height;
        
    }
    
    if (!CGSizeEqualToSize(CGSizeZero, detailSize)) {
        
        if (!CGSizeEqualToSize(CGSizeZero, titleSize)) {
            
            startY += marginV;
        }else {
            
            startY = insetV;
        }
        
        self.detailLabel.frame = CGRectMake(startX, startY, maxSize.width, detailSize.height);
        startY += detailSize.height;
        
    }
    
    if (!CGSizeEqualToSize(CGSizeZero, showSize)) {
        
        if (!CGSizeEqualToSize(CGSizeZero, titleSize) || !CGSizeEqualToSize(CGSizeZero, detailSize)) {
            
            startY += marginV;
        }else {
            
            startY = insetV;
        }
        
        if (showSize.width > maxSize.width) {
            
            CGFloat showW = maxSize.width;
            CGFloat showH = showW * showSize.height / showSize.width;
            
            showSize = CGSizeMake(showW, showH);
            
        }
        
        CGFloat showX = (contentW - showSize.width) * 0.5;
        
        self.showView.frame = CGRectMake(showX, startY, showSize.width, showSize.height);
        startY += showSize.height;
        
    }
    if (!CGSizeEqualToSize(CGSizeZero, titleSize) || !CGSizeEqualToSize(CGSizeZero, detailSize) || !CGSizeEqualToSize(CGSizeZero, showSize)) {
        
        startY += insetV;
    }
    
        if (self.actionButtons.count) {
          
            CGFloat buttonH = 54;
            CGFloat buttonW = contentW;
            
            if (self.style == KCAlertViewStyleAlert) { // alert
                
                if (self.actionButtons.count == 2) {
                    buttonW = contentW * 0.5;
                }
                
                for (int i = 0; i < self.actionButtons.count; i++) {
                    
                    UIButton *actionBtn = self.actionButtons[i];
                    
                    CGFloat buttonX = 0;
                    CGFloat buttonY = 0;
                    if (self.actionButtons.count == 2) {
                        buttonX = i * buttonW;
                        buttonY = startY;
                    }else {
                        buttonX = 0;
                        buttonY = i * buttonH + startY;
                    }
                    
                    actionBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
                    
                    UIView *actionSepertor = self.actionSeperators[i];
                    
                    [self bringSubviewToFront:actionSepertor];
                    CGFloat sX = 0;
                    CGFloat sY = 0;
                    CGFloat sW = 0;
                    CGFloat sH = 0;
                    
                    if (self.actionButtons.count == 2 && i == 1) {
                        
                        sW = 0.5;
                        sH = buttonH;
                        sX = contentW * 0.5 - sW * 0.5;
                        sY = buttonY;
                        
                    }else {
                        
                        sX = 0;
                        sY = buttonY;
                        sW = contentW;
                        sH = 0.5;
                        
                    }
                    
                    actionSepertor.frame = CGRectMake(sX, sY, sW, sH);
                }
                
                if (self.actionButtons.count == 2) {
                    startY += buttonH;
                }else {
                    
                    startY += buttonH * self.actionButtons.count;
                }
            
            }else {
                
                NSMutableArray *cancelActionBtns = @[].mutableCopy;
                NSMutableArray *otherActionBtns = @[].mutableCopy;
                
                for (int i = 0; i < self.actionButtons.count; i++) {
                    
                    UIButton *actionBtn = self.actionButtons[i];
                    KCAlertAction *action = self.actions[i];
                    
                    if (action.style == KCAlertActionStyleCancel) {
                        [cancelActionBtns addObject:actionBtn];
                    }else {
                        
                        [otherActionBtns addObject:actionBtn];
                    }
                    
                }
                
                NSInteger seperatorIndex = 0;
                
                if (otherActionBtns.count) {
                    
                    for (int i = 0; i < otherActionBtns.count; i++) {
                        
                        UIButton *actionBtn = otherActionBtns[i];
                        
                        CGFloat buttonX = 0;
                        CGFloat buttonY = i * buttonH + startY;
                        
                        actionBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
                        
                        UIView *actionSepertor = self.actionSeperators[seperatorIndex + i];
                        [self bringSubviewToFront:actionSepertor];
                        CGFloat sX = 0;
                        CGFloat sY = buttonY;
                        CGFloat sW = contentW;
                        CGFloat sH = 0.5;
                        
                        actionSepertor.frame = CGRectMake(sX, sY, sW, sH);
                        
                        
                    }
                    
                    seperatorIndex = otherActionBtns.count;
                    
                    startY += buttonH * otherActionBtns.count;
                }
                
                
                if (cancelActionBtns.count) {
                    
                    startY += marginV;
                    
                    for (int i = 0; i < cancelActionBtns.count; i++) {
                        
                        UIButton *actionBtn = cancelActionBtns[i];
                        
                        CGFloat buttonX = 0;
                        CGFloat buttonY = i * buttonH + startY;
                        
                        actionBtn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
                        
                        UIView *actionSepertor = self.actionSeperators[seperatorIndex + i];
                        
                        [self bringSubviewToFront:actionSepertor];
                        
                        CGFloat sX = 0;
                        CGFloat sY = actionBtn.frame.origin.y;
                        CGFloat sW = contentW;
                        CGFloat sH = 0.5;
                        if (i == 0) {
                            sH = marginV;
                            sY -= marginV;
                        }
                        
                        actionSepertor.frame = CGRectMake(sX, sY, sW, sH);
                    }
                    
                    startY += buttonH * cancelActionBtns.count;
                    
                }
                
            }
            
        }
    
    contentH = startY;
    
    self.contentView.frame = CGRectMake(0, 0, contentW, contentH);
    
    if (self.style == KCAlertViewStyleAlert) {
        self.contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    }else {
        
        self.contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - self.contentView.frame.size.height * 0.5);
    }
    
    
}

- (void)actionBtnClick:(UIButton *)btn
{
    if (self.actionDismiss) {
        [self dismiss];
    }
    
    KCAlertAction *action = self.actions[btn.tag];
    
    !action.handler ? : action.handler(action);
    
}

- (UIButton *)actionButtonWithAction:(KCAlertAction *)action
{
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actionBtn.titleLabel.font = action.titleFont;
    if (action.attributedTitle) {
        
        [actionBtn setAttributedTitle:action.attributedTitle forState:0];
    }else {
        
        [actionBtn setTitle:action.title forState:0];
    }
    [actionBtn setImage:action.image forState:0];
    [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    switch (action.style) {
        case KCAlertActionStyleCancel:
            [actionBtn setTitleColor:action.cancelTitleColor forState:0];
            break;
        case KCAlertActionStyleDefault:
            
            [actionBtn setTitleColor:action.titleColor forState:0];
            break;
        case KCAlertActionStyleDestructive:
            
            [actionBtn setTitleColor:action.destructiveTitleColor forState:0];
            break;
            
        default:
            break;
    }
    
    return actionBtn;
}


- (void)showInView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    self.frame = view.bounds;
    
    if (self.style == KCAlertViewStyleAlert) {
        
        self.contentView.layer.cornerRadius = 10;
    }else {
        self.contentView.layer.cornerRadius = 0;
    }
    
    [self.actionButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.actionSeperators makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.actionButtons removeAllObjects];
    [self.actionSeperators removeAllObjects];
    
    for (int i = 0; i < self.actions.count; i++) {
        KCAlertAction *action = self.actions[i];
        UIButton *actionBtn = [self actionButtonWithAction:action];
        actionBtn.tag = i;
        [self.actionButtons addObject:actionBtn];
        [self.contentView.contentView addSubview:actionBtn];
        
        UIView *s = [UIView new];
        s.backgroundColor = self.separatorColor;
//        s.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        [self.actionSeperators addObject:s];
        [self.contentView.contentView addSubview:s];
    }
    
    
    [self setupLayout];
    
    if (self.style == KCAlertViewStyleAlert) {
        
        
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(self.contentView.frame));
//        self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.controlView.alpha = 1;
            self.contentView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }else {
        
        self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.frame.size.height);
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            
            
            self.controlView.alpha = 1;
            
            self.contentView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (void)dismiss
{
    if (self.style == KCAlertViewStyleAlert) {
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.contentView.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
            
                self.controlView.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.actions = nil;
            [self.actionButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.actionSeperators makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.actionSeperators removeAllObjects];
            [self.actionButtons removeAllObjects];
            [self removeFromSuperview];
            
        }];
    }else {
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.controlView.alpha = 0;
            
            self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.frame.size.height);
            
        } completion:^(BOOL finished) {
            self.actions = nil;
            [self.actionButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.actionSeperators makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.actionSeperators removeAllObjects];
            [self.actionButtons removeAllObjects];
            [self removeFromSuperview];
//            !completion ? : completion();
        }];
        
        
    }
    
}

@end
