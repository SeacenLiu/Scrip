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

CG_INLINE CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2) {
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t) {
    return atan2(t.b, t.a);
}


@interface SCPasterView() <UITextViewDelegate, UIGestureRecognizerDelegate>
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
//@property (nonatomic, assign) CGPoint prevPoint;
//@property (nonatomic, assign) CGPoint touchLocation;
//
//@property (nonatomic, assign) CGPoint beginningPoint;
//@property (nonatomic, assign) CGPoint beginningCenter;
//
//@property (nonatomic, assign) CGRect beginBounds;
//
//@property (nonatomic, assign) CGRect initialBounds;
//@property (nonatomic, assign) CGFloat initialDistance;
//
//@property (nonatomic, assign) CGFloat deltaAngle;

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
        self.minSize = CGSizeMake(60, 60 * size.height/size.width);
        // debug
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 1;
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
        self.moveGesture.delegate = self;
        
        // 添加放大手势
        UIPanGestureRecognizer *scalePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleGestureAction:)];
        [self.scaleControl addGestureRecognizer:scalePan];
        
        // 添加旋转手势
        UIPanGestureRecognizer *rotatePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGestureAction:)];
        [self.rotateControl addGestureRecognizer:rotatePan];
    }
    return self;
}

#pragma mark - action
- (void)deleteClick {
    NSLog(@"deleteClick");
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.rotateControl || touch.view == self.scaleControl) {
        return NO;
    }
    return YES;
}

#pragma mark - gesture
- (void)rotateGestureAction:(UIPanGestureRecognizer*)recognizer {
    CGPoint center = CGRectGetCenter(self.frame);
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        touchLocation = [recognizer locationInView:self.superview];
        //求出反正切角
        deltaAngle = atan2(touchLocation.y-center.y, touchLocation.x-center.x)-CGAffineTransformGetAngle(self.transform);
        initialBounds = self.bounds;
        initialDistance = CGPointGetDistance(self.center, touchLocation);
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self.superview];
        float ang = atan2(point.y - self.center.y, point.x - self.center.x);
        CGFloat angleDiff = deltaAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
    }
}

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
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            [self layoutSubViewWithFrame:self.bounds];
            prevPoint = [recognizer locationInView:self];
        }
    }
}

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
- (void)layoutSubViewWithFrame:(CGRect)frame {
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
