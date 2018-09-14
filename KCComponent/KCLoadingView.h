//
//  KCLoadingView.h
//  KCComponent
//
//  Created by Erica on 2018/9/13.
//  Copyright © 2018年 erica. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    KCLoadingViewStyleDefault,
    KCLoadingViewStyleGif
} KCLoadingViewStyle;

@interface KCLoadingView : UIView

+ (instancetype)loadingView;

@property (nonatomic,strong) NSArray *images;
@property (nonatomic,assign) KCLoadingViewStyle style;


- (void)startAnimating;
- (void)stopAnimating;
@end
