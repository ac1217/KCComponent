//
//  KCProgressView.h
//  KCComponent
//
//  Created by Erica on 2018/8/10.
//  Copyright © 2018年 erica. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KCProgressViewStyle) {
    KCProgressViewStyleLine,  // normal progress bar
    KCProgressViewStyleCircle,
    KCProgressViewStyleRect,
    KCProgressViewStyleCustom
};

@interface KCProgressView : UIView

//- (instancetype)initWithStyle:(KCProgressViewStyle)style;

+ (instancetype)progressView;

@property(nonatomic) KCProgressViewStyle style;

@property(nonatomic, strong, nullable) UIColor* progressTextColor;
@property(nonatomic, strong, nullable) UIFont* progressTextFont;
@property(nonatomic, strong, nullable) UIColor* progressTintColor;
@property(nonatomic, strong, nullable) UIColor* trackTintColor;
//@property(nonatomic, strong, nullable) UIImage* progressImage;
//@property(nonatomic, strong, nullable) UIImage* trackImage;

// default is 5
@property(nonatomic, assign) CGFloat lineWidth;
@property(nonatomic, copy) NSString *lineCap;

@property(nonatomic, strong) UIBezierPath *path;

@property(nonatomic) float progress;
//- (void)setProgress:(float)progress animated:(BOOL)animated NS_AVAILABLE_IOS(5_0);

@end
