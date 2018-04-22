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

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

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
    // 设置绘制内容 @"啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦"
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30.0]                                                             }];
    
    // 添加居中字体
    
    
    CTTextAlignment alignment = kCTTextAlignmentCenter;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;
    
    CTLineBreakMode breakMode = kCTLineBreakByTruncatingTail;
    CTParagraphStyleSetting breakModeStyle;
    breakModeStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    breakModeStyle.valueSize = sizeof(breakMode);
    breakModeStyle.value = &breakMode;
    
    CTParagraphStyleSetting settings[] = {
        alignmentStyle,
        breakModeStyle
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    [attString addAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle  range:NSMakeRange(0, [attString length])];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    // 开始绘制
    CTFrameDraw(frame, context);
    // 释放资源
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

- (void)demo {
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
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30.0]                                                             }];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    // 开始绘制
    CTFrameDraw(frame, context);
    // 释放资源
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}


- (void)demo1 {
    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context coordinates, in iOS only.
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Initializing a graphic context in OS X is different:
    // CGContextRef context =
    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Create a path which bounds the area where you will be drawing text.
    // The path need not be rectangular.
    CGMutablePathRef path = CGPathCreateMutable();
    
    // In this simple example, initialize a rectangular path.
    CGRect bounds = self.bounds;
    CGPathAddRect(path, NULL, bounds );
    
    // Initialize a string.
    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
    
    // Create a mutable attributed string with a max length of 0.
    // The max length is a hint as to how much internal storage to reserve.
    // 0 means no hint.
    CFMutableAttributedStringRef attrString =
    CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    // Copy the textString into the newly created attrString
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0),
                                     textString);
    
    // Create a color that will be added as an attribute to the attrString.
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { 1.0, 0.0, 0.0, 0.8 };
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    
    // Set the color of the first 12 chars to red.
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12),
                                   kCTForegroundColorAttributeName, red);
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // Create a frame.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0), path, NULL);
    
    // Draw the specified frame in the given context.
    CTFrameDraw(frame, context);
    
    // Release the objects we used.
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
