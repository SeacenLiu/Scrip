//
//  SCPasterView.m
//  Scrip
//
//  Created by SeacenLiu on 2018/4/19.
//  Copyright © 2018年 成. All rights reserved.
//

#import "SCPasterView.h"
#import "UIView+UIViewScrip.h"

CG_INLINE CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t) {
    return atan2(t.b, t.a);
}


@interface SCPasterView() <UITextViewDelegate>
{
    CGPoint prevPoint;
    CGPoint touchLocation;
    CGPoint beginningPoint;
    CGPoint beginningCenter;
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

/** 是否被选中 */
@property (nonatomic, assign, getter=isSelect) BOOL select;

@end

static const CGFloat kIconSize = 24;
static const CGFloat kMaxFontSize = 500;

@implementation SCPasterView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text {
    if (self == [super initWithFrame:frame]) {
        // 设置属性初始值
        self.text = text;
        UIFont * font = [UIFont systemFontOfSize:14];
        self.curFont = font;
        self.minFontSize = font.pointSize;
        self.minSize = CGSizeMake(0.5 * frame.size.width, 0.5 * frame.size.height);
        // debug
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 1;
        self.textView.layer.borderColor = [UIColor redColor].CGColor;
        self.textView.layer.borderWidth = 1;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        self.image = [UIImage imageNamed:@"bubble"]; // bubble_graph_1.bmp
        // 设置界面
        [self setupUI];
    }
    return self;
}

#pragma mark - action
- (void)deleteClick {
    NSLog(@"deleteClick");
    [self removeFromSuperview];
}

#pragma mark - gesture
/// 旋转
- (void)rotateGestureAction:(UIPanGestureRecognizer*)recognizer {
    CGPoint center = CGRectGetCenter(self.frame);
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        touchLocation = [recognizer locationInView:self.superview];
        //求出反正切角
        deltaAngle = atan2(touchLocation.y-center.y, touchLocation.x-center.x)-CGAffineTransformGetAngle(self.transform);
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self.superview];
        float ang = atan2(point.y - self.center.y, point.x - self.center.x);
        CGFloat angleDiff = deltaAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
    }
}

/// 缩放
- (void)scaleGestureAction:(UIPanGestureRecognizer*)recognizer {
    touchLocation = [recognizer locationInView:self.superview];
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        if (self.bounds.size.width < self.minSize.width || self.bounds.size.height < self.minSize.height) {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.minSize.width, self.minSize.height);
            [self layoutSubViewWithFrame:self.bounds];
            prevPoint = [recognizer locationInView:self];
        } else {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            wChange = (point.x - prevPoint.x);
            hChange = (point.y - prevPoint.y);
            if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
                prevPoint = [recognizer locationInView:self];
                return;
            }
            if (wChange < 0.0f && hChange < 0.0f) {
                float change = MIN(wChange, hChange);
                wChange = change;
                hChange = change;
            }
            if (wChange < 0.0f) {
                hChange = wChange;
            } else if (hChange < 0.0f) {
                wChange = hChange;
            } else {
                float change = MAX(wChange, hChange);
                wChange = change;
                hChange = change;
            }
            [self layoutSubViewWithFrame:self.bounds];
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + wChange,
                                     self.bounds.size.height + hChange);
            prevPoint = [recognizer locationInView:self];
            [self changeTextFontWithisIncrease:wChange > 0];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self layoutSubViewWithFrame:self.bounds];
    }
}

// 平移
- (void)moveGestureAction:(UIPanGestureRecognizer*)recognizer {
    touchLocation = [recognizer locationInView:self.superview];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        beginningPoint = touchLocation;
        beginningCenter = self.center;
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
    }
    prevPoint = touchLocation;
}

// 单击
- (void)tapGestureAction:(UITapGestureRecognizer*)recognizer {
    self.select = !self.isSelect;
    [self.textView resignFirstResponder];
}

// 双击
- (void)doubleTapGestureAction:(UITapGestureRecognizer*)recognizer {
    [self.textView becomeFirstResponder];
}

#pragma mark - text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self endEditing:YES];
        return NO;
    }
    _isDeleting = (range.length >= 1 && text.length == 0);
    if (textView.font.pointSize <= self.minFontSize && !_isDeleting) return NO;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *calcStr = textView.text;
    
    self.textView.textContainerInset = UIEdgeInsetsZero;
    [self changeTextFontWithisIncrease:_isDeleting];
    
    [self centerTextVertically];
    [self.textView setText:calcStr];
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
- (void)setupUI {
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
    
    // 添加文本框
    [self addSubview:self.textView];
    [self sendSubviewToBack:_textView];
    [self layoutSubViewWithFrame: self.frame];
    
    // 设置文本框
    self.textView.text = _text;
    self.textView.font = [UIFont systemFontOfSize:1.0];
    if (self.minSize.height >  self.frame.size.height ||
        self.minSize.width  >  self.frame.size.width  ||
        self.minSize.height <= 0 || self.minSize.width <= 0)
    {
        self.minSize = CGSizeMake(self.frame.size.width/3.f, self.frame.size.height/3.f);
    }
    [self changeTextFontWithisIncrease:YES];
    [self centerTextVertically];
    
    // 添加手势
    [self addGestureRecognizers];
}

- (void)addGestureRecognizers {
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
    
    // 添加拖拽移动手势
    [self addGestureRecognizer:self.moveGesture];
    
    // 添加放大手势
    UIPanGestureRecognizer *scalePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleGestureAction:)];
    [self.scaleControl addGestureRecognizer:scalePan];
    
    // 添加旋转手势
    UIPanGestureRecognizer *rotatePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGestureAction:)];
    [self.rotateControl addGestureRecognizer:rotatePan];
    
    // 添加双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

#pragma mark - tool
- (void)smallTextFont {
    CGFloat cFont = self.textView.font.pointSize;
    CGSize  tSize = [self textSizeWithFont:cFont text:nil];
    while ([self isBeyondSize:tSize] && cFont > 0) {
        tSize = [self textSizeWithFont:--cFont text:nil];
    }
    [self.textView setFont:[self.curFont fontWithSize:cFont]];
}

- (void)biggerTextFont {
    CGFloat cFont = self.textView.font.pointSize;
    CGSize  tSize = [self textSizeWithFont:cFont text:nil];
    while (![self isBeyondSize:tSize] && cFont < kMaxFontSize) {
        tSize = [self textSizeWithFont:++cFont text:nil];
    }
    cFont = (cFont < kMaxFontSize) ? cFont : self.minFontSize;
    [self.textView setFont:[self.curFont fontWithSize:--cFont]];
}

- (void)changeTextFontWithisIncrease:(BOOL)isIncrease {
    self.textView.textContainerInset = UIEdgeInsetsZero;
    if ([self.textView.text length]) {
        if (isIncrease) {
            [self biggerTextFont];
        } else {
            [self smallTextFont];
        }
    }
    [self centerTextVertically];
}

- (BOOL)isBeyondSize:(CGSize)size {
    CGFloat ost = _textView.textContainerInset.top + _textView.textContainerInset.bottom;
    return size.height + ost > self.textView.frame.size.height;
}

- (CGSize)textSizeWithFont:(CGFloat)font text:(NSString *)string {
    NSString *text = string ? string : self.textView.text;
    
    CGFloat pO = self.textView.textContainer.lineFragmentPadding * 2;
    CGFloat cW = self.textView.frame.size.width - pO;
    
    CGRect tR = [text boundingRectWithSize:CGSizeMake(cW, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: [self.curFont fontWithSize:font]} context:nil];
    return tR.size;
}

- (void)centerTextVertically {
    CGSize  tH     = [self textSizeWithFont:self.textView.font.pointSize text:nil];
    CGFloat offset = (self.textView.frame.size.height - tH.height)/2.f;
    self.textView.textContainerInset = UIEdgeInsetsMake(offset, 0, offset, 0);
}

- (void)layoutSubViewWithFrame:(CGRect)frame {
    // 计算文本框位置
    CGRect tRect = frame;
    tRect.size.width = self.bounds.size.width * 0.73;
    tRect.size.height = self.bounds.size.height * 0.46;
    tRect.origin.x = (self.bounds.size.width - tRect.size.width) * 0.5;
    tRect.origin.y = self.bounds.size.height * 0.18;
    [self.textView setFrame:tRect];
    // 计算删除按钮的位置
    [self.deleteControl setFrame:CGRectMake(0, 0,kIconSize, kIconSize)];
    // 计算缩放按钮的位置
    [self.scaleControl setFrame:CGRectMake(frame.size.width-kIconSize, frame.size.height-kIconSize, kIconSize, kIconSize)];
    // 计算旋转按钮的位置
    [self.rotateControl setFrame:CGRectMake(frame.size.width-kIconSize, 0, kIconSize, kIconSize)];
}

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
        _textView.userInteractionEnabled = NO;
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.keyboardType  = UIKeyboardTypeASCIICapable;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textAlignment = NSTextAlignmentCenter;
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setTextColor:[UIColor redColor]];
        [_textView setText:nil]; [_textView setFont:nil];
        [_textView setAutocorrectionType:UITextAutocorrectionTypeNo];
        _textView.textContainerInset = UIEdgeInsetsZero;
//        _textView.layoutManager.allowsNonContiguousLayout = NO;
        [_textView textContainer].lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _textView;
}

@end
