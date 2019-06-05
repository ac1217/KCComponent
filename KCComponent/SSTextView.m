//
//  SSTextView.m
//  TTReading
//
//  Created by zhangweiwei on 2019/4/25.
//  Copyright © 2019 ByteDance. All rights reserved.
//

#import "SSTextView.h"

@interface SSTextView()<UITextViewDelegate>

@property (nonatomic, strong)  UITextView * textView;

@property (nonatomic, strong)  UILabel * placeholderLabel;



@end

@implementation SSTextView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(size.width - self.contentInset.left - self.contentInset.right, size.height);


    newSize = [self.textView sizeThatFits:newSize];

    newSize.width += (self.contentInset.left + self.contentInset.right);
    newSize.height += (self.contentInset.top + self.contentInset.bottom);

    return newSize;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.textView];
        [self addSubview:self.placeholderLabel];

        _contentInset = UIEdgeInsetsMake(10, 5, 10, 5);

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)singleTap
{
    [self.textView becomeFirstResponder];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.origin.x = self.contentInset.left;
    textViewFrame.size.width = self.frame.size.width - self.contentInset.right - textViewFrame.origin.x;
    CGFloat maxH = self.frame.size.height - self.contentInset.bottom - self.contentInset.top;
    CGFloat textViewHeight = [self.textView sizeThatFits:CGSizeMake(textViewFrame.size.width, maxH)].height;

    textViewFrame.size.height = MIN(textViewHeight, maxH);

    switch (self.textVerticalAliment) {
        case SSTextVerticalAlignmentTop: {
            textViewFrame.origin.y = self.contentInset.top;
        }

            break;
        case SSTextVerticalAlignmentMiddle: {


            textViewFrame.origin.y = (self.frame.size.height - textViewFrame.size.height) * 0.5;

        }

            break;
        case SSTextVerticalAlignmentBottom: {

            textViewFrame.origin.y = self.frame.size.height - textViewFrame.size.height - self.contentInset.bottom;
        }

            break;

        default:
            break;
    }

    self.textView.frame = textViewFrame;
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];

    [self.placeholderLabel sizeToFit];
    CGRect placeholderLabelFrame = self.placeholderLabel.frame;
    placeholderLabelFrame.origin.x = textViewFrame.origin.x + self.contentInset.left;
    placeholderLabelFrame.size.width = textViewFrame.size.width - self.contentInset.left - self.contentInset.right;
    self.placeholderLabel.frame = placeholderLabelFrame;

    CGPoint placeholderLabelCenter = self.placeholderLabel.center;
    placeholderLabelCenter.y = self.textView.center.y;
    self.placeholderLabel.center = placeholderLabelCenter;

}

- (void)setText:(NSString *)text
{
    self.textView.text = text;

    self.placeholderLabel.hidden = self.textView.text.length;
}

- (NSString *)text
{
    return self.textView.text;
}

- (void)setFont:(UIFont *)font
{
    self.textView.font = font;
    self.placeholderLabel.font = font;
}
- (UIFont *)font
{
    return self.textView.font;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textView.textColor = textColor;
}
- (UIColor *)textColor
{
    return self.textView.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    self.textView.returnKeyType = returnKeyType;
}

- (UIReturnKeyType)returnKeyType
{
    return self.textView.returnKeyType;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
}

- (NSString *)placeholder
{
    return self.placeholderLabel.text;
}

#pragma mark -UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length;

    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }

    [self setNeedsLayout];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
       return [self.delegate textView:self shouldChangeTextInRange:range replacementText:text];
    }

    return YES;
}

- (UITextView *)textView
{
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:15];
        textView.backgroundColor = [UIColor clearColor];
        textView.returnKeyType = UIReturnKeySend;
        textView.contentInset = UIEdgeInsetsZero;
        textView.textContainerInset = UIEdgeInsetsZero;
        _textView = textView;
    }

    return _textView;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        UILabel * label = [[UILabel alloc] init];
        label.font = self.textView.font;
        label.textColor = [UIColor lightGrayColor];
        label.numberOfLines = 0;
        [label sizeToFit];
        _placeholderLabel = label;
    }

    return _placeholderLabel;
}

@end
