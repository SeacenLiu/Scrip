//
//  SCDisplayView.m
//  Scrip
//
//  Created by SeacenLiu on 2018/4/21.
//  Copyright © 2018年 成. All rights reserved.
//

#import "SCDisplayView.h"
#import <CoreText/CoreText.h>

@implementation SCDisplayView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 获取当前绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 旋转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // 创建绘制局域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    // 设置绘制内容
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"双击编辑内容"];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"双击编辑内容" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0]                                                             }];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    // 开始绘制
    CTFrameDraw(frame, context);
    // 释放资源
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
