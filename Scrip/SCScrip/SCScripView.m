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

@interface SCScripView()

@property (nonatomic, strong) SCTextView *mainTextView;

@end

static const CGFloat kScripH = 10000;

@implementation SCScripView

- (void)testChangeFont:(UIFont *)font {
    self.mainTextView.font = font;
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
    self.backgroundColor = [UIColor whiteColor];
    self.alwaysBounceVertical = YES;
    // 添加文本
    [self addSubview:self.mainTextView];
}

#pragma mark - lazy
- (SCTextView *)mainTextView {
    if (_mainTextView == nil) {
//        CGRect rect = CGRectMake(0, 0, self.screenW, 30);
        CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        _mainTextView = [[SCTextView alloc] initWithFrame: rect];
    }
    return _mainTextView;
}

@end
