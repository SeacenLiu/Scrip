//
//  SCPasterView.h
//  Scrip
//
//  Created by SeacenLiu on 2018/4/19.
//  Copyright © 2018年 成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPasterView : UIImageView

@property (assign, nonatomic) CGSize      minSize;
@property (assign, nonatomic) CGFloat     minFontSize;
@property (retain, nonatomic) UIFont      *curFont;

//- (instancetype)initWithOrigin:(CGPoint)origin text:(NSString*)text;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text;

@end
