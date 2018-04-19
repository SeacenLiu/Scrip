//
//  UIView+UIViewScrip.m
//  note
//
//  Created by SeacenLiu on 2018/4/18.
//  Copyright © 2018年 成. All rights reserved.
//

#import "UIView+UIViewScrip.h"

@implementation UIView (UIViewScrip)

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setW:(CGFloat)w {
    CGRect rect = self.frame;
    rect.size.width = w;
    self.frame = rect;
}
- (CGFloat)w {
    return self.frame.size.width;
}

- (void)setH:(CGFloat)h {
    CGRect rect = self.frame;
    rect.size.height = h;
    self.frame = rect;
}
- (CGFloat)h {
    return self.frame.size.height;
}

- (CGRect)screenB {
    return [UIScreen mainScreen].bounds;
}

- (CGFloat)screenH {
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)screenW {
    return [UIScreen mainScreen].bounds.size.width;
}


@end
