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

- (instancetype)initWithCustomView:(UIView *)customView
{
    if (self = [self init]) {
        _customView = customView;
    }
    return self;
}

+ (instancetype)itemWithCustomView:(UIView *)customView
{
    return [[self alloc] initWithCustomView:customView];
}

@end



/***********KCNavigationContentView*************/
@interface KCNavigationContentView: UIView


@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *titleView;

@property (nonatomic,strong) NSArray *leftBtns;
@property (nonatomic,strong) NSArray *rightBtns;

@property (nonatomic,assign) CGFloat contentSpacing;
@property (nonatomic,assign) CGFloat contentInset;

@end

@implementation KCNavigationContentView


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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSpacing = 10;
        self.contentInset = 15;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = titleView;
    if (titleView) {
       
        [self addSubview:titleView];
        self.titleLabel.hidden = YES;
    }else {
        self.titleLabel.hidden = NO;
    }
    
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

    [btn setImage:buttonItem.disabledImage forState:UIControlStateDisabled];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (void)setLeftBtns:(NSArray *)leftBtns
{
    
    [_leftBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _leftBtns = leftBtns;
    
    for (UIButton *btn in leftBtns) {
        [self addSubview:btn];
    }
    
    [self setNeedsLayout];
    
    
}

- (void)setRightBtns:(NSArray *)rightBtns
{
    [_rightBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _rightBtns = rightBtns;
    
    for (UIButton *btn in rightBtns) {
        [self addSubview:btn];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnH = self.bounds.size.height;
    CGFloat btnW = btnH;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    UIView *leftView = nil;

    for (UIView *btn in self.leftBtns) {

        if ([btn isKindOfClass:[UIButton class]]) {
            [btn sizeToFit];
            btnH = self.bounds.size.height;
        }else {
            btnH = btn.frame.size.height;
        }

        btnW = btn.frame.size.width;
        
        if (leftView) {
            btnX = CGRectGetMaxX(leftView.frame) + self.contentSpacing;
        }else {
            btnX = self.contentInset;
        }

        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);

        CGPoint btnCenter = btn.center;
        btnCenter.y = self.bounds.size.height * 0.5;
        btn.center = btnCenter;

        leftView = btn;
    }
    
    UIView *rightView = nil;
    
    for (UIView *btn in self.rightBtns) {

        if ([btn isKindOfClass:[UIButton class]]) {
            [btn sizeToFit];
            btnH = self.bounds.size.height;
        }else {
            btnH = btn.frame.size.height;
        }

        btnW = btn.frame.size.width;
        
        if (rightView) {
            btnX = rightView.frame.origin.x - self.contentSpacing - btnW;
        }else {
            btnX = self.bounds.size.width - self.contentInset - btnW;
        }
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);

        CGPoint btnCenter = btn.center;
        btnCenter.y = self.bounds.size.height * 0.5;
        btn.center = btnCenter;
        
        rightView = btn;
    }

    CGFloat left = self.contentInset;
    if (leftView) {
        left = CGRectGetMaxX(leftView.frame) + self.contentSpacing;
    }

    CGFloat right = self.bounds.size.width - self.contentInset;
    if (rightView) {
        right = rightView.frame.origin.x - self.contentSpacing;
    }
    
    CGFloat maxTitleW = right - left;
    
    CGFloat titleW = maxTitleW;
    CGFloat titleH = 0;
    if (self.titleView) {

        titleW = MIN(titleW, self.titleView.frame.size.width);

        titleH = self.titleView.frame.size.height;

        if (self.titleView.frame.size.width < maxTitleW) {

            self.titleView.frame = CGRectMake(0, 0, titleW, titleH);
            self.titleView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        }else {

            self.titleView.frame = CGRectMake(left, (self.bounds.size.height - titleH) * 0.5, titleW, titleH);
        }
    }else {
        [self.titleLabel sizeToFit];
        titleW = MIN(self.titleLabel.frame.size.width, titleW);
        titleH = self.titleLabel.frame.size.height;

        if (self.titleLabel.frame.size.width < maxTitleW) {

            self.titleLabel.frame = CGRectMake(0, 0, titleW, titleH);
            self.titleLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        }else {

            self.titleLabel.frame = CGRectMake(left, (self.bounds.size.height - titleH) * 0.5, titleW, titleH);
        }

    }
    
    
}

@end

/***********KCNavigationBackgroundView*************/
@interface KCNavigationBackgroundView: UIImageView

@property (nonatomic,strong) UIImageView *shadowView;
@property (nonatomic,strong) UIVisualEffectView *blurView;

@end

@implementation KCNavigationBackgroundView


- (UIImageView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIImageView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _shadowView;
}

- (UIVisualEffectView *)blurView
{
    if (!_blurView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    
    return _blurView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:self.blurView];
        [self addSubview:self.shadowView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.blurView.frame = self.bounds;
    
    CGFloat shadowH = self.shadowView.image ? self.shadowView.image.size.height : 1;
    
    self.shadowView.frame = CGRectMake(0, self.bounds.size.height - shadowH, self.bounds.size.width, shadowH);
}

@end


@interface KCNavigationView ()

@property (nonatomic,strong) KCNavigationBackgroundView *bgView;
@property (nonatomic,strong) KCNavigationContentView *contentView;

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
        
        btn = self.contentView.leftBtns[index];
        
    }else {
        
        NSInteger index = [self.rightButtonItems indexOfObject:object];
        
        btn = self.contentView.rightBtns[index];
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
- (void)setItemInset:(CGFloat)itemInset
{
    self.contentView.contentInset = itemInset;
}

- (CGFloat)itemInset
{
    return self.contentView.contentInset;
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    self.contentView.contentSpacing = itemSpacing;
}

- (CGFloat)itemSpacing
{
    return self.contentView.contentSpacing;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    self.bgView.alpha = backgroundAlpha;
}

- (CGFloat)backgroundAlpha
{
    return self.bgView.alpha;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.bgView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor
{
    return self.bgView.backgroundColor;
}

- (void)setTitle:(NSString *)title
{
    self.contentView.titleLabel.text = title;
    [self.contentView setNeedsLayout];
    
}

- (NSString *)title
{
    return self.contentView.titleLabel.text;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    self.contentView.titleLabel.font = titleFont;
}

- (UIFont *)titleFont
{
    return self.contentView.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.contentView.titleLabel.textColor = titleColor;
}

- (UIColor *)titleColor
{
   return  self.contentView.titleLabel.textColor;
}


- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    self.contentView.titleLabel.attributedText = attributedTitle;
}

- (NSAttributedString *)attributedTitle
{
    return self.contentView.titleLabel.attributedText;
}

- (void)setTitleView:(UIView *)titleView
{
    self.contentView.titleView = titleView;
}

- (UIView *)titleView
{
    return self.contentView.titleView;
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
    
    [btn setImage:buttonItem.disabledImage forState:UIControlStateDisabled];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setupLeftButtons
{
    
    NSMutableArray *btns = @[].mutableCopy;
    for (int i = 0; i < self.leftButtonItems.count; i++) {

        KSNavigationButtonItem *item = self.leftButtonItems[i];

        if (item.customView) {

            [btns addObject:item.customView];

        }else {

            UIButton *btn = [self buttonWithButtonItem:item index:i action:@selector(leftBtnClick:)];

            [btns addObject:btn];
        }
        
    }
    
    self.contentView.leftBtns = btns;
    
}

- (void)setupRightButtons
{
    
    NSMutableArray *btns = @[].mutableCopy;
    for (int i = 0; i < self.rightButtonItems.count; i++) {

        KSNavigationButtonItem *item = self.rightButtonItems[i];

        if (item.customView) {

            [btns addObject:item.customView];

        }else {

            UIButton *btn = [self buttonWithButtonItem:item index:i action:@selector(rightBtnClick:)];


            [btns addObject:btn];
        }

        
    }
    self.contentView.rightBtns = btns;

}

#pragma mark -Setter
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.bgView.image = backgroundImage;
}

- (UIImage *)backgroundImage
{
    return self.bgView.image;
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    self.bgView.shadowView.image = shadowImage;
}

- (UIImage *)shadowImage
{
    return self.bgView.shadowView.image;
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

- (KCNavigationContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[KCNavigationContentView alloc] init];
    }
    return _contentView;
}

- (KCNavigationBackgroundView *)bgView
{
    if (!_bgView) {
        _bgView = [[KCNavigationBackgroundView alloc] init];
    }
    return _bgView;
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
    navigationView.backgroundColor = appearance.backgroundColor;
    
    
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
//        _itemSpacing = 5;
//        _itemInset = 5;
        [self setupUI];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat topInset = 0;
    if (@available(iOS 11.0, *)) {
        topInset = self.window.safeAreaInsets.top;
    }
    
    self.bgView.frame = CGRectMake(0, -topInset, self.bounds.size.width, self.bounds.size.height + topInset);

    CGFloat contentViewH = 44;
    CGFloat contentViewY = 0.5 * (self.frame.size.height - contentViewH);
    self.contentView.frame = CGRectMake(0, contentViewY, self.bounds.size.width, contentViewH);
    
}

#pragma mark -Private Method
- (void)setupUI
{
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
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


@end
