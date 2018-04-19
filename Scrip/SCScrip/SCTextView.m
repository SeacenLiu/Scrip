//
//  SCTextView.m
//  note
//
//  Created by SeacenLiu on 2018/4/18.
//  Copyright © 2018年 成. All rights reserved.
//

#import "SCTextView.h"
#import "UIView+UIViewScrip.h"

@interface SCTextView() <UITextViewDelegate>

/** 占位标签 */
@property (nonatomic, strong) UILabel *holderLb;

@end

static const CGFloat kHolderFS = 30.0;

@implementation SCTextView

#pragma mark - override
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self changeTextViewHeight];
}

#pragma mark - setter
- (void)setHolderString:(NSString *)holderString {
    _holderString = holderString;
    // 设置占位标签
    self.holderLb.text = holderString;
    [_holderLb sizeToFit];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setup];
        [self debug];
    }
    return self;
}

#pragma mark - setup
- (void)setup {
    self.text = @"请输入纸条内容";
    self.font = [UIFont systemFontOfSize:kHolderFS];
    self.scrollEnabled = NO;
    self.delegate = self;
    [self changeTextViewHeight];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    [self changeTextViewHeight];
}

#pragma mark - tool
- (void)debug {
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    self.layer.borderWidth = 1.0f;
}

- (void)changeTextViewHeight {
    CGSize constraintSize = CGSizeMake(self.w, MAXFLOAT);
    CGSize size = [self sizeThatFits:constraintSize];
    self.frame = CGRectMake(self.x, self.y, self.w, size.height);
}

#pragma mark - lazy
- (UILabel *)holderLb {
    if (_holderLb == nil) {
        _holderLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _holderLb.font = [UIFont systemFontOfSize:kHolderFS];
        _holderLb.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    return _holderLb;
}

@end
