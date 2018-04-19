//
//  SCPasterView.m
//  Scrip
//
//  Created by SeacenLiu on 2018/4/19.
//  Copyright © 2018年 成. All rights reserved.
//

#import "SCPasterView.h"
#import "UIView+UIViewScrip.h"

#define MAX_FONT_SIZE 500

@interface SCPasterView() <UITextViewDelegate>
{
    CGPoint prevPoint;
    CGPoint touchLocation;
    
    CGPoint beginningPoint;
    CGPoint beginningCenter;
    
    CGRect beginBounds;
    
    CGRect initialBounds;
    CGFloat initialDistance;
    
    CGFloat deltaAngle;
}

/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteControl;
/** 旋转图片 */
@property (nonatomic, strong) UIImageView *rotateControl;
/** 缩放图片 */
@property (nonatomic, strong) UIImageView *scaleControl;
/** 文本框 */
@property (nonatomic, strong) UITextView *textView;

/** 拖拽手势--用于移动贴图 */
@property (nonatomic, strong) UIPanGestureRecognizer *moveGesture;

@property (nonatomic, assign) BOOL isDeleting;

@property (nonatomic, assign, getter=isSelect) BOOL select;

@end

static const CGFloat kIconSize = 24;

@implementation SCPasterView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

#pragma mark - init 124.5
- (instancetype)initWithOrigin:(CGPoint)origin size:(CGSize)size text:(NSString*)text {
    if (self == [super initWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height)]) {
        // 图片初始化设置
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        self.image = [UIImage imageNamed:@"bubble_graph_1.bmp"];
        // 设置属性初始值
        UIFont * font = [UIFont systemFontOfSize:14];
        self.curFont = font;
        self.minFontSize = font.pointSize;
        // 添加文本框
        [self addSubview:self.textView];
        [self sendSubviewToBack:self.textView];
        
        // 添加删除按钮
        [self addSubview:self.deleteControl];
        [_deleteControl addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteControl.frame = CGRectMake(0, 0, kIconSize, kIconSize);
        _deleteControl.hidden = YES;
        
        // 添加旋转按钮
        [self addSubview:self.rotateControl];
        _rotateControl.frame = CGRectMake(self.w-kIconSize, 0, kIconSize, kIconSize);
        _rotateControl.hidden = YES;
        
        // 添加缩放按钮
        [self addSubview:self.scaleControl];
        _scaleControl.frame = CGRectMake(self.w-kIconSize, self.h-kIconSize, kIconSize, kIconSize);
        _scaleControl.hidden = YES;
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tap];
        
        // 添加拖拽移动手势
        [self addGestureRecognizer:self.moveGesture];
    }
    return self;
}

#pragma mark - action
- (void)deleteClick {
    NSLog(@"deleteClick");
}

#pragma mark - gesture
- (void)tapGestureAction:(UITapGestureRecognizer*)recognizer {
    self.select = !self.isSelect;
}

- (void)moveGestureAction:(UIPanGestureRecognizer*)recognizer {
    touchLocation = [recognizer locationInView:self.superview];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        beginningPoint = touchLocation;
        beginningCenter = self.center;
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
        beginBounds = self.bounds;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
    }
    prevPoint = touchLocation;
}

#pragma mark - setter
- (void)setSelect:(BOOL)select {
    _select = select;
    self.deleteControl.hidden = !select;
    self.rotateControl.hidden = !select;
    self.scaleControl.hidden = !select;
    self.moveGesture.enabled = select;
}

#pragma mark - setup


#pragma mark - tool


#pragma mark - lazy
- (UIPanGestureRecognizer *)moveGesture {
    if (_moveGesture == nil) {
        _moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureAction:)];
        _moveGesture.enabled = NO;
    }
    return _moveGesture;
}

- (UIButton *)deleteControl {
    if (_deleteControl == nil) {
        _deleteControl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kIconSize, kIconSize)];
        [_deleteControl setImage:[UIImage imageNamed:@"ico_notebook_remove_unchecked"] forState:UIControlStateNormal];
        [_deleteControl setImage:[UIImage imageNamed:@"ico_notebook_remove_checked"] forState:UIControlStateHighlighted];
    }
    return _deleteControl;
}

- (UIImageView *)rotateControl {
    if (_rotateControl == nil) {
        _rotateControl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconSize, kIconSize)];
        _rotateControl.userInteractionEnabled = YES;
        _rotateControl.image = [UIImage imageNamed:@"ico_discover_unchecked"];
    }
    return _rotateControl;
}

- (UIImageView *)scaleControl {
    if (_scaleControl == nil) {
        _scaleControl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconSize, kIconSize)];
        _scaleControl.userInteractionEnabled = YES;
        _scaleControl.image = [UIImage imageNamed:@"ico_conversion_unchecked"];
    }
    return _scaleControl;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.keyboardType  = UIKeyboardTypeASCIICapable;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textAlignment = NSTextAlignmentCenter;
        [_textView setBackgroundColor:[UIColor whiteColor]];
        [_textView setTextColor:[UIColor redColor]];
        [_textView setText:nil]; [_textView setFont:nil];
        [_textView setAutocorrectionType:UITextAutocorrectionTypeNo];
        _textView.textContainerInset = UIEdgeInsetsZero;
    }
    return _textView;
}


@end
