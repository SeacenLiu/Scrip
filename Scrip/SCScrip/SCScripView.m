//
//  SCScripView.m
//  note
//
//  Created by SeacenLiu on 2018/4/18.
//  Copyright © 2018年 成. All rights reserved.
//

#import "SCScripView.h"
#import "UIView+UIViewScrip.h"
#import "SCTextView.h"
#import "SCPasterView.h"

@interface SCScripView()

@property (nonatomic, strong) SCTextView *mainTextView;
@property (nonatomic, strong) UIView *contentView;

@end

static const CGFloat kScripH = 10000;

@implementation SCScripView

- (void)testChangeFont:(UIFont *)font {
    self.mainTextView.font = font;
}

#pragma mark - method
- (void)testAddPaster {
    CGFloat offsetY = self.contentOffset.y;
    CGFloat y = offsetY + 40;
    CGFloat w = self.screenW - 40;
    CGFloat h = w * 10 / 13;
    CGFloat x = (self.screenW - w) * 0.5;
    CGRect rect = CGRectMake(x, y, w, h);
    SCPasterView *paster = [[SCPasterView alloc] initWithFrame:rect text:@"双击编辑文字"];
    [self.contentView addSubview:paster];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [[touches anyObject] locationInView:self.contentView];
//    CGRect rect = CGRectMake(point.x, point.y, 124.5, 100);
//    SCPasterView *paster = [[SCPasterView alloc] initWithFrame:rect text:@"双击编辑文字"];
//    [self.contentView addSubview:paster];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.contentSize = CGSizeMake(self.screenW, kScripH);
    self.backgroundColor = [UIColor brownColor];
    self.alwaysBounceVertical = YES;
    // 添加容器View
    [self addSubview:self.contentView];
    // 添加文本
    [self.contentView addSubview:self.mainTextView];
}

#pragma mark - lazy
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenW, kScripH)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (SCTextView *)mainTextView {
    if (_mainTextView == nil) {
//        CGRect rect = CGRectMake(0, 0, self.screenW, 30);
        CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        _mainTextView = [[SCTextView alloc] initWithFrame: rect];
    }
    return _mainTextView;
}

@end
