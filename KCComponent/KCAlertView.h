//
//  KCAlertView.h
//  KCCommon
//
//  Created by Erica on 2018/8/3.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    KCAlertActionStyleDefault = 0,
    KCAlertActionStyleCancel,
    KCAlertActionStyleDestructive
} KCAlertActionStyle;

@interface KCAlertAction: NSObject

@property (nonatomic,assign) KCAlertActionStyle style;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *cancelTitleColor;
@property (nonatomic,strong) UIColor *destructiveTitleColor;
@property (nonatomic,strong) UIFont *titleFont;

@property (nonatomic,strong) NSAttributedString *attributedTitle;
@property (nonatomic,copy) void(^handler)(KCAlertAction *action);
@end

typedef enum : NSUInteger {
    KCAlertViewStyleAlert,
    KCAlertViewStyleActionSheet
} KCAlertViewStyle;

@interface KCAlertView : UIView

+ (instancetype)alertViewWithStyle:(KCAlertViewStyle)style title:(NSString *)title detail:(NSString *)detail actions:(NSArray <KCAlertAction *>*)actions;

+ (instancetype)alertView;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detail;

@property (nonatomic,strong) UIView *showView;

@property (nonatomic,strong) NSAttributedString *attributedTitle;
@property (nonatomic,strong) NSAttributedString *attributedDetail;

@property (nonatomic,strong) UIColor *titleColor;// apprance
@property (nonatomic,strong) UIFont *titleFont;// apprance
@property (nonatomic,strong) UIColor *detailColor;// apprance
@property (nonatomic,strong) UIFont *detailFont;// apprance
@property (nonatomic,strong) UIColor *contentBackgroundColor;// apprance
@property (nonatomic,strong) UIColor *separatorColor;// apprance
@property (nonatomic,strong) UIImage *buttonBackgroundImage;// apprance
@property (nonatomic,strong) UIImage *buttonHighlightedBackgroundImage;// apprance
// default YES
@property (nonatomic,assign) BOOL actionDismiss;// apprance

@property (nonatomic,assign) KCAlertViewStyle style;
@property (nonatomic,assign) BOOL backgroundDismiss;

@property (nonatomic,strong) NSArray <KCAlertAction *>*actions;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
