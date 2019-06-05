//
//  SSTextView.h
//  TTReading
//
//  Created by zhangweiwei on 2019/4/25.
//  Copyright © 2019 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SSTextVerticalAlignmentTop,
    SSTextVerticalAlignmentMiddle,
    SSTextVerticalAlignmentBottom,
} SSTextVerticalAlignment;

@class SSTextView;
@protocol SSTextViewDelegate <NSObject>

@optional


- (BOOL)textView:(SSTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(SSTextView *)textView;

@end



NS_ASSUME_NONNULL_BEGIN

@interface SSTextView : UIView

@property (nonatomic, copy, nullable)  NSString  *text;
@property (nonatomic, copy, nullable)  NSString  *placeholder;

@property (nonatomic, strong, nullable)  UIFont * font;
@property (nonatomic, strong, nullable)  UIColor * textColor;

@property (nonatomic, strong, nullable)  UIColor * placeholderColor;

@property(nonatomic) UIReturnKeyType returnKeyType;

@property (nonatomic, assign)  UIEdgeInsets contentInset;

@property (nonatomic, assign) SSTextVerticalAlignment  textVerticalAliment;

@property (nonatomic, weak)  id<SSTextViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
