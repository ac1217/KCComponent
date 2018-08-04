//
//  KCNavigationView.m
//  KuShow
//
//  Created by iMac on 2017/6/6.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "KCNavigationView.h"


@implementation KSNavigationButtonItem

+ (instancetype)appearance
{
    static id instance_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _enabled = YES;
        _titleColor = [UIColor whiteColor];
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title handle:(void (^)(KSNavigationButtonItem *))handle
{
    return [self initWithTitle:title image:nil highlightedImage:nil handle:handle];
}

+ (instancetype)itemWithTitle:(NSString *)title handle:(void (^)(KSNavigationButtonItem *))handle
{
    return [[self alloc] initWithTitle:title handle:handle];
}


+ (instancetype)itemWithImage:(UIImage *)image handle:(void(^)(KSNavigationButtonItem * item))handle
{
    return [[self alloc] initWithImage:image handle:handle];
}

- (instancetype)initWithImage:(UIImage *)image handle:(void(^)(KSNavigationButtonItem * item))handle
{
    return [self initWithImage:image highlightedImage:nil handle:handle];
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage handle:(void (^)(KSNavigationButtonItem *))handle
{
    return [self initWithTitle:nil image:image highlightedImage:highlightedImage handle:handle];
}

+ (instancetype)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage handle:(void (^)(KSNavigationButtonItem *))handle {
    
    return [[self alloc] initWithImage:image highlightedImage:highlightedImage handle:handle];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage handle:(void(^)(KSNavigationButtonItem * item))handle
{
    
    if (self = [self init]) {
        
        KSNavigationButtonItem *apprance = [KSNavigationButtonItem appearance];
        
        self.title = title;
        self.image = image;
        self.highlightedImage = highlightedImage;
        self.handle = handle;
        
        self.titleColor = apprance.titleColor;
        self.titleFont = apprance.titleFont;
        self.highlightedTitleColor = apprance.highlightedTitleColor;
        self.disabledTitleColor = apprance.disabledTitleColor;
        self.selectedTitleColor = apprance.selectedTitleColor;
        

    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage handle:(void(^)(KSNavigationButtonItem * item))handle
{
    return [[self alloc] initWithTitle:title image:image highlightedImage:highlightedImage handle:handle];
    
}

@end

@interface KCNavigationView ()

@property (nonatomic,strong) NSMutableArray *leftButtons;
@property (nonatomic,strong) NSMutableArray *rightButtons;



@property (nonatomic,strong) NSLayoutConstraint *statusBarHeightCons;
@property (nonatomic,strong) NSLayoutConstraint *backgroundViewTopCons;

@end

@implementation KCNavigationView

- (void)dealloc
{

    [self removeLeftButtonItemKVO];
    [self removeRightButtonItemKVO];
}

- (void)addLeftButtonItemKVO
{
    for (KSNavigationButtonItem *buttonItem in self.leftButtonItems) {
        [self addButtonItemKVO:buttonItem];
    }

}
- (void)removeLeftButtonItemKVO
{
    
    for (KSNavigationButtonItem *buttonItem in self.leftButtonItems) {
        [self removeButtonItemKVO:buttonItem];
    }
}

- (void)addRightButtonItemKVO
{
    for (KSNavigationButtonItem *buttonItem in self.rightButtonItems) {
        [self addButtonItemKVO:buttonItem];
    }
    
}
- (void)removeRightButtonItemKVO
{
    
    for (KSNavigationButtonItem *buttonItem in self.rightButtonItems) {
        [self removeButtonItemKVO:buttonItem];
    }
}

- (void)addButtonItemKVO:(KSNavigationButtonItem *)item
{
    
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"highlightedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"disabledImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"titleColor" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedTitleColor" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"highlightedTitleColor" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"disabledTitleColor" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeButtonItemKVO:(KSNavigationButtonItem *)item
{
    
    [item removeObserver:self forKeyPath:@"title"];
    [item removeObserver:self forKeyPath:@"image"];
    [item removeObserver:self forKeyPath:@"highlightedImage"];
    [item removeObserver:self forKeyPath:@"enabled"];
    [item removeObserver:self forKeyPath:@"disabledImage"];
    [item removeObserver:self forKeyPath:@"selected"];
    [item removeObserver:self forKeyPath:@"selectedImage"];
    [item removeObserver:self forKeyPath:@"titleFont"];
    [item removeObserver:self forKeyPath:@"titleColor"];
    [item removeObserver:self forKeyPath:@"disabledTitleColor"];
    [item removeObserver:self forKeyPath:@"highlightedTitleColor"];
    [item removeObserver:self forKeyPath:@"selectedTitleColor"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    UIButton *btn = nil;
    
    if ([self.leftButtonItems containsObject:object]) {
        
        NSInteger index = [self.leftButtonItems indexOfObject:object];
        
        btn = self.leftButtons[index];
        
    }else {
        
        NSInteger index = [self.rightButtonItems indexOfObject:object];
        
        btn = self.rightButtons[index];
    }
    
    KSNavigationButtonItem *buttonItem = object;
    
    if ([keyPath isEqualToString:@"title"]) {
        [btn setTitle:buttonItem.title forState:UIControlStateNormal];
    }else if ([keyPath isEqualToString:@"image"]) {
        [btn setImage:buttonItem.image forState:UIControlStateNormal];
    }else if ([keyPath isEqualToString:@"highlightedImage"]) {
        [btn setImage:buttonItem.highlightedImage forState:UIControlStateHighlighted];
    }else if ([keyPath isEqualToString:@"disabledImage"]) {
        [btn setImage:buttonItem.disabledImage forState:UIControlStateDisabled];
        
    }else if ([keyPath isEqualToString:@"enabled"]) {
        btn.enabled = buttonItem.isEnabled;
    }else if ([keyPath isEqualToString:@"selected"]) {
        btn.selected = buttonItem.isSelected;
    }else if ([keyPath isEqualToString:@"selectedImage"]) {
        [btn setImage:buttonItem.selectedImage forState:UIControlStateSelected];
        
    }else if ([keyPath isEqualToString:@"titleFont"]) {
//        [btn setTitleColor:buttonItem.titleColor forState:UIControlStateNormal];
        btn.titleLabel.font = buttonItem.titleFont;
        
    }else if ([keyPath isEqualToString:@"titleColor"]) {
        [btn setTitleColor:buttonItem.titleColor forState:UIControlStateNormal];
        
    }else if ([keyPath isEqualToString:@"disabledTitleColor"]) {
        [btn setTitleColor:buttonItem.disabledTitleColor forState:UIControlStateNormal];
        
    }else if ([keyPath isEqualToString:@"highlightedTitleColor"]) {
        [btn setTitleColor:buttonItem.highlightedTitleColor forState:UIControlStateNormal];
        
    }else if ([keyPath isEqualToString:@"selectedTitleColor"]) {
        [btn setTitleColor:buttonItem.selectedTitleColor forState:UIControlStateNormal];
        
    }
    
}


#pragma mark -Setter
- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    _backgroundAlpha = backgroundAlpha;
    
    self.backgroundView.alpha = backgroundAlpha;
    self.shadowView.alpha = backgroundAlpha;
    self.statusBar.alpha = backgroundAlpha;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    self.titleLabel.font = titleFont;
}

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.titleLabel.textColor = titleColor;
}

- (UIColor *)titleColor
{
    return self.titleLabel.textColor;
}


- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    _attributedTitle = attributedTitle;
    
    self.titleLabel.attributedText = attributedTitle;
    [self setNeedsLayout];
}

- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = titleView;
    [self addSubview:titleView];
    [self setNeedsLayout];
}

- (UIButton *)buttonWithButtonItem:(KSNavigationButtonItem *)buttonItem index:(NSInteger)index action:(SEL)action
{
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = buttonItem.titleFont;
    [btn setTitle:buttonItem.title forState:UIControlStateNormal];
    [btn setImage:buttonItem.image forState:UIControlStateNormal];
    [btn setImage:buttonItem.highlightedImage forState:UIControlStateHighlighted];
    [btn setImage:buttonItem.disabledImage forState:UIControlStateDisabled];
    [btn setImage:buttonItem.disabledImage forState:UIControlStateSelected];
    
    [btn setTitleColor:buttonItem.titleColor forState:UIControlStateNormal];
    [btn setTitleColor:buttonItem.selectedTitleColor forState:UIControlStateSelected];
    [btn setTitleColor:buttonItem.highlightedTitleColor forState:UIControlStateHighlighted];
    [btn setTitleColor:buttonItem.disabledTitleColor forState:UIControlStateDisabled];
    
    btn.enabled = buttonItem.isEnabled;
    btn.selected = buttonItem.isSelected;
    btn.tag = index;
    
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setImage:buttonItem.disabledImage forState:UIControlStateDisabled];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self addSubview:btn];
    /**/
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
//    CGFloat btnW = btn.frame.size.width > 44 ? btn.frame.size.width : 44;
    /*
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:10]];
    [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];*/
                           
    [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:btn attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    return btn;
}

- (void)setupLeftButtons
{
    [self.leftButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.leftButtons removeAllObjects];
    
    UIButton *leftPreviousBtn = nil;
    for (int i = 0; i < self.leftButtonItems.count; i++) {
        
        UIButton *btn = [self buttonWithButtonItem:self.leftButtonItems[i] index:i action:@selector(leftBtnClick:)];
        
        [self.leftButtons addObject:btn];
        
        if (leftPreviousBtn) {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftPreviousBtn attribute:NSLayoutAttributeRight multiplier:1 constant:self.itemSpacing]];
        }else {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.itemInset]];
        }
        
        
        
        leftPreviousBtn = btn;
        
    }
}

- (void)setupRightButtons
{
    [self.rightButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.rightButtons removeAllObjects];
    
    UIButton *rightPreviousBtn = nil;
    for (int i = 0; i < self.rightButtonItems.count; i++) {
        
        UIButton *btn = [self buttonWithButtonItem:self.rightButtonItems[i] index:i action:@selector(rightBtnClick:)];
        
        
        [self.rightButtons addObject:btn];
        
        if (rightPreviousBtn) {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightPreviousBtn attribute:NSLayoutAttributeLeft multiplier:1 constant:-self.itemSpacing]];
        }else {
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-self.itemInset]];
        }
        
        rightPreviousBtn = btn;
        
    }

}

#pragma mark -Setter
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundView.image = backgroundImage;
}

- (void)setStatusBarImage:(UIImage *)statusBarImage
{
    _statusBarImage = statusBarImage;
    
    self.statusBar.image = statusBarImage;
}


- (void)setShadowImage:(UIImage *)shadowImage
{
    _shadowImage = shadowImage;
    
    self.shadowView.image = shadowImage;
}

- (void)setLeftButtonItems:(NSArray<KSNavigationButtonItem *> *)leftButtonItems
{
    [self removeLeftButtonItemKVO];
    _leftButtonItems = leftButtonItems;
    [self addLeftButtonItemKVO];
    
    [self setupLeftButtons];
}

- (void)setLeftButtonItem:(KSNavigationButtonItem *)leftButtonItem
{
    
    NSArray *leftButtonItems = self.leftButtonItems;
    
    if (leftButtonItems.count) {
        
        NSMutableArray *tmp = leftButtonItems.mutableCopy;
        [tmp replaceObjectAtIndex:0 withObject:leftButtonItem];
        leftButtonItems = tmp;
        
    }else {
        leftButtonItems = @[leftButtonItem];
        
    }
    
    self.leftButtonItems = leftButtonItems;
    
}

- (KSNavigationButtonItem *)leftButtonItem
{
    return self.leftButtonItems.firstObject;
}

- (void)setRightButtonItems:(NSArray<KSNavigationButtonItem *> *)rightButtonItems
{
    
    [self removeRightButtonItemKVO];
    _rightButtonItems = rightButtonItems;
    [self addRightButtonItemKVO];
    
    [self setupRightButtons];
}

- (void)setRightButtonItem:(KSNavigationButtonItem *)rightButtonItem
{
    
    NSArray *rightButtonItems = self.rightButtonItems;
    
    if (rightButtonItems.count) {
        
        NSMutableArray *tmp = rightButtonItems.mutableCopy;
        [tmp replaceObjectAtIndex:0 withObject:rightButtonItem];
        rightButtonItems = tmp;
        
    }else {
        rightButtonItems = @[rightButtonItem];
    }
    
    self.rightButtonItems = rightButtonItems;
    
}

- (KSNavigationButtonItem *)rightButtonItem
{
    return self.rightButtonItems.firstObject;
}

#pragma mark -Getter

- (UIImageView *)statusBar
{
    if (!_statusBar) {
        _statusBar = [UIImageView new];
        _statusBar.backgroundColor = [UIColor clearColor];
    }
    return _statusBar;
}

- (NSMutableArray *)leftButtons
{
    if (!_leftButtons) {
        _leftButtons = @[].mutableCopy;
    }
    return _leftButtons;
}

- (NSMutableArray *)rightButtons
{
    if (!_rightButtons) {
        _rightButtons = @[].mutableCopy;
    }
    return _rightButtons;
}

- (UIImageView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [UIImageView new];
        
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context  = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.1].CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _shadowView.image = img;
    }
    return _shadowView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [UIImageView new];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.98];
//        _backgroundView.backgroundColor = [UIColor redColor];
    }
    return _backgroundView;
}

#pragma mark -Event
- (void)leftBtnClick:(UIButton *)btn
{
    KSNavigationButtonItem *buttonItem = self.leftButtonItems[btn.tag];
    
    !buttonItem.handle ? : buttonItem.handle(buttonItem);
    
}

- (void)rightBtnClick:(UIButton *)btn
{
    KSNavigationButtonItem *buttonItem = self.rightButtonItems[btn.tag];
    
    !buttonItem.handle ? : buttonItem.handle(buttonItem);
    
}


#pragma mark -Life Cycle

+ (instancetype)navigationView
{
    KCNavigationView *navigationView = [[self alloc] init];
    
    KCNavigationView *appearance = [self appearance];
    
    navigationView.translucent = appearance.translucent;
    navigationView.itemSpacing = appearance.itemSpacing;
    navigationView.itemInset = appearance.itemInset;
    navigationView.titleColor = appearance.titleColor;
    navigationView.titleFont = appearance.titleFont;
    
    return navigationView;
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _translucent = YES;
        _itemSpacing = 5;
        _itemInset = 5;
        [self setupUI];
        [self setupLayout];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect rect = [self.superview convertRect:self.frame toView:nil];
    
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    
    self.statusBarHeightCons.constant = self.frame.origin.y;
    self.backgroundViewTopCons.constant = -self.frame.origin.y;
    
    UIButton *leftLastBtn = self.leftButtons.lastObject;
    UIButton *rightLastBtn = self.rightButtons.lastObject;
    
    CGFloat startX = 0;
    
    if (leftLastBtn) {
        startX = leftLastBtn.frame.size.width + leftLastBtn.frame.origin.x + self.itemSpacing;
    }else {
        startX += self.itemInset;
    }
    
    CGFloat endX = self.bounds.size.width;
    if (rightLastBtn) {
        endX = rightLastBtn.frame.origin.x - self.itemSpacing;
    }else {
        
        endX -= self.itemInset;
    }
    
    CGFloat maxWidth = endX - startX;
    
    [self.titleLabel sizeToFit];
    
//    CGFloat statusBarHeight = self.statusBar.frame.size.height;
    if (self.titleLabel.frame.size.width > maxWidth) {
        
        CGRect titleLabelFrame = self.titleLabel.frame;
        titleLabelFrame.origin.x = startX;
        titleLabelFrame.size.width = maxWidth;
        self.titleLabel.frame = titleLabelFrame;
        
        
        CGPoint titleLabelCenter = self.titleLabel.center;
        titleLabelCenter.y = self.frame.size.height * 0.5;
        self.titleLabel.center = titleLabelCenter;
        
        
    }else {
        
        self.titleLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    }
    
    
    if (!self.titleView) {
        
        return;
        
    }
    
    if (self.titleView.frame.size.width > maxWidth) {
        
        CGRect titleViewFrame = self.titleView.frame;
        titleViewFrame.origin.x = startX;
        titleViewFrame.size.width = maxWidth;
        self.titleView.frame = titleViewFrame;
        
        CGPoint titleViewCenter = self.titleView.center;
        titleViewCenter.y = self.frame.size.height * 0.5;
        self.titleView.center = titleViewCenter;
        
    }else {
        
        self.titleView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    }
    
    
}

#pragma mark -Private Method
- (void)setupUI
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.shadowView];
    [self addSubview:self.statusBar];
}


- (void)setupLayout {
    
//    CGFloat top = 20;
//    if (@available(iOS 11.0, *)) {
//        top = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
//    }
//    top = MAX(top, 20);

    self.statusBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    self.statusBarHeightCons = [NSLayoutConstraint constraintWithItem:self.statusBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.statusBar addConstraint:self.statusBarHeightCons];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    /**** bgView约束 *****/
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundViewTopCons = [NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:self.backgroundViewTopCons];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    /**** shadowView约束 *****/
    self.shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shadowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.shadowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.shadowView addConstraint:[NSLayoutConstraint constraintWithItem:self.shadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
    
    
}

#pragma mark -Public Method
- (void)addLeftButtonItem:(KSNavigationButtonItem *)buttonItem {
    NSMutableArray *leftButtonItems = self.leftButtonItems.mutableCopy;
    
    if (leftButtonItems) {
        [leftButtonItems addObject:buttonItem];
    }else {
        leftButtonItems = @[buttonItem].mutableCopy;
    }
    
    self.leftButtonItems = leftButtonItems;
}


- (void)addRightButtonItem:(KSNavigationButtonItem *)buttonItem {
    
    NSMutableArray *rightButtonItems = self.rightButtonItems.mutableCopy;
    
    if (rightButtonItems) {
        [rightButtonItems addObject:buttonItem];
    }else {
        rightButtonItems = @[buttonItem].mutableCopy;
    }
    
    self.rightButtonItems = rightButtonItems;
}

-(void)removeButtonItem:(KSNavigationButtonItem *)buttonItem
{
    if ([self.leftButtonItems containsObject:buttonItem]) {
        
        NSMutableArray *leftButtonItems = self.leftButtonItems.mutableCopy;
        
        [leftButtonItems removeObject:buttonItem];
        
        self.leftButtonItems = leftButtonItems;
        
    }else if ([self.rightButtonItems containsObject:buttonItem]) {
        
        NSMutableArray *rightButtonItems = self.rightButtonItems.mutableCopy;
        
        [rightButtonItems removeObject:buttonItem];
        
        self.rightButtonItems = rightButtonItems;
    }
}

- (void)insertLeftButtonItem:(KSNavigationButtonItem *)buttonItem atIndex:(NSUInteger)index {
    
    NSMutableArray *leftButtonItems = self.leftButtonItems.mutableCopy;
    
    if (leftButtonItems) {
        [leftButtonItems insertObject:buttonItem atIndex:index];
    }else {
        leftButtonItems = @[buttonItem].mutableCopy;
    }
    
    self.leftButtonItems = leftButtonItems;
    
    
}

- (void)removeLeftButtonItemAtIndex:(NSUInteger)index {
    
    if (self.leftButtonItems.count > index) {
        
        NSMutableArray *leftButtonItems = self.leftButtonItems.mutableCopy;
        [leftButtonItems removeObjectAtIndex:index];
        self.leftButtonItems = leftButtonItems;
        
    }
    
}

- (void)insertRightButtonItem:(KSNavigationButtonItem *)buttonItem atIndex:(NSUInteger)index {
    
    NSMutableArray *rightButtonItems = self.rightButtonItems.mutableCopy;
    
    if (rightButtonItems) {
        [rightButtonItems insertObject:buttonItem atIndex:index];
    }else {
        rightButtonItems = @[buttonItem].mutableCopy;
    }
    
    self.rightButtonItems = rightButtonItems;
}

- (void)removeRightButtonItemAtIndex:(NSUInteger)index {
    if (self.rightButtonItems.count > index) {
        
        NSMutableArray *rightButtonItems = self.rightButtonItems.mutableCopy;
        [rightButtonItems removeObjectAtIndex:index];
        self.rightButtonItems = rightButtonItems;
        
    }
}

- (UIButton *)buttonWithButtonItem:(KSNavigationButtonItem *)buttonItem
{
    if ([self.leftButtonItems containsObject:buttonItem]) {
        
        return self.leftButtons[[self.leftButtonItems indexOfObject:buttonItem]];
    }else if ([self.rightButtonItems containsObject:buttonItem]) {
        return self.rightButtons[[self.rightButtonItems indexOfObject:buttonItem]];
    }
    return nil;
}

- (UIButton *)leftButtonAtIndex:(NSUInteger)index
{
    if (self.leftButtons.count > index) {
        return self.leftButtons[index];
    }
    return nil;
}

- (UIButton *)rightButtonAtIndex:(NSUInteger)index
{
    
    if (self.rightButtons.count > index) {
        return self.rightButtons[index];
    }
    return nil;
}



@end
