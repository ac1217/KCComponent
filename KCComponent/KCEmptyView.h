//
//  KCEmptyView.h
//  KCCommon
//
//  Created by Erica on 2018/8/1.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCEmptyView;
@protocol KCEmptyViewDelegate<NSObject>

@optional
- (void)emptyViewDidClickRefreshBtn:(KCEmptyView *)emptyView;
- (void)emptyViewDidClick:(KCEmptyView *)emptyView;

@end

@interface KCEmptyView : UIView

// 此类方法返回的实例会带apprance效果
+ (instancetype)emptyView;

@property (nonatomic,weak) id<KCEmptyViewDelegate> delegate;

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *refreshTitle;

@property (nonatomic,strong) NSAttributedString *attributedTitle;
@property (nonatomic,strong) NSAttributedString *attributedDesc;
@property (nonatomic,strong) NSAttributedString *attributedreRreshTitle;

@property (nonatomic,strong) UIColor *titleColor;// apprance
@property (nonatomic,strong) UIFont *titleFont;// apprance
@property (nonatomic,strong) UIColor *descColor;// apprance
@property (nonatomic,strong) UIFont *descFont;// apprance
@property (nonatomic,strong) UIColor *refreshTitleColor;// apprance
@property (nonatomic,strong) UIFont *refreshTitleFont;// apprance

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
